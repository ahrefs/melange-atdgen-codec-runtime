include Json.Encode

type 'a t = 'a encoder

let make f = f

let encode f x = f x

let unit () = null

let int32 s = string (Int32.to_string s)

let int64 s = string (Int64.to_string s)

type ('a, 'b) spec = { name : string; data : 'a; encode : 'b t }

type 'a field_spec =
  | Optional of ('a option, 'a) spec * 'a option
  | Required of ('a, 'a) spec * 'a option

type field = F : 'a field_spec -> field

let list encode l = l |> Array.of_list |> array encode

let field ?default encode ~name data =
  F (Required ({ name; data; encode }, default))

let field_o ?default encode ~name data =
  F (Optional ({ name; data; encode }, default))

let obj fields =
  List.fold_left
    (fun acc (F f) ->
      match f with
      | Required ({ name; data; encode }, None) -> (name, encode data) :: acc
      | Required ({ name; data; encode }, Some default) ->
          if default = data then acc else (name, encode data) :: acc
      | Optional ({ name; data; encode }, default) -> (
          match (data, default) with
          | None, _ -> acc
          | Some s, Some default ->
              if s = default then acc else (name, encode s) :: acc
          | Some s, None -> (name, encode s) :: acc))
    [] fields
  |> object_

let tuple1 f x = jsonArray [| f x |]

let contramap f g b = g (f b)

let constr0 = string

let constr1 s f x = pair string f (s, x)

let option_as_constr f = function
  | None -> string "None"
  | Some s -> pair string f ("Some", s)

let adapter (restore : Js.Json.t -> Js.Json.t) (writer : 'a t) x =
  let encoded = writer x in
  restore encoded
