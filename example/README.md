# Atdgen for bucklescript, the example

## Compile the project

```bash
yarn
yarn atdgen # required only if src/meetup.atd has been modified
yarn build
```

## Run it

```
$ echo "[]" > events.json
$ nodejs src/cli.bs.js add
$ nodejs src/cli.bs.js print
=== OCaml/Reason Meetup! summary ===
access: public
host: Louis louis@nospam.com
guests: 0
$ nodejs src/cli.bs.js add
$ nodejs src/cli.bs.js print
=== OCaml/Reason Meetup! summary ===
access: public
host: Louis louis@nospam.com
guests: 0
=== OCaml/Reason Meetup! summary ===
access: public
host: Louis louis@nospam.com
guests: 0
$ cat events.json | json_pp
[
   {
      "access" : "Public",
      "host" : {
         "email" : "louis@nospam.com",
         "name" : "Louis"
      },
      "guests" : [],
      "name" : "OCaml/Reason Meetup!"
   },
   {
      "host" : {
         "email" : "louis@nospam.com",
         "name" : "Louis"
      },
      "access" : "Public",
      "name" : "OCaml/Reason Meetup!",
      "guests" : []
   }
]
```
