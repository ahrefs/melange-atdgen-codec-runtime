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
$ nodejs src/cli.bs.js add louis louis@nospam.com
$ nodejs src/cli.bs.js print
=== OCaml/Reason Meetup! summary ===
date: Tue, 11 Sep 2018 15:04:13 GMT
access: public
host: louis <louis@nospam.com>
guests: 1
$ nodejs src/cli.bs.js add bob bob@nospam.com
$ nodejs src/cli.bs.js print
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
