(** bs-json adapter for atdgen *)


(** Module signature required of any json adapter.
    For example, an ATD annotation
    [<json
      adapter.ocaml="Atdgen_codec_runtime.Json.adapter.Type_field"]
    refers to the OCaml module
    [Atdgen_codec_runtime.Json_adapter.Type_field].
*)
module Json_adapter = Atdgen_json_adapter
module Encode = Atdgen_codec_encode
module Decode = Atdgen_codec_decode
