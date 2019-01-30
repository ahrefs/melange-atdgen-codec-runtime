open Printf

module Json = struct
  type t = Js.Json.t
  external read_t : t -> t = "%identity"
  external write_t : t -> t = "%identity"
end

module Json_adapter = struct
  module type S = sig
    val normalize : Json.t -> Json.t
    val restore : Json.t -> Json.t
  end

  module Type_field = struct

    module type Param = sig
      val type_field_name : string
    end

    module Make(Param:Param) : S = struct
      open Param

      let normalize (json : Json.t) =
        let open Json_decode in
        match json |> (at ["type"] string) with
        | type_ ->
            let normalized: Json.t = Obj.magic (type_, json) in
            normalized
        | exception Invalid_argument _ -> json

      let restore json =
        match json |> Js.Json.classify with
        | JSONArray [|v; o|] when Js.typeof v = "string" ->
            begin match o |> Js.Json.classify with
              | JSONObject obj ->
                  Js.Dict.set obj type_field_name v;
                  Json_encode.dict obj
              | _ -> json
            end
        | _ -> json
    end

    module Default_param : Param = struct
      let type_field_name = "type"
    end

    include Make(Default_param)
  end

  module Kind_field =
    Type_field.Make(struct
      let type_field_name = "kind"
    end)
end

module Encode = struct

  include Json_encode

  type 'a t = 'a encoder

  let make f = f

  let encode f x = f x

  let unit () = null

  let int32 s = string (Int32.to_string s)
  let int64 s = string (Int64.to_string s)

  type ('a, 'b) spec =
    { name: string
    ; data: 'a
    ; encode: 'b t
    }

  type 'a field_spec =
    | Optional of ('a option, 'a) spec * 'a option
    | Required of ('a, 'a) spec * 'a option

  type field = F : 'a field_spec -> field

  let list encode l =
    l |> Array.of_list
      |> Array.map encode
      |> jsonArray

  let field ?default encode ~name data =
    F (Required (
      { name
      ; data
      ; encode
      }, default
    ))

  let field_o ?default encode ~name data =
    F (Optional (
      { name
      ; data
      ; encode
      }, default
    ))

  let obj fields =
    List.fold_left (fun acc (F f) ->
      match f with
      | Required ({ name; data; encode}, None) ->
          (name, encode data)::acc
      | Required ({ name; data; encode}, Some default) ->
          if default = data then
            acc
          else
            (name, encode data)::acc
      | Optional ({ name; data; encode}, default) ->
          match data, default with
          | None, _ -> acc
          | Some s, Some default ->
              if s = default then
                acc
              else
                (name, encode s)::acc
          | Some s, None ->
              (name, encode s)::acc
    ) [] fields
    |> object_

  let tuple1 f x = jsonArray [|f x|]

  let contramap f g b = g (f b)

  let constr0 = string
  let constr1 s f x = pair string f (s,x)

  let option_as_constr f = function
    | None -> string "None"
    | Some s -> pair string f ("Some", s)

  let adapter (restore: Json.t -> Json.t) (writer: 'a t) x =
    let encoded = writer x in
    restore encoded

end

module Decode =
struct

  include Json_decode

  type 'a t = 'a decoder

  let make f = f

  let decode f json = f json

  let unit j =
    if (Obj.magic j : 'a Js.null) == Js.null
    then ()
    else raise (DecodeError (sprintf "Expected null, got %s" (Js.Json.stringify j)))

  let int32 j = Int32.of_string (string j)
  let int64 j = Int64.of_string (string j)

  let obj_array f json =
    dict f json
    |> Js.Dict.entries

  let obj_list f json =
    obj_array f json
    |> Array.to_list

  let nullable decode json =
    if (Obj.magic json : 'a Js.null) == Js.null then
      None
    else
      Some (decode json)

  let fieldOptional s f = optional (field s f)

  let fieldDefault s default f =
    fieldOptional s f
    |> map (function
      | None -> default
      | Some s -> s)

  let tuple1 f x =
    if Js.Array.isArray x then begin
      let source = (Obj.magic (x : Js.Json.t) : Js.Json.t array) in
      let length = Js.Array.length source in
      if length = 1 then
        try
          f (Array.unsafe_get source 0)
        with
          DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin tuple1")
      else
        raise @@ DecodeError ({j|Expected array of length 1, got array of length $length|j})
    end
    else
      raise @@ DecodeError ("Expected array, got " ^ (Js.Json.stringify x))

  let enum l =
    let constr0 x =
      let s = string x in
      match List.assoc s l with
      | exception Not_found -> raise @@ DecodeError (sprintf "unknown constructor %S" s)
      | `Single a -> a
      | `Decode _ -> raise @@ DecodeError (sprintf "constructor %S expects arguments" s)
    in
    let constr x =
      let (s,args) = pair string (fun x -> x) x in
      match List.assoc s l with
      | exception Not_found -> raise @@ DecodeError (sprintf "unknown constructor %S" s)
      | `Single _ -> raise @@ DecodeError (sprintf "constructor %S doesn't expect arguments" s)
      | `Decode d -> decode d args
    in
    either constr0 constr

  let option_as_constr f =
    either
      (fun x ->
         if string x = "None"
         then None
         else raise (DecodeError (sprintf "Expected None, got %s" (Js.Json.stringify x))))
      (fun x ->
         match pair string f x with
         | ("Some",v) -> Some v
         | _ -> raise (DecodeError (sprintf "Expected Some _, got %s" (Js.Json.stringify x))))

  let adapter (normalize: Json.t -> Json.t) (reader: 'a t) json =
    reader (normalize json)

end
