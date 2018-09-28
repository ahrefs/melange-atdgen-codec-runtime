(* Auto-generated from "meetup.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type publ = Meetup_t.publ = { address: string }

type priv = Meetup_t.priv = { password: string; secret: bool }

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

val read_publ :  publ Atdgen_codec_runtime.Decode.t

val write_publ :  publ Atdgen_codec_runtime.Encode.t

val read_priv :  priv Atdgen_codec_runtime.Decode.t

val write_priv :  priv Atdgen_codec_runtime.Encode.t

val read_person :  person Atdgen_codec_runtime.Decode.t

val write_person :  person Atdgen_codec_runtime.Encode.t

val read_date :  date Atdgen_codec_runtime.Decode.t

val write_date :  date Atdgen_codec_runtime.Encode.t

val read_access :  access Atdgen_codec_runtime.Decode.t

val write_access :  access Atdgen_codec_runtime.Encode.t

val read_event :  event Atdgen_codec_runtime.Decode.t

val write_event :  event Atdgen_codec_runtime.Encode.t

val read_events :  events Atdgen_codec_runtime.Decode.t

val write_events :  events Atdgen_codec_runtime.Encode.t

