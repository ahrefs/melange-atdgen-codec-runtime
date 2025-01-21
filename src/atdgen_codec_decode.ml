include Json.Decode

exception DecodeErrorPath of string list * string

type 'a t = 'a decoder

let make f = f

let decode' f json = f json

let decode f json =
  try f json
  with DecodeErrorPath (path, msg) ->
    let path = String.concat "." path in
    raise (DecodeError (Json_error {j|$path: $msg|j}))

let with_segment segment f json =
  try f json with
  | DecodeError (Json_error msg) -> raise (DecodeErrorPath ([ segment ], msg))
  | DecodeErrorPath (path, msg) ->
      raise (DecodeErrorPath (segment :: path, msg))

let unit j =
  if Js.Json.test j Null then ()
  else raise (DecodeError (Json_error ("Expected null, got " ^ Js.Json.stringify j)))

let int32 j = Int32.of_string (string j)

let int64 j = Int64.of_string (string j)

let array decode json =
  if Js.Array.isArray json then (
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    let target = Belt.Array.makeUninitializedUnsafe length in
    for i = 0 to length - 1 do
      let value =
        try with_segment (string_of_int i) decode (Array.unsafe_get source i)
        with DecodeError (Json_error msg) ->
          raise @@ DecodeError (Json_error (msg ^ "\n\tin array at index " ^ string_of_int i))
      in
      Array.unsafe_set target i value
    done;
    target)
  else raise @@ DecodeError (Json_error ("Expected array, got " ^ Js.Json.stringify json))

let list decode json = json |> array decode |> Array.to_list

let pair decodeA decodeB json =
  if Js.Array.isArray json then
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    if length = 2 then
      try
        ( with_segment "0" decodeA (Array.unsafe_get source 0),
          with_segment "1" decodeB (Array.unsafe_get source 1) )
      with DecodeError (Json_error msg) -> raise @@ DecodeError (Json_error (msg ^ "\n\tin pair/tuple2"))
    else
      let length_str = string_of_int length in
      raise
      @@ DecodeError
           (Json_error {j|Expected array of length 2, got array of length $length_str|j})
  else raise @@ DecodeError (Json_error ("Expected array, got " ^ Js.Json.stringify json))

let tuple2 = pair

let tuple3 decodeA decodeB decodeC json =
  if Js.Array.isArray json then
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    if length = 3 then
      try
        ( with_segment "0" decodeA (Array.unsafe_get source 0),
          with_segment "1" decodeB (Array.unsafe_get source 1),
          with_segment "2" decodeC (Array.unsafe_get source 2) )
      with DecodeError (Json_error msg) -> raise @@ DecodeError (Json_error (msg ^ "\n\tin tuple3"))
    else
      let length_str = string_of_int length in
      raise
      @@ DecodeError
           (Json_error {j|Expected array of length 3, got array of length $length_str|j})
  else raise @@ DecodeError (Json_error ("Expected array, got " ^ Js.Json.stringify json))

let tuple4 decodeA decodeB decodeC decodeD json =
  if Js.Array.isArray json then
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    if length = 4 then
      try
        ( with_segment "1" decodeA (Array.unsafe_get source 0),
          with_segment "2" decodeB (Array.unsafe_get source 1),
          with_segment "3" decodeC (Array.unsafe_get source 2),
          with_segment "4" decodeD (Array.unsafe_get source 3) )
      with DecodeError (Json_error msg) -> raise @@ DecodeError (Json_error (msg ^ "\n\tin tuple4"))
    else
      let length_str = string_of_int length in
      raise
      @@ DecodeError
           (Json_error {j|Expected array of length 4, got array of length $length_str|j})
  else raise @@ DecodeError (Json_error ("Expected array, got " ^ Js.Json.stringify json))

let dict decode json =
  if Js.Json.test json Object then (
    let source = (Obj.magic (json : Js.Json.t) : Js.Json.t Js.Dict.t) in
    let keys = Js.Dict.keys source in
    let l = Js.Array.length keys in
    let target = Js.Dict.empty () in
    for i = 0 to l - 1 do
      let key = Array.unsafe_get keys i in
      let value =
        try with_segment key decode (Js.Dict.unsafeGet source key)
        with DecodeError (Json_error msg) -> raise @@ DecodeError (Json_error (msg ^ "\n\tin dict"))
      in
      Js.Dict.set target key value
    done;
    target)
  else raise @@ DecodeError (Json_error ("Expected object, got " ^ Js.Json.stringify json))

let field key decode json =
  if Js.Json.test json Object then
    let dict = (Obj.magic (json : Js.Json.t) : Js.Json.t Js.Dict.t) in
    match Js.Dict.get dict key with
    | Some value -> (
        try with_segment key decode value
        with DecodeError (Json_error msg) ->
          raise @@ DecodeError (Json_error (msg ^ "\n\tat field '" ^ key ^ "'")))
    | None -> raise @@ DecodeError (Json_error {j|Expected field '$(key)'|j})
  else raise @@ DecodeError (Json_error ("Expected object, got " ^ Js.Json.stringify json))

let obj_array f json = dict f json |> Js.Dict.entries

let obj_list f json = obj_array f json |> Array.to_list

let nullable decode json =
  if Js.Json.test json Null then None else Some (decode json)

(* Unlike Json_decode.field, this returns None if key is not found *)
let fieldOptional key decode json =
  if Js.Json.test json Object then
    let dict = (Obj.magic (json : Js.Json.t) : Js.Json.t Js.Dict.t) in
    match Js.Dict.get dict key with
    | None -> None
    (* treat fields with null values as missing fields (atdgen's default) *)
    | Some value when (Js.Json.test value Null) -> None
    | Some value -> (
        try Some (with_segment key decode value)
        with DecodeError (Json_error msg) ->
          raise @@ DecodeError (Json_error (msg ^ "\n\tat field '" ^ key ^ "'")))
  else raise @@ DecodeError (Json_error ("Expected object, got " ^ Js.Json.stringify json))

let fieldDefault s default f =
  fieldOptional s f |> map (function None -> default | Some s -> s)

let tuple1 f x =
  if Js.Array.isArray x then
    let source = (Obj.magic (x : Js.Json.t) : Js.Json.t array) in
    let length = Js.Array.length source in
    if length = 1 then
      try with_segment "0" f (Array.unsafe_get source 0)
      with DecodeError (Json_error msg) -> raise @@ DecodeError (Json_error (msg ^ "\n\tin tuple1"))
    else
      let length_str = string_of_int length in
      raise
      @@ DecodeError (Json_error {j|Expected array of length 1, got array of length $length_str|j})
  else raise @@ DecodeError (Json_error ("Expected array, got " ^ Js.Json.stringify x))

let enum l json =
  let constr0 j =
    let s = string j in
    `Constr0 s
  in
  let constr j =
    let p = pair string (fun x -> x) j in
    `Constr p
  in
  match either constr0 constr json with
  | `Constr0 s ->
      with_segment s
        (fun () ->
          match List.assoc s l with
          | exception Not_found ->
              raise @@ DecodeError (Json_error {j|unknown constructor "$s"|j})
          | `Single a -> a
          | `Decode _ ->
              raise @@ DecodeError (Json_error {j|constructor "$s" expects arguments|j}))
        ()
  | `Constr (s, args) ->
      with_segment s
        (fun () ->
          match List.assoc s l with
          | exception Not_found ->
              raise @@ DecodeError (Json_error {j|unknown constructor "$s"|j})
          | `Single _ ->
              raise
              @@ DecodeError (Json_error {j|constructor "$s" doesn't expect arguments|j})
          | `Decode d -> decode' d args)
        ()

let option_as_constr f =
  either
    (fun x ->
      if string x = "None" then None
      else raise (DecodeError (Json_error ("Expected None, got " ^ Js.Json.stringify x))))
    (fun x ->
      match pair string f x with
      | "Some", v -> Some v
      | _ -> raise (DecodeError (Json_error ("Expected Some _, got " ^ Js.Json.stringify x))))

let adapter (normalize : Js.Json.t -> Js.Json.t) (reader : 'a t) json =
  reader (normalize json)
