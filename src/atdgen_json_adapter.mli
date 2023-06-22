
module type S = sig
  (** Convert a real json tree into an atd-compliant form. *)
  val normalize : Js.Json.t -> Js.Json.t

  (** Convert an atd-compliant json tree into a real json tree. *)
  val restore : Js.Json.t -> Js.Json.t
end

module Type_field : sig
  module type Param = sig
    val type_field_name : string
  end

  (** Default parameters, using [type_field_name = "type"]. *)
  module Default_param : Param

  (** Default adapter assuming a ["type"] field. *)
  include S

  (** Functor, allowing the use of a custom parameter:
    {[
    module Kind_field = Type_field.Make (struct let type_field_name = "kind" end)
    ]}
  *)
  module Make (_ : Param) : S
end
