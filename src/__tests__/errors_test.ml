open Jest
open Expect

let wrap_exn exp = try let _ = exp () in "not called" with Json.Decode.DecodeError str -> str

let () =
  describe "exceptions" (fun () ->

    test "unit" (fun () ->
      let j = Json.parseOrRaise {|{}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.unit j))
      |> toBe ("Expected null, got {}"));

    test "option_as_constr" (fun () ->
      let j = Json.parseOrRaise {|{}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.(option_as_constr int)j))
      |> toBe (
        "All decoders given to oneOf failed. Here are all the errors: \n\
         - Expected string, got {}\n\
         - Expected array, got {}\n\
         And the JSON being decoded: {}"));

    test "enum" (fun () ->
      let j = Json.parseOrRaise {|{}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.(enum []) j))
      |> toBe(
        "All decoders given to oneOf failed. Here are all the errors: \n\
         - Expected string, got {}\n\
         - Expected array, got {}\n\
         And the JSON being decoded: {}"));

    test "missing field in record" (fun () ->
      let j = Json.parseOrRaise {|{"o": 44}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_ro j))
      |> toBe("Expected field 'c'"));

    test "optional field with default: wrong type throws exception" (fun () ->
      let j = Json.parseOrRaise {|{"with_default": "not right"}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_optional_field j))
      |> toBe({|with_default: Expected number, got "not right"|}));

    test "optional field: wrong type throws exception" (fun () ->
      let j = Json.parseOrRaise {|{"no_default": "not right"}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_optional_field j))
      |> toBe({|no_default: Expected number, got "not right"|}));

    test "error in variant" (fun () ->
      let j = Json.parseOrRaise {|["A", "not right"]|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_v j))
      |> toBe({|A: Expected number, got "not right"|}));

    test "deeply nested error (array element fails)" (fun () ->
      let j = Json.parseOrRaise {|["A", [[1, "not right"], "Bool"]]|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_deeply_nested j))
      |> toBe({|A.0.1: Expected number, got "not right"|}));

    test "deeply nested error (tuple element fails)" (fun () ->
      let j = Json.parseOrRaise {|["A", [[1, 2], "Boolean"]]|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_deeply_nested j))
      |> toBe({|A.1.Boolean: unknown constructor "Boolean"|}));

    test "deeply nested error (rec_list element fails deep enough)" (fun () ->
      let j = Json.parseOrRaise {|["A", [[1, 2], ["List", ["Bool", "Fail"]]]]|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_deeply_nested j))
      |> toBe({|A.1.List.1.Fail: unknown constructor "Fail"|}));


  )
