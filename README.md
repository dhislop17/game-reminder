# Hockey Reminder 

A reminder app for NHL Hockey Games.

![Made with Flutter](https://img.shields.io/badge/Made%20With-Flutter-blue?styl=plastic)

## Features
- Choose a group of teams to follow
- Set a primary team
- View your favorite teams' schedules
- Set reminders for games
- View the roster of any team and the players' current season stats
- View division, conference, and league standings

## App Demos 
<img alt="Pick your favorite Teams" src = "./readme_gifs/onboarding.gif" width=300>  

<img alt="Create new reminder" src = "./readme_gifs/create.gif" width=300>  

<img alt="Change your favorite teams" src = "./readme_gifs/changePrefs.gif" width=300>  

<img alt="View League Standings" src = "./readme_gifs/standings.gif" width=300>  

<img alt="View rosters" src = "./readme_gifs/rosters.gif" width=300>  

## Packages Used
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [http](https://pub.dev/packages/http)
- [shared_preferences](https://pub.dev/packages/shared_preferences)
- [table_calendar](https://pub.dev/packages/table_calendar)
- [scoped_model](https://pub.dev/packages/scoped_model)
- [intl](https://pub.dev/packages/intl)
- [sticky_headers](https://pub.dev/packages/sticky_headers)

## Build/Setup
The Flutter SDK is required in order to run this app. You can follow the installation steps from [here](https://flutter.dev/docs/get-started/install). Once installation is complete, you should clone this repository. 

Afterwards from your command line run 
`Flutter Run`


Data obtained via the NHL Stats API with open source documentation from [here](https://gitlab.com/dword4/nhlapi)
