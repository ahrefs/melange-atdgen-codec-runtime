(** Test that encoding + decoding a value equals to the original value. *)

open Jest

let run_test ~name ~write ~read ~data =
  let open Expect in
  let encode = Atdgen_codec_runtime.Encode.encode write in
  let decode = Atdgen_codec_runtime.Decode.decode read in
  let json = encode data in
  let data' = decode json in
  test name (fun () ->
    expect data
    |> toEqual data'
  )

let () =
  describe "roundtrip tests" (fun () ->
    run_test
      ~name:"record"
      ~write:Test_bs.write_r
      ~read:Test_bs.read_r
      ~data:{Test_t.a = 1; b = "string";};
    run_test
      ~name:"record optional absent"
      ~write:Test_bs.write_ro
      ~read:Test_bs.read_ro
      ~data:{Test_t.c = "s"; o = None;};
    run_test
      ~name:"record optional present"
      ~write:Test_bs.write_ro
      ~read:Test_bs.read_ro
      ~data:{Test_t.c = "s"; o = Some 3L;};
    run_test
      ~name:"variant list"
      ~write:Test_bs.write_vl
      ~read:Test_bs.read_vl
      ~data:[Test_t.A 1; B "s"];
    run_test
      ~name:"variant poly list"
      ~write:Test_bs.write_vpl
      ~read:Test_bs.read_vpl
      ~data:[`A 1; `B "s"];
    run_test
      ~name:"tuple"
      ~write:Test_bs.write_t
      ~read:Test_bs.read_t
      ~data:(1, "s", 1.1);
    run_test
      ~name:"int nullable absent"
      ~write:Test_bs.write_n
      ~read:Test_bs.read_n
      ~data:None;
    run_test
      ~name:"int nullable present"
      ~write:Test_bs.write_n
      ~read:Test_bs.read_n
      ~data:(Some 1);
    run_test
      ~name:"int64"
      ~write:Test_bs.write_int64
      ~read:Test_bs.read_int64
      ~data:3L;
    run_test
      ~name:"recurse"
      ~write:Test_bs.write_recurse
      ~read:Test_bs.read_recurse
      ~data:{Test_t.recurse_items = [{ recurse_items = []}]};
    run_test
      ~name:"mutual recurse"
      ~write:Test_bs.write_mutual_recurse1
      ~read:Test_bs.read_mutual_recurse1
      ~data:(
        let rec mutual_recurse1 = { Test_t.mutual_recurse2; }
        and mutual_recurse2 = [{ Test_t.mutual_recurse1 = [] }]
        in mutual_recurse1
      );
    run_test
      ~name:"rec list"
      ~write:Test_bs.write_rec_list
      ~read:Test_bs.read_rec_list
      ~data:(`List [`Bool;`Bool;`List [`Bool]; `List []]);
    run_test
      ~name:"adapter variant 1"
      ~write:Test_bs.write_adapted
      ~read:Test_bs.read_adapted
      ~data:Test_t.(`A {thing = "thing"; other_thing = false;});
    run_test
      ~name:"adapter variant 2"
      ~write:Test_bs.write_adapted
      ~read:Test_bs.read_adapted
      ~data:Test_t.(`B {thing = 1;});
    run_test
      ~name:"adapter kind field - variant 1"
      ~write:Test_bs.write_adapted_kind
      ~read:Test_bs.read_adapted_kind
      ~data:Test_t.(`A {thing = "thing"; other_thing = false;});
    run_test
      ~name:"adapter kind field - variant 2"
      ~write:Test_bs.write_adapted_kind
      ~read:Test_bs.read_adapted_kind
      ~data:Test_t.(`B {thing = 1;});
    run_test
      ~name:"int array"
      ~write:Test_bs.write_an_array
      ~read:Test_bs.read_an_array
      ~data:[| 1;2;3;4;5 |];
    run_test
      ~name:"record with optional fields"
      ~write:Test_bs.write_optional_field
      ~read:Test_bs.read_optional_field
      ~data:{with_default = 1; no_default = None; no_default_nullable = Some 11};
  )
