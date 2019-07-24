(* Auto-generated from "test.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type recurse = { recurse_items: recurse list }

type rec_option = [ `Bool | `Nullable of rec_option option ]

type rec_list = [ `Bool | `List of rec_list list ]

type mutual_recurse1 = { mutual_recurse2: mutual_recurse2 list }

and mutual_recurse2 = { mutual_recurse1: mutual_recurse1 list }

type container = { id: string; children: container list }

type vp = [ `A of int | `B of string ]

type vpl = vp list

type v =  A of int | B of string 

type vl = v list

type t = (int * string * float)

type int64 = Int64.t

type ro = { c: string; o: int64 option }

type r = { a: int; b: string }

type optional_field = {
  with_default: int;
  no_default: int option;
  no_default_nullable: int option
}

type n = int option

type b = { thing: int }

type an_array = int Atdgen_runtime.Util.ocaml_array

type a = { thing: string; other_thing: bool }

type adapted = [ `A of a | `B of b ]
