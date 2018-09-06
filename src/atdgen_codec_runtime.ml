open Printf

module Json = struct
  type t = Js.Json.t
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
    | Optional of ('a option, 'a) spec
    | Required of ('a, 'a) spec * 'a option

  type field = F : 'a field_spec -> field

  let field ?default encode ~name data =
    F (Required (
      { name
      ; data
      ; encode
      }, default
    ))

  let field_o encode ~name data =
    F (Optional (
      { name
      ; data
      ; encode
      }
    ))

  let obj fields =
    List.fold_left (fun acc (F f) ->
      match f with
      | Required ({ name; data; encode}, _) ->
        (name, encode data)::acc
      | Optional { name; data; encode} ->
        match data with
        | None -> acc
        | Some s -> (name, encode s)::acc
    ) [] fields
    |> object_

  let contramap f g b = g (f b)

  let constr0 = string
  let constr1 s f x = pair string f (s,x)

  let option_as_constr f = function
    | None -> string "None"
    | Some s -> pair string f ("Some", s)

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

end
