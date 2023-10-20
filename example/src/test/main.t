Tests the example building instructions in the readme work fine

  $ echo "[]" > events.json
  $ node ../example/example/src/cli.js add louis louis@nospam.com
  $ node ../example/example/src/cli.js print meetup | grep -v '^date'
  === OCaml/Reason Meetup! summary ===
  access: public (location: `Central Park`)
  host: louis <louis@nospam.com>
  guests: 1
  $ node ../example/example/src/cli.js add bob bob@nospam.com
  $ node ../example/example/src/cli.js print meetup | grep -v '^date'
  === OCaml/Reason Meetup! summary ===
  access: public (location: `Central Park`)
  host: bob <bob@nospam.com>
  guests: 1
  === OCaml/Reason Meetup! summary ===
  access: public (location: `Central Park`)
  host: louis <louis@nospam.com>
  guests: 1
  $ cat events.json | grep -v 'date'
  [
    {
      "guests": [
        {
          "email": "bob@nospam.com",
          "name": "bob"
        }
      ],
      "host": {
        "email": "bob@nospam.com",
        "name": "bob"
      },
      "name": "OCaml/Reason Meetup!",
      "access": {
        "address": "Central Park",
        "type": "Public"
      }
    },
    {
      "guests": [
        {
          "email": "louis@nospam.com",
          "name": "louis"
        }
      ],
      "host": {
        "email": "louis@nospam.com",
        "name": "louis"
      },
      "name": "OCaml/Reason Meetup!",
      "access": {
        "address": "Central Park",
        "type": "Public"
      }
    }
  ]
