external _unsafeCreateUninitializedArray : int -> 'a array = "Array" [@@bs.new]
external _stringify : Js.Json.t -> string = "JSON.stringify" [@@bs.val]

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
        match json |> Js.Json.classify with
          | JSONObject obj ->
            begin match Js.Dict.get obj type_field_name with
              | Some type_ ->
                let normalized: Json.t = Obj.magic (type_, json) in
                normalized
              | None -> json
            end
          | _ -> json

      let restore json =
        match json |> Js.Json.classify with
        | JSONArray [|v; o|] when Js.typeof v = "string" ->
            begin match o |> Js.Json.classify with
              | JSONObject obj ->
                  Js.Dict.set obj type_field_name v;
                  Json_encode.jsonDict obj
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
    l |> Array.of_list |> array encode

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

module Decode = struct

  include Json_decode

  exception DecodeErrorPath of string list * string

  type 'a t = 'a decoder

  let make f = f

  let decode' f json = f json

  let decode f json =
    try decode' f json with
    | DecodeErrorPath (path, msg) ->
      let path = String.concat "." path in
      raise (DecodeError {j|$path: $msg|j})

  let with_segment segment f json =
    try f json with
    | DecodeError msg -> raise (DecodeErrorPath ([segment], msg))
    | DecodeErrorPath (path, msg) -> raise (DecodeErrorPath (segment :: path, msg))

  let unit j =
    if (Obj.magic j : 'a Js.null) == Js.null
    then ()
    else raise (DecodeError (sprintf "Expected null, got %s" (Js.Json.stringify j)))

  let int32 j = Int32.of_string (string j)
  let int64 j = Int64.of_string (string j)

  let array decode json = 
    if Js.Array.isArray json then begin
      let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
      let length = Js.Array.length source in
      let target = _unsafeCreateUninitializedArray length in
      for i = 0 to length - 1 do
        let value = 
          try
            with_segment (string_of_int i) decode (Array.unsafe_get source i)
          with
            DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin array at index " ^ string_of_int i)
          in
        Array.unsafe_set target i value;
      done;
      target
    end
    else
      raise @@ DecodeError ("Expected array, got " ^ _stringify json)

  let list decode json =
    json |> array decode |> Array.to_list

  let pair decodeA decodeB json =
    if Js.Array.isArray json then begin
      let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
      let length = Js.Array.length source in
      if length = 2 then
        try
          with_segment "0" decodeA (Array.unsafe_get source 0),
          with_segment "1" decodeB (Array.unsafe_get source 1)
        with
          DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin pair/tuple2")
      else
        raise @@ DecodeError ({j|Expected array of length 2, got array of length $length|j})
    end
    else
      raise @@ DecodeError ("Expected array, got " ^ _stringify json)

  let tuple2 = pair

  let tuple3 decodeA decodeB decodeC json =
    if Js.Array.isArray json then begin
      let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
      let length = Js.Array.length source in
      if length = 3 then
        try
          with_segment "0" decodeA (Array.unsafe_get source 0),
          with_segment "1" decodeB (Array.unsafe_get source 1),
          with_segment "2" decodeC (Array.unsafe_get source 2)
        with
          DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin tuple3")
      else
        raise @@ DecodeError ({j|Expected array of length 3, got array of length $length|j})
    end
    else
      raise @@ DecodeError ("Expected array, got " ^ _stringify json)

  let tuple4 decodeA decodeB decodeC decodeD json =
    if Js.Array.isArray json then begin
      let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
      let length = Js.Array.length source in
      if length = 4 then
        try
          with_segment "1" decodeA (Array.unsafe_get source 0),
          with_segment "2" decodeB (Array.unsafe_get source 1),
          with_segment "3" decodeC (Array.unsafe_get source 2),
          with_segment "4" decodeD (Array.unsafe_get source 3)
        with
          DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin tuple4")
      else
        raise @@ DecodeError ({j|Expected array of length 4, got array of length $length|j})
    end
    else
      raise @@ DecodeError ("Expected array, got " ^ _stringify json)

  let dict decode json = 
    if Js.typeof json = "object" && 
        not (Js.Array.isArray json) && 
        not ((Obj.magic json : 'a Js.null) == Js.null)
    then begin
      let source = (Obj.magic (json : Js.Json.t) : Js.Json.t Js.Dict.t) in
      let keys = Js.Dict.keys source in
      let l = Js.Array.length keys in
      let target = Js.Dict.empty () in
      for i = 0 to l - 1 do
          let key = (Array.unsafe_get keys i) in
          let value =
            try
              with_segment key decode (Js.Dict.unsafeGet source key)
            with
              DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin dict")
            in
          Js.Dict.set target key value;
      done;
      target
    end
    else
      raise @@ DecodeError ("Expected object, got " ^ _stringify json)

  let field key decode json =
    if 
      Js.typeof json = "object" && 
      not (Js.Array.isArray json) && 
      not ((Obj.magic json : 'a Js.null) == Js.null)
    then begin
      let dict =
        (Obj.magic (json : Js.Json.t) : Js.Json.t Js.Dict.t) in
      match Js.Dict.get dict key with
      | Some value -> begin
        try
          with_segment key decode value
        with
          DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tat field '" ^ key ^ "'")
        end
      | None ->
        raise @@ DecodeError ({j|Expected field '$(key)'|j})
    end
    else
      raise @@ DecodeError ("Expected object, got " ^ _stringify json)

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

  (* Unlike Json_decode.field, this returns None if key is not found *)
  let fieldOptional key decode json =
    if
      Js.typeof json = "object" &&
      not (Js.Array.isArray json) &&
      not ((Obj.magic json : 'a Js.null) == Js.null)
    then begin
      let dict =
        (Obj.magic (json : Js.Json.t) : Js.Json.t Js.Dict.t) in
      match Js.Dict.get dict key with
      | None -> None
      | Some value -> begin
        try
          Some (with_segment key decode value)
        with
          DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tat field '" ^ key ^ "'")
        end
    end
    else
      raise @@ DecodeError ("Expected object, got " ^ Js.Json.stringify json)

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
          with_segment "0" f (Array.unsafe_get source 0)
        with
          DecodeError msg -> raise @@ DecodeError (msg ^ "\n\tin tuple1")
      else
        raise @@ DecodeError ({j|Expected array of length 1, got array of length $length|j})
    end
    else
      raise @@ DecodeError ("Expected array, got " ^ (Js.Json.stringify x))

  let enum l json =
    let constr0 j = let s = string j in `Constr0 s in
    let constr j = let p = pair string (fun x -> x) j in `Constr p in
    match either constr0 constr json with
    | `Constr0 s -> with_segment s (fun () ->
      match List.assoc s l with
      | exception Not_found -> raise @@ DecodeError (sprintf "unknown constructor %S" s)
      | `Single a -> a
      | `Decode _ -> raise @@ DecodeError (sprintf "constructor %S expects arguments" s)
      ) ()
    | `Constr (s, args) -> with_segment s (fun () ->
      match List.assoc s l with
      | exception Not_found -> raise @@ DecodeError (sprintf "unknown constructor %S" s)
      | `Single _ -> raise @@ DecodeError (sprintf "constructor %S doesn't expect arguments" s)
      | `Decode d -> decode' d args
      ) ()

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
