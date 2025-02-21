open Jest
open Expect

let wrap_exn exp = try let _ = exp () in "not called" with Melange_json.Of_json_error (Json_error str) -> str

let () =
  describe "exceptions" (fun () ->

    test "unit" (fun () ->
      let j = Melange_json.of_string {|{}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.unit j))
      |> toBe ("Expected null, got {}"));

    test "option_as_constr" (fun () ->
      let j = Melange_json.of_string {|{}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.(option_as_constr int)j))
      |> toBe (
        "All decoders given to oneOf failed. Here are all the errors: \n\
         - expected a string but got {}\n\
         - expected an array but got {}\n\
         And the JSON being decoded: {}"));

    test "enum" (fun () ->
      let j = Melange_json.of_string {|{}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.(enum []) j))
      |> toBe(
        "All decoders given to oneOf failed. Here are all the errors: \n\
         - expected a string but got {}\n\
         - expected an array but got {}\n\
         And the JSON being decoded: {}"));

    test "missing field in record" (fun () ->
      let j = Melange_json.of_string {|{"o": 44}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_ro j))
      |> toBe("Expected field 'c'"));

    test "optional field with default: wrong type throws exception" (fun () ->
      let j = Melange_json.of_string {|{"with_default": "not right"}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_optional_field j))
      |> toBe({|with_default: expected an integer but got "not right"|}));

    test "optional field: wrong type throws exception" (fun () ->
      let j = Melange_json.of_string {|{"no_default": "not right"}|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_optional_field j))
      |> toBe({|no_default: expected an integer but got "not right"|}));

    test "error in variant" (fun () ->
      let j = Melange_json.of_string {|["A", "not right"]|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_v j))
      |> toBe({|A: expected an integer but got "not right"|}));

    test "deeply nested error (array element fails)" (fun () ->
      let j = Melange_json.of_string {|["A", [[1, "not right"], "Bool"]]|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_deeply_nested j))
      |> toBe({|A.0.1: expected an integer but got "not right"|}));

    test "deeply nested error (tuple element fails)" (fun () ->
      let j = Melange_json.of_string {|["A", [[1, 2], "Boolean"]]|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_deeply_nested j))
      |> toBe({|A.1.Boolean: unknown constructor "Boolean"|}));

    test "deeply nested error (rec_list element fails deep enough)" (fun () ->
      let j = Melange_json.of_string {|["A", [[1, 2], ["List", ["Bool", "Fail"]]]]|} in
      expect (wrap_exn (fun () -> Atdgen_codec_runtime.Decode.decode Test_mel.read_deeply_nested j))
      |> toBe({|A.1.List.1.Fail: unknown constructor "Fail"|}));


  )
