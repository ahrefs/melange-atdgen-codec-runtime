(** bs-json adapter for atdgen *)

module Json : sig

  type t = Js.Json.t
  external read_t : t -> t = "%identity"
  external write_t : t -> t = "%identity"

end

(** Module signature required of any json adapter.
    For example, an ATD annotation
    [<json
      adapter.ocaml="Atdgen_codec_runtime.Json.adapter.Type_field"]
    refers to the OCaml module
    [Atdgen_codec_runtime.Json_adapter.Type_field].
*)
module Json_adapter: sig

  module type S = sig
    (** Convert a real json tree into an atd-compliant form. *)
    val normalize : Json.t -> Json.t

    (** Convert an atd-compliant json tree into a real json tree. *)
    val restore : Json.t -> Json.t
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
    module Make (Param : Param) : S
  end

end

module Encode : sig

  type 'a t = 'a -> Js.Json.t

  val make : ('a -> Json.t) -> 'a t

  val encode : 'a t -> 'a -> Json.t

  val unit : unit t
  val string : string t
  val float : float t
  val int : int t
  val bool : bool t
  val char : char t

  val list : 'a t -> 'a list t
  val array : 'a t -> 'a array t

  val int32 : int32 t
  val int64 : int64 t

  type field

  val field : ?default:'a -> 'a t -> name:string -> 'a -> field
  val field_o : ?default:'a -> 'a t -> name:string -> 'a option -> field

  val obj : field list -> Json.t

  val tuple1 : 'a t -> 'a t
  val tuple2 : 'a t -> 'b t -> ('a * 'b) t
  val tuple3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
  val tuple4 : 'a t -> 'b t -> 'c t -> 'd t -> ('a * 'b * 'c * 'd) t

  val constr0 : string -> Json.t
  val constr1 : string -> 'a t -> 'a -> Json.t

  val contramap : ('b -> 'a) -> 'a t -> 'b t

  val nullable : 'a t -> 'a option t

  val option_as_constr : 'a t -> 'a option t

  val adapter: (Json.t -> Json.t) -> 'a t -> 'a t

end

module Decode : sig

  type 'a t = Js.Json.t -> 'a

  val make : (Json.t -> 'a) -> 'a t

  val decode : 'a t -> Json.t -> 'a

  val unit : unit t
  val bool : bool t
  val int : int t
  val float : float t
  val char : char t
  val string : string t
  val int32 : int32 t
  val int64 : int64 t

  val optional : 'a t -> 'a option t
  val list : 'a t -> 'a list t
  val array : 'a t -> 'a array t

  val obj_list : 'a t -> (string * 'a) list t
  val obj_array : 'a t -> (string * 'a) array t

  (* a field that should be present *)
  val field : string -> 'a t -> 'a t

  (* a field that turns into a an optional value when absent *)
  val fieldDefault : string -> 'a -> 'a t -> 'a t

  (* a field that returns None when is absent *)
  val fieldOptional : string -> 'a t -> 'a option t

  val map : ('a -> 'b) -> 'a t -> 'b t

  val tuple1 : 'a t -> 'a t
  val tuple2 : 'a t -> 'b t -> ('a * 'b) t
  val tuple3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
  val tuple4 : 'a t -> 'b t -> 'c t -> 'd t -> ('a * 'b * 'c * 'd) t

  val enum : (string * [`Single of 'a | `Decode of 'a t]) list -> 'a t

  val nullable : 'a t -> 'a option t

  val option_as_constr : 'a t -> 'a option t

  val adapter: (Json.t -> Json.t) -> 'a t -> 'a t

end
