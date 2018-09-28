(* Auto-generated from "test.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]
open Test_t

type vp = Test_t.vp

type vpl = Test_t.vpl

type v = Test_t.v =  A of int | B of string 

type vl = Test_t.vl

type t = Test_t.t

type int64 = Test_t.int64

type ro = Test_t.ro = { c: string; o: int64 option }

type r = Test_t.r = { a: int; b: string }

type n = Test_t.n

type b = Test_t.b = { thing: int }

type a = Test_t.a = { thing: string; other_thing: bool }

type adapted = Test_t.adapted

val read_vp :  vp Atdgen_codec_runtime.Decode.t

val write_vp :  vp Atdgen_codec_runtime.Encode.t

val read_vpl :  vpl Atdgen_codec_runtime.Decode.t

val write_vpl :  vpl Atdgen_codec_runtime.Encode.t

val read_v :  v Atdgen_codec_runtime.Decode.t

val write_v :  v Atdgen_codec_runtime.Encode.t

val read_vl :  vl Atdgen_codec_runtime.Decode.t

val write_vl :  vl Atdgen_codec_runtime.Encode.t

val read_t :  t Atdgen_codec_runtime.Decode.t

val write_t :  t Atdgen_codec_runtime.Encode.t

val read_int64 :  int64 Atdgen_codec_runtime.Decode.t

val write_int64 :  int64 Atdgen_codec_runtime.Encode.t

val read_ro :  ro Atdgen_codec_runtime.Decode.t

val write_ro :  ro Atdgen_codec_runtime.Encode.t

val read_r :  r Atdgen_codec_runtime.Decode.t

val write_r :  r Atdgen_codec_runtime.Encode.t

val read_n :  n Atdgen_codec_runtime.Decode.t

val write_n :  n Atdgen_codec_runtime.Encode.t

val read_b :  b Atdgen_codec_runtime.Decode.t

val write_b :  b Atdgen_codec_runtime.Encode.t

val read_a :  a Atdgen_codec_runtime.Decode.t

val write_a :  a Atdgen_codec_runtime.Encode.t

val read_adapted :  adapted Atdgen_codec_runtime.Decode.t

val write_adapted :  adapted Atdgen_codec_runtime.Encode.t

