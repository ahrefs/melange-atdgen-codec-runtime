module type S = sig
  val normalize : Js.Json.t -> Js.Json.t

  val restore : Js.Json.t -> Js.Json.t
end

module Type_field = struct
  module type Param = sig
    val type_field_name : string
  end

  module Make (Param : Param) : S = struct
    open Param

    let normalize (json : Js.Json.t) =
      match json |> Js.Json.classify with
      | JSONObject obj -> (
          match Js.Dict.get obj type_field_name with
          | Some type_ ->
              let normalized : Js.Json.t = Obj.magic (type_, json) in
              normalized
          | None -> json)
      | _ -> json

    let restore json =
      match json |> Js.Json.classify with
      | JSONArray [| v; o |] when Js.typeof v = "string" -> (
          match o |> Js.Json.classify with
          | JSONObject obj ->
              Js.Dict.set obj type_field_name v;
              Json_encode.jsonDict obj
          | _ -> json)
      | _ -> json
  end

  module Default_param : Param = struct
    let type_field_name = "type"
  end

  include Make (Default_param)
end
