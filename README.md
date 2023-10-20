# melange-atdgen-codec-runtime

`melange-atdgen-codec-runtime` is a Melange runtime for
[atdgen](https://github.com/ahrefs/atd). It is based on the `Js.Json.t`
provided by Melange and combinators of
[melange-json](https://github.com/melange-community/melange-json).

## Installation

Install [opam](https://opam.ocaml.org/) package manager.

Then:

```
opam pin add melange-atdgen-codec-runtime.dev git+https://github.com/ahrefs/melange-atdgen-codec-runtime.git#master
```

## Usage

To generate `ml` files from `atd` ones, add a couple of rules to your `dune` file:

```dune
(rule
 (targets test_bs.ml test_bs.mli)
 (deps test.atd)
 (action
  (run atdgen -bs %{deps})))

(rule
 (targets test_t.ml test_t.mli)
 (deps test.atd)
 (action
  (run atdgen -t %{deps})))
```

You can see examples in [the tests](./src/__tests__/dune) or [the example](./example/src/dune).

To use the generated modules, you will need to include the runtime library in
your project. To do so, add  `melange-atdgen-codec-runtime` to the `libraries`
field in your `dune` file:

```dune
; ...
  (libraries melange-atdgen-codec-runtime)
; ...
```

To write atd type definitions, please have a look at the [great atd
documentation](https://atd.readthedocs.io/en/latest/).

## Simple example

Reason code to query and deserialize the response of a REST API. It
requires [melange-fetch](https://github.com/melange-community/melange-fetch).

```
let get = (url, decode) =>
  Js.Promise.(
    Fetch.fetchWithInit(
      url,
      Fetch.RequestInit.make(~method_=Get, ()),
    )
    |> then_(Fetch.Response.json)
    |> then_(json => json |> decode |> resolve)
  );

let v: Meetup_t.events =
  get(
    "http://localhost:8000/events",
    Atdgen_codec_runtime.Decode.decode(Meetup_bs.read_events),
  );
```

## Full example

The [example](example) directory contains a full example of a simple
cli to read and write data in a JSON file.

For a complete introduction from atdgen installation to json
manipulation, please refer to [Getting started with ATD and
Melange](https://tech.ahrefs.com/getting-started-with-atd-and-melange-1f3a14004081).
