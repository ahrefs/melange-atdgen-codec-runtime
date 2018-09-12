(* Auto-generated from "meetup.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type person = Meetup_t.person = {
  name: string;
  email: string;
  phone: string option
}

type date = Meetup_t.date

type access = Meetup_t.access

type event = Meetup_t.event = {
  access: access;
  name: string;
  host: person;
  date: date;
  guests: person list
}

type events = Meetup_t.events

let write__2 = (
  Atdgen_codec_runtime.Encode.nullable (
    Atdgen_codec_runtime.Encode.string
  )
)
let read__2 = (
  Atdgen_codec_runtime.Decode.nullable (
    Atdgen_codec_runtime.Decode.string
  )
)
let write_person = (
  Atdgen_codec_runtime.Encode.make (fun (t : person) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.string
            )
          ~name:"name"
          t.name
        ;
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.string
            )
          ~name:"email"
          t.email
        ;
          Atdgen_codec_runtime.Encode.field_o
            (
            Atdgen_codec_runtime.Encode.string
            )
          ~name:"phone"
          t.phone
      ]
    )
  )
)
let read_person = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          name =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.string
              |> Atdgen_codec_runtime.Decode.field "name"
            ) json;
          email =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.string
              |> Atdgen_codec_runtime.Decode.field "email"
            ) json;
          phone =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.string
              |> Atdgen_codec_runtime.Decode.fieldOptional "phone"
            ) json;
      } : person)
    )
  )
)
let write__1 = (
    Atdgen_codec_runtime.Encode.float
  |> Atdgen_codec_runtime.Encode.contramap (Js.Date.valueOf)
)
let read__1 = (
  (
    Atdgen_codec_runtime.Decode.float
  ) |> (Atdgen_codec_runtime.Decode.map (Js.Date.fromFloat))
)
let write_date = (
  write__1
)
let read_date = (
  read__1
)
let write_access = (
  Atdgen_codec_runtime.Encode.make (fun (x : _) -> match x with
    | `Private ->
    Atdgen_codec_runtime.Encode.constr0 "Private"
    | `Public ->
    Atdgen_codec_runtime.Encode.constr0 "Public"
  )
)
let read_access = (
  Atdgen_codec_runtime.Decode.enum
  [
      (
      "Private"
      ,
        `Single (`Private)
      )
    ;
      (
      "Public"
      ,
        `Single (`Public)
      )
  ]
)
let write__3 = (
  Atdgen_codec_runtime.Encode.list (
    write_person
  )
)
let read__3 = (
  Atdgen_codec_runtime.Decode.list (
    read_person
  )
)
let write_event = (
  Atdgen_codec_runtime.Encode.make (fun (t : event) ->
    (
    Atdgen_codec_runtime.Encode.obj
      [
          Atdgen_codec_runtime.Encode.field
            (
            write_access
            )
          ~name:"access"
          t.access
        ;
          Atdgen_codec_runtime.Encode.field
            (
            Atdgen_codec_runtime.Encode.string
            )
          ~name:"name"
          t.name
        ;
          Atdgen_codec_runtime.Encode.field
            (
            write_person
            )
          ~name:"host"
          t.host
        ;
          Atdgen_codec_runtime.Encode.field
            (
            write_date
            )
          ~name:"date"
          t.date
        ;
          Atdgen_codec_runtime.Encode.field
            (
            write__3
            )
          ~name:"guests"
          t.guests
      ]
    )
  )
)
let read_event = (
  Atdgen_codec_runtime.Decode.make (fun json ->
    (
      ({
          access =
            Atdgen_codec_runtime.Decode.decode
            (
              read_access
              |> Atdgen_codec_runtime.Decode.field "access"
            ) json;
          name =
            Atdgen_codec_runtime.Decode.decode
            (
              Atdgen_codec_runtime.Decode.string
              |> Atdgen_codec_runtime.Decode.field "name"
            ) json;
          host =
            Atdgen_codec_runtime.Decode.decode
            (
              read_person
              |> Atdgen_codec_runtime.Decode.field "host"
            ) json;
          date =
            Atdgen_codec_runtime.Decode.decode
            (
              read_date
              |> Atdgen_codec_runtime.Decode.field "date"
            ) json;
          guests =
            Atdgen_codec_runtime.Decode.decode
            (
              read__3
              |> Atdgen_codec_runtime.Decode.field "guests"
            ) json;
      } : event)
    )
  )
)
let write__4 = (
  Atdgen_codec_runtime.Encode.list (
    write_event
  )
)
let read__4 = (
  Atdgen_codec_runtime.Decode.list (
    read_event
  )
)
let write_events = (
  write__4
)
let read_events = (
  read__4
)
