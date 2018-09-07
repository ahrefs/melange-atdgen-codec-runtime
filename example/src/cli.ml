let event_file = "events.json"

let print_event (event: Meetup_t.event) =
  Js.log2 "=== %s summary ===" event.name;
  Js.log2 "access: %s"
    (match event.access with
     | `Private -> "private (registration required)"
     | `Public -> "public");
  Js.log4 "host: %s %s%s"
    event.host.name event.host.email
    (match event.host.phone with None -> "" | Some p -> " (" ^ p ^ ")");
  Js.log2 "guests: %d" (List.length event.guests)

let read_events () =
  (* read the file from disk *)
  let file_content = Node_fs.readFileAsUtf8Sync event_file in
  (* parse the json *)
  let json = Js.Json.parseExn file_content in
  (* turn it into a proper record *)
  let events: Meetup_t.events = Atdgen_codec_runtime.Decode.decode Meetup_bs.read_events json in
  events

let write_events events =
  (* turn a list of records into json *)
  let json = Atdgen_codec_runtime.Encode.encode Meetup_bs.write_events events in
  (* convert the json to string *)
  let file_content = Js.Json.stringify json in
  (* write the json in our file *)
  Node_fs.writeFileAsUtf8Sync event_file file_content

let print_events () =
  read_events ()
  |> List.iter print_event

let add_event () =
  let events = read_events () in
  let new_event =
    {
      Meetup_t.access = `Public;
      name = "OCaml/Reason Meetup!";
      host = { name = "Louis"; email = "louis@nospam.com"; phone = None; };
      guests = [];
    }
  in
  write_events (new_event :: events)

let () =
  match Array.to_list Sys.argv with
  | _ :: _ :: "print" :: _ -> print_events ()
  | _ :: _ :: "add" :: _ -> add_event ()
  | _  -> print_endline "usage: nodejs cli.bs.js <print|add>"
