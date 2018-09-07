(* Auto-generated from "meetup.atd" *)
              [@@@ocaml.warning "-27-32-35-39"]

type person = { name: string; email: string; phone: string option }

type access = [ `Private | `Public ]

type event = {
  access: access;
  name: string;
  host: person;
  guests: person list
}

type events = event list
