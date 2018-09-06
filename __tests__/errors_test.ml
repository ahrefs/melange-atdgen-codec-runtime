open Jest
open Expect

let () =
  describe "exceptions" (fun () ->

    test "unit" (fun () ->
      let j = Json.parseOrRaise {|{}|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.unit j)
      |> toThrowException (Json_decode.DecodeError "Expected null, got {}"));

    test "option_as_constr" (fun () ->
      let j = Json.parseOrRaise {|{}|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.(option_as_constr int)j)
      |> toThrowException (Json_decode.DecodeError
                             "All decoders given to oneOf failed. Here are all the errors: \
                              Expected string, got {},Expected array, got {},0. And the JSON \
                              being decoded: {}"));

    test "enum" (fun () ->
      let j = Json.parseOrRaise {|{}|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.(enum []) j)
      |> toThrowException (Json_decode.DecodeError
                             "All decoders given to oneOf failed. Here are all the errors: \
                              Expected string, got {},Expected array, got {},0. And the JSON \
                              being decoded: {}"));

  )
