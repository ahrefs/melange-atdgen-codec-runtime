# Atdgen for bucklescript, the example

A detail explanation of this example is available at [Getting started
with atdgen and
bucklescript](https://tech.ahrefs.com/getting-started-with-atdgen-and-bucklescript-1f3a14004081)

## Compile the project

From the root folder:

```bash
make install
dune build @example
```

## Run it

```
$ echo "[]" > events.json
$ node _build/default/example/src/example/example/src/cli.js add louis louis@nospam.com
$ node _build/default/example/src/example/example/src/cli.js meetup print
=== OCaml/Reason Meetup! summary ===
date: Tue, 11 Sep 2018 15:04:13 GMT
access: public
host: louis <louis@nospam.com>
guests: 1
$ node _build/default/example/src/example/example/src/cli.js meetup add bob bob@nospam.com
$ node _build/default/example/src/example/example/src/cli.js meetup print
=== OCaml/Reason Meetup! summary ===
date: Tue, 11 Sep 2018 15:04:16 GMT
access: public
host: bob <bob@nospam.com>
guests: 1
=== OCaml/Reason Meetup! summary ===
date: Tue, 11 Sep 2018 15:04:13 GMT
access: public
host: louis <louis@nospam.com>
guests: 1
$ cat events.json
[
  {
    "guests": [
      {
        "email": "bob@nospam.com",
        "name": "bob"
      }
    ],
    "date": 1536678256177,
    "host": {
      "email": "bob@nospam.com",
      "name": "bob"
    },
    "name": "OCaml/Reason Meetup!",
    "access": "Public"
  },
  {
    "guests": [
      {
        "email": "louis@nospam.com",
        "name": "louis"
      }
    ],
    "date": 1536678253790,
    "host": {
      "email": "louis@nospam.com",
      "name": "louis"
    },
    "name": "OCaml/Reason Meetup!",
    "access": "Public"
  }
]
```
