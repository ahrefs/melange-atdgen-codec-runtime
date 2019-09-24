(* Auto-generated from "test.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type recurse = Test_t.recurse = { recurse_items: recurse list }

type rec_option = Test_t.rec_option

type rec_list = Test_t.rec_list

type mutual_recurse1 = Test_t.mutual_recurse1 = {
  mutual_recurse2: mutual_recurse2 list
}

and mutual_recurse2 = Test_t.mutual_recurse2 = {
  mutual_recurse1: mutual_recurse1 list
}

type container = Test_t.container = { id: string; children: container list }

type vp = Test_t.vp

type vpl = Test_t.vpl

type v = Test_t.v =  A of int | B of string 

type vl = Test_t.vl

type t = Test_t.t

type int64 = Test_t.int64

type ro = Test_t.ro = { c: string; o: int64 option }

type r = Test_t.r = { a: int; b: string }

type optional_field = Test_t.optional_field = {
  with_default: int;
  no_default: int option;
  no_default_nullable: int option
}

type n = Test_t.n

type b = Test_t.b = { thing: int }

type an_array = Test_t.an_array

type a = Test_t.a = { thing: string; other_thing: bool }

type adapted_kind = Test_t.adapted_kind

type adapted = Test_t.adapted

let rec write__8 js = (
  Atdgen_codec_runtime.Encode.list (
    write_mutual_recurse2
  )
) js
and write__9 js = (
  Atdgen_codec_runtime.Encode.list (
    write_mutual_recurse1
  )
) js
and write_mutual_recurse1 js = (
  Atdgen_codec_runtime.Encode.make (fun (t : mutual_recurse1) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            write__8
            )
          ~name:"mutual_recurse2"
          t.mutual_recurse2
      ]
    )
  )
) js
and write_mutual_recurse2 js = (
  Atdgen_codec_runtime.Encode.make (fun (t : mutual_recurse2) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            write__9
            )
          ~name:"mutual_recurse1"
          t.mutual_recurse1
      ]
    )
  )
) js
let rec read__8 js = (
  Atdgen_codec_runtime.Decode.list (
    read_mutual_recurse2
  )
) js
and read__9 js = (
  Atdgen_codec_runtime.Decode.list (
    read_mutual_recurse1
  )
) js
and read_mutual_recurse1 js = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          mutual_recurse2 =
            Atdgen_codec_runtime.Decode.decode
            (
              read__8
              |> Atdgen_codec_runtime.Decode.field "mutual_recurse2"
            ) json;
      } : mutual_recurse1)
    )
  )
) js
and read_mutual_recurse2 js = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          mutual_recurse1 =
            Atdgen_codec_runtime.Decode.decode
            (
              read__9
              |> Atdgen_codec_runtime.Decode.field "mutual_recurse1"
            ) json;
      } : mutual_recurse2)
    )
  )
) js
let rec write__7 js = (
  Atdgen_codec_runtime.Encode.list (
    write_recurse
  )
) js
and write_recurse js = (
  Atdgen_codec_runtime.Encode.make (fun (t : recurse) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            write__7
            )
          ~name:"recurse_items"
          t.recurse_items
      ]
    )
  )
) js
let rec read__7 js = (
  Atdgen_codec_runtime.Decode.list (
    read_recurse
  )
) js
and read_recurse js = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          recurse_items =
            Atdgen_codec_runtime.Decode.decode
            (
              read__7
              |> Atdgen_codec_runtime.Decode.field "recurse_items"
            ) json;
      } : recurse)
    )
  )
) js
let rec write__6 js = (
  Atdgen_codec_runtime.Encode.list (
    write_container
  )
) js
and write_container js = (
  Atdgen_codec_runtime.Encode.make (fun (t : container) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.string
            )
          ~name:"id"
          t.id
        ;
          Atdgen_codec_runtime.Encode.field
            (
            write__6
            )
          ~name:"children"
          t.children
      ]
    )
  )
) js
let rec read__6 js = (
  Atdgen_codec_runtime.Decode.list (
    read_container
  )
) js
and read_container js = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          id =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.string
              |> Atdgen_codec_runtime.Decode.field "id"
            ) json;
          children =
            Atdgen_codec_runtime.Decode.decode
            (
              read__6
              |> Atdgen_codec_runtime.Decode.field "children"
            ) json;
      } : container)
    )
  )
) js
let rec write__11 js = (
  Atdgen_codec_runtime.Encode.option_as_constr (
    write_rec_option
  )
) js
and write_rec_option js = (
  Atdgen_codec_runtime.Encode.make (fun (x : _) -> match x with
    | `Bool ->
    Atdgen_codec_runtime.Encode.constr0 "Bool"
    | `Nullable x ->
    Atdgen_codec_runtime.Encode.constr1 "Nullable" (
      write__11
    ) x
  )
) js
let rec read__11 js = (
  Atdgen_codec_runtime.Decode.option_as_constr (
    read_rec_option
  )
) js
and read_rec_option js = (
  Atdgen_codec_runtime.Decode.enum
  [
      (
      "Bool"
      ,
        `Single (`Bool)
      )
    ;
      (
      "Nullable"
      ,
        `Decode (
        read__11
        |> Atdgen_codec_runtime.Decode.map (fun x -> ((`Nullable x) : _))
        )
      )
  ]
) js
let rec write__10 js = (
  Atdgen_codec_runtime.Encode.list (
    write_rec_list
  )
) js
and write_rec_list js = (
  Atdgen_codec_runtime.Encode.make (fun (x : _) -> match x with
    | `Bool ->
    Atdgen_codec_runtime.Encode.constr0 "Bool"
    | `List x ->
    Atdgen_codec_runtime.Encode.constr1 "List" (
      write__10
    ) x
  )
) js
let rec read__10 js = (
  Atdgen_codec_runtime.Decode.list (
    read_rec_list
  )
) js
and read_rec_list js = (
  Atdgen_codec_runtime.Decode.enum
  [
      (
      "Bool"
      ,
        `Single (`Bool)
      )
    ;
      (
      "List"
      ,
        `Decode (
        read__10
        |> Atdgen_codec_runtime.Decode.map (fun x -> ((`List x) : _))
        )
      )
  ]
) js
let write_vp = (
  Atdgen_codec_runtime.Encode.make (fun (x : _) -> match x with
    | `A x ->
    Atdgen_codec_runtime.Encode.constr1 "A" (
      Atdgen_codec_runtime.Encode.int
    ) x
    | `B x ->
    Atdgen_codec_runtime.Encode.constr1 "B" (
      Atdgen_codec_runtime.Encode.string
    ) x
  )
)
let read_vp = (
  Atdgen_codec_runtime.Decode.enum
  [
      (
      "A"
      ,
        `Decode (
        Atdgen_codec_runtime.Decode.int
        |> Atdgen_codec_runtime.Decode.map (fun x -> ((`A x) : _))
        )
      )
    ;
      (
      "B"
      ,
        `Decode (
        Atdgen_codec_runtime.Decode.string
        |> Atdgen_codec_runtime.Decode.map (fun x -> ((`B x) : _))
        )
      )
  ]
)
let write__2 = (
  Atdgen_codec_runtime.Encode.list (
    write_vp
  )
)
let read__2 = (
  Atdgen_codec_runtime.Decode.list (
    read_vp
  )
)
let write_vpl = (
  write__2
)
let read_vpl = (
  read__2
)
let write_v = (
  Atdgen_codec_runtime.Encode.make (fun (x : v) -> match x with
    | A x ->
    Atdgen_codec_runtime.Encode.constr1 "A" (
      Atdgen_codec_runtime.Encode.int
    ) x
    | B x ->
    Atdgen_codec_runtime.Encode.constr1 "B" (
      Atdgen_codec_runtime.Encode.string
    ) x
  )
)
let read_v = (
  Atdgen_codec_runtime.Decode.enum
  [
      (
      "A"
      ,
        `Decode (
        Atdgen_codec_runtime.Decode.int
        |> Atdgen_codec_runtime.Decode.map (fun x -> ((A x) : v))
        )
      )
    ;
      (
      "B"
      ,
        `Decode (
        Atdgen_codec_runtime.Decode.string
        |> Atdgen_codec_runtime.Decode.map (fun x -> ((B x) : v))
        )
      )
  ]
)
let write__1 = (
  Atdgen_codec_runtime.Encode.list (
    write_v
  )
)
let read__1 = (
  Atdgen_codec_runtime.Decode.list (
    read_v
  )
)
let write_vl = (
  write__1
)
let read_vl = (
  read__1
)
let write_t = (
  Atdgen_codec_runtime.Encode.tuple3
    (
      Atdgen_codec_runtime.Encode.int
    )
    (
      Atdgen_codec_runtime.Encode.string
    )
    (
      Atdgen_codec_runtime.Encode.float
    )
)
let read_t = (
  Atdgen_codec_runtime.Decode.tuple3
    (
      Atdgen_codec_runtime.Decode.int
    )
    (
      Atdgen_codec_runtime.Decode.string
    )
    (
      Atdgen_codec_runtime.Decode.float
    )
)
let write_int64 = (
  Atdgen_codec_runtime.Encode.int64
)
let read_int64 = (
  Atdgen_codec_runtime.Decode.int64
)
let write__3 = (
  Atdgen_codec_runtime.Encode.option_as_constr (
    write_int64
  )
)
let read__3 = (
  Atdgen_codec_runtime.Decode.option_as_constr (
    read_int64
  )
)
let write_ro = (
  Atdgen_codec_runtime.Encode.make (fun (t : ro) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.string
            )
          ~name:"c"
          t.c
        ;
          Atdgen_codec_runtime.Encode.field_o
            (
            write_int64
            )
          ~name:"o"
          t.o
      ]
    )
  )
)
let read_ro = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          c =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.string
              |> Atdgen_codec_runtime.Decode.field "c"
            ) json;
          o =
            Atdgen_codec_runtime.Decode.decode
            (
              read_int64
              |> Atdgen_codec_runtime.Decode.fieldOptional "o"
            ) json;
      } : ro)
    )
  )
)
let write_r = (
  Atdgen_codec_runtime.Encode.make (fun (t : r) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.int
            )
          ~name:"a"
          t.a
        ;
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.string
            )
          ~name:"b"
          t.b
      ]
    )
  )
)
let read_r = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          a =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.field "a"
            ) json;
          b =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.string
              |> Atdgen_codec_runtime.Decode.field "b"
            ) json;
      } : r)
    )
  )
)
let write__5 = (
  Atdgen_codec_runtime.Encode.nullable (
    Atdgen_codec_runtime.Encode.int
  )
)
let read__5 = (
  Atdgen_codec_runtime.Decode.nullable (
    Atdgen_codec_runtime.Decode.int
  )
)
let write__4 = (
  Atdgen_codec_runtime.Encode.option_as_constr (
    Atdgen_codec_runtime.Encode.int
  )
)
let read__4 = (
  Atdgen_codec_runtime.Decode.option_as_constr (
    Atdgen_codec_runtime.Decode.int
  )
)
let write_optional_field = (
  Atdgen_codec_runtime.Encode.make (fun (t : optional_field) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.int
            )
          ~name:"with_default"
          t.with_default
        ;
          Atdgen_codec_runtime.Encode.field_o
            (
            Atdgen_codec_runtime.Encode.int
            )
          ~name:"no_default"
          t.no_default
        ;
          Atdgen_codec_runtime.Encode.field_o
            (
            Atdgen_codec_runtime.Encode.int
            )
          ~name:"no_default_nullable"
          t.no_default_nullable
      ]
    )
  )
)
let read_optional_field = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          with_default =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.fieldDefault "with_default" 9
            ) json;
          no_default =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.fieldOptional "no_default"
            ) json;
          no_default_nullable =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.fieldOptional "no_default_nullable"
            ) json;
      } : optional_field)
    )
  )
)
let write_n = (
  write__5
)
let read_n = (
  read__5
)
let write_b = (
  Atdgen_codec_runtime.Encode.make (fun (t : b) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.int
            )
          ~name:"thing"
          t.thing
      ]
    )
  )
)
let read_b = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          thing =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.int
              |> Atdgen_codec_runtime.Decode.field "thing"
            ) json;
      } : b)
    )
  )
)
let write__12 = (
  Atdgen_codec_runtime.Encode.array (
    Atdgen_codec_runtime.Encode.int
  )
)
let read__12 = (
  Atdgen_codec_runtime.Decode.array (
    Atdgen_codec_runtime.Decode.int
  )
)
let write_an_array = (
  write__12
)
let read_an_array = (
  read__12
)
let write_a = (
  Atdgen_codec_runtime.Encode.make (fun (t : a) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.string
            )
          ~name:"thing"
          t.thing
        ;
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.bool
            )
          ~name:"other_thing"
          t.other_thing
      ]
    )
  )
)
let read_a = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          thing =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.string
              |> Atdgen_codec_runtime.Decode.field "thing"
            ) json;
          other_thing =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.bool
              |> Atdgen_codec_runtime.Decode.field "other_thing"
            ) json;
      } : a)
    )
  )
)
let write_adapted_kind = (
  Atdgen_codec_runtime.Encode.adapter Kind_field.restore (
    Atdgen_codec_runtime.Encode.make (fun (x : _) -> match x with
      | `A x ->
      Atdgen_codec_runtime.Encode.constr1 "A" (
        write_a
      ) x
      | `B x ->
      Atdgen_codec_runtime.Encode.constr1 "B" (
        write_b
      ) x
    )
  )
)
let read_adapted_kind = (
  Atdgen_codec_runtime.Decode.adapter Kind_field.normalize (
    Atdgen_codec_runtime.Decode.enum
    [
        (
        "A"
        ,
          `Decode (
          read_a
          |> Atdgen_codec_runtime.Decode.map (fun x -> ((`A x) : _))
          )
        )
      ;
        (
        "B"
        ,
          `Decode (
          read_b
          |> Atdgen_codec_runtime.Decode.map (fun x -> ((`B x) : _))
          )
        )
    ]
  )
)
let write_adapted = (
  Atdgen_codec_runtime.Encode.adapter Atdgen_codec_runtime.Json_adapter.Type_field.restore (
    Atdgen_codec_runtime.Encode.make (fun (x : _) -> match x with
      | `A x ->
      Atdgen_codec_runtime.Encode.constr1 "A" (
        write_a
      ) x
      | `B x ->
      Atdgen_codec_runtime.Encode.constr1 "B" (
        write_b
      ) x
    )
  )
)
let read_adapted = (
  Atdgen_codec_runtime.Decode.adapter Atdgen_codec_runtime.Json_adapter.Type_field.normalize (
    Atdgen_codec_runtime.Decode.enum
    [
        (
        "A"
        ,
          `Decode (
          read_a
          |> Atdgen_codec_runtime.Decode.map (fun x -> ((`A x) : _))
          )
        )
      ;
        (
        "B"
        ,
          `Decode (
          read_b
          |> Atdgen_codec_runtime.Decode.map (fun x -> ((`B x) : _))
          )
        )
    ]
  )
)
