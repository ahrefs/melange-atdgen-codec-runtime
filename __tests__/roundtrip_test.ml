(** Test that encoding + decoding a value equals to the original value. *)

open Jest

type 'a test =
  { name : string
  ; encode : 'a -> Js.Json.t
  ; decode : Js.Json.t -> 'a
  ; data : 'a
  }

type test' = T : 'a test -> test'

let test_roundtrip ~name ~write ~read ~data =
  T { name
    ; encode = Atdgen_codec_runtime.Encode.encode write
    ; decode = Atdgen_codec_runtime.Decode.decode read
    ; data }

let run_test (T t) =
  let json = t.encode t.data in
  let data' = t.decode json in
  test t.name (fun () ->
    Expect.expect t.data
    |> Expect.toEqual data'
  )

let run_tests tests = List.iter run_test tests

let _ =
  describe "tests" (fun () ->
      run_tests
        [ test_roundtrip
            ~name:"record"
            ~write:Test_bs.write_r
            ~read:Test_bs.read_r
            ~data:{Test_t.a = 1; b = "string";}
        ; test_roundtrip
            ~name:"record optional absent"
            ~write:Test_bs.write_ro
            ~read:Test_bs.read_ro
            ~data:{Test_t.c = "s"; o = None;}
        ; test_roundtrip
            ~name:"record optional present"
            ~write:Test_bs.write_ro
            ~read:Test_bs.read_ro
            ~data:{Test_t.c = "s"; o = Some 3L;}
        ; test_roundtrip
            ~name:"variant list"
            ~write:Test_bs.write_vl
            ~read:Test_bs.read_vl
            ~data:[Test_t.A 1; B "s"]
        ; test_roundtrip
            ~name:"variant poly list"
            ~write:Test_bs.write_vpl
            ~read:Test_bs.read_vpl
            ~data:[`A 1; `B "s"]
        ; test_roundtrip
            ~name:"tupple"
            ~write:Test_bs.write_t
            ~read:Test_bs.read_t
            ~data:(1, "s", 1.1)
        ; test_roundtrip
            ~name:"int nullable absent"
            ~write:Test_bs.write_n
            ~read:Test_bs.read_n
            ~data:None
        ; test_roundtrip
            ~name:"int nullable present"
            ~write:Test_bs.write_n
            ~read:Test_bs.read_n
            ~data:(Some 1)
        ; test_roundtrip
            ~name:"int64"
            ~write:Test_bs.write_int64
            ~read:Test_bs.read_int64
            ~data:3L
        ]
  )
