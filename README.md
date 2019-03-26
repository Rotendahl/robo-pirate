<h3 align="center"><img src="assets/avatar.png"/ width="100px"></h3>
<h3 align="center">Beep, Beep, Yarrh! </h3>

## Robo pirate [![CircleCI](https://circleci.com/gh/CodingPirates/robo-pirate/tree/master.svg?style=svg)](https://circleci.com/gh/CodingPirates/robo-pirate/tree/master) [![Coverage Status](https://coveralls.io/repos/github/CodingPirates/robo-pirate/badge.svg?branch=master)](https://coveralls.io/github/CodingPirates/robo-pirate?branch=master)


I am the robot servant for the [Coding Pirates](https://Codingpirates.dk) slack
channel. My purpose is to aid in the communication for all the volunteers in
Coding Pirates.


### My tasks
Below you see a list of the task I either intend to learn or already can do.

- [x]  **Post when new channel is created:** Once a new channel is created I
should post the name of the channel along with a link to it in the
#announcements channel.
- [x]  **Invite people:** Visit the root ("/") of the server running me, and
you'll see an invite form. Fill this out and I will present the info in the
slack thread specified in the environment variables. If you accept the invite
request I will send them an invite.
#announcements channel.
- [ ] **Welcome new people:** Once a new user joins our slack they should be
greeted with a welcome message and instructions on how we use slack.
- [ ] **Check for profile description:** Since we are so many people in our
slack we want people to write their department in their profile. I will write
them a friendly reminder until they do it.
- [ ] **Decisions:** The board of Coding Pirates uses slack to make decision
between meetings. If people type
`@robo-pirate Vote [public | private] Should we give the bot more rum?`.
I will create a new message and ask people to vote in the message thread.
If the decision reaches a majority vote I will post the vote results to a
specified decision channel. The `[public| private]` flag decides on if I post to
a public or private decision channel.
""`  

### Configuration
The bot coded according to the [12 factor principles](https://12factor.net),
this means that all configuration happens through environment variables.
The variables to be filled out can be found in `config/test.exs`, copy it to
`config/secret.exs` for development.


### Slack setup
TODO: finish this


### Development setup
Slack has nice [guide][guide] for setting up a test environment with
`ngrok`. You must configure a URL for the events API as described in their
[tutorial](https://api.slack.com/events-api).



### Test setup
TODO: finish this



### Production setup
TODO: finish this



### Contributing
Pull requests are more than welcome, if you want to discuss the development
either create an issue or jump into our slack and ask in `#robo-pirate-dev`  
If you want a development setup, join the [dev slack][inviteLink] and ask for
a token pair. There are unit tests that can be run be calling
```bash
    mix test
    mix coveralls.html # To get test coverage
```
If you create test coverage open the generated file in `cover/excoveralls.html`
and check. All code on the master branch is deployed if the tests pass.



[guide]: https://api.slack.com/tutorials/tunneling-with-ngrok
[inviteLink]: https://join.slack.com/t/codingpirates-dev/shared_invite/enQtNTc3Mzk5OTk3MDYyLTFmYjg3MjE1ODhlOTZlOWU2MGQ2MGIzMzliN2RhYTZiODEzMGUxMjY5YmY4NWIzMjg3YTU5MDNiMmI4NWQ5OWY
