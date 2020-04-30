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

    test "missing field in record" (fun () ->
      let j = Json.parseOrRaise {|{"o": 44}|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.decode Test_bs.read_ro j)
      |> toThrowException (Json_decode.DecodeError "Expected field 'c'"));

    test "optional field with default: wrong type throws exception" (fun () ->
      let j = Json.parseOrRaise {|{"with_default": "not right"}|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.decode Test_bs.read_optional_field j)
      |> toThrowException (Json_decode.DecodeError {|with_default: Expected number, got "not right"|}));

    test "optional field: wrong type throws exception" (fun () ->
      let j = Json.parseOrRaise {|{"no_default": "not right"}|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.decode Test_bs.read_optional_field j)
      |> toThrowException (Json_decode.DecodeError {|no_default: Expected number, got "not right"|}));

    test "error in variant" (fun () ->
      let j = Json.parseOrRaise {|["A", "not right"]|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.decode Test_bs.read_v j)
      |> toThrowException (Json_decode.DecodeError {|A: Expected number, got "not right"|}));

    test "deeply nested error (array element fails)" (fun () ->
      let j = Json.parseOrRaise {|["A", [[1, "not right"], "Bool"]]|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.decode Test_bs.read_deeply_nested j)
      |> toThrowException (Json_decode.DecodeError {|A.0.1: Expected number, got "not right"|}));

    test "deeply nested error (tuple element fails)" (fun () ->
      let j = Json.parseOrRaise {|["A", [[1, 2], "Boolean"]]|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.decode Test_bs.read_deeply_nested j)
      |> toThrowException (Json_decode.DecodeError {|A.1.Boolean: unknown constructor "Boolean"|}));

    test "deeply nested error (rec_list element fails deep enough)" (fun () ->
      let j = Json.parseOrRaise {|["A", [[1, 2], ["List", ["Bool", "Fail"]]]]|} in
      expect (fun () -> Atdgen_codec_runtime.Decode.decode Test_bs.read_deeply_nested j)
      |> toThrowException (Json_decode.DecodeError {|A.1.List.1.Fail: unknown constructor "Fail"|}));


  )
