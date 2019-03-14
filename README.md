<h3 align="center"><img src="assets/avatar.png"/ width="100px"></h3>
<h3 align="center">Beep, Beep, Yarrh! </h3>
## Robo pirate
[![CircleCI](https://circleci.com/gh/Rotendahl/robo-pirate.svg?style=svg)](https://circleci.com/gh/Rotendahl/robo-pirate)
[![Coverage Status](https://coveralls.io/repos/github/Rotendahl/robo-pirate/badge.svg?branch=)](https://coveralls.io/github/Rotendahl/robo-pirate?branch=)
I am the robot servant for the [Coding Pirates](https://Codingpirates.dk) slack
channel. My purpose is to aid in the communication for all the volunteers in
Coding Pirates.


### My tasks
Below you see a list of the task I either intend to learn or already can do.

- [x]  **Post when new channel is created:** Once a new channel is created I
should post the name of the channel along with a link to it in the
#announcements channel.
- [ ] **Welcome new people:** Once a new user joins our slack they should be
greeted with a welcome message and instructions on how we use slack.
- [ ] **Check for profile description:** Since we are so many people in our
slack we want people to write their department in their profile. I will write
them a friendly reminder until they do it.
- [x] **Decisions:** The board of Coding Pirates uses slack to make decision
between meetings. If people type
`@robo-pirate Vote [public | private] Should we give the bot more rum?`.
I will create a new message and ask people to vote in the message thread.
If the decision reaches a majority vote I will post the vote results to a
specified decision channel. The `[public| private]` flag decides on if I post to
a public or private decision channel.
""`  

### Development setup
The production setup is based on heroku which dictates that all configuration
should be as environment variables. You need to fill in the values in
`secret.example.exs` and rename it to `secret.exs`. To obtaion the values either
create your own slack for testings purposes or join [this one][inviteLink] and
ask @rotendahl for the tokens.
Slack has nice [guide][guide] for setting up a test environment with
`ngrok`. You must configure a URL for the events API as described in their
[tutorial](https://api.slack.com/events-api).



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
and check.



[guide]: https://api.slack.com/tutorials/tunneling-with-ngrok
[inviteLink]: https://join.slack.com/t/codingpirates-dev/shared_invite/enQtNTc3Mzk5OTk3MDYyLTFmYjg3MjE1ODhlOTZlOWU2MGQ2MGIzMzliN2RhYTZiODEzMGUxMjY5YmY4NWIzMjg3YTU5MDNiMmI4NWQ5OWY
