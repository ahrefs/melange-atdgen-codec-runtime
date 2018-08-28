# bs-aws-lambda

`bs-atdgen-codec-runtime` is a bucklescript runtime for
[atdgen](https://github.com/mjambon/atd). It is based on the json type
provided by bucklescript and combinators of [@glennsl/bs-json]().

## Installation

```
yarn add @ahrefs/bs-atdgen-codec-runtime
```

This package doesn't take care of running atdgen to derive code from
type definitions. This step requires the `atdgen` binary which can be
obtained using [opam](https://opam.ocaml.org/).

## Usage

Add `@ahrefs/bs-atdgen-codec-runtime` to the `bs-dependencies` of
`bsconfig.json`.

To write atd type definitions, please have a look at the [great atd
documentation](https://atd.readthedocs.io/en/latest/).
