tankste! - App
==============

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0) [![Translations](https://translation.liveyourproject.com/widget/tankste/app/svg-badge.svg)](https://translation.liveyourproject.com/projects/tankste/app/)

Your open source fuel price app. The mission is to give you one app that you can use in all countries.

[<img src="https://tankste.app/assets/playstore.png" height="60" alt="Play Store">](https://play.google.com/store/apps/details?id=app.tankste) 
[<img src="https://tankste.app/assets/appstore.png" height="60" alt="App Store">](https://apps.apple.com/de/app/tankste-deine-tankpreis-app/id1633457177)

<img src="https://tankste.app/assets/images/screenshots/de/ios/screenshot-1.jpeg" height="360" alt="iOS Screenshot 1"> <img src="https://tankste.app/assets/images/screenshots/de/ios/screenshot-2.jpeg" height="360" alt="iOS Screenshot 2"> <img src="https://tankste.app/assets/images/screenshots/de/ios/screenshot-3.jpeg" height="360" alt="iOS Screenshot 3"> 

## Availability ##

| Flag      | Country | since   |
|-----------|---------|---------|
| :de:      | Germany |         |
| :denmark: | Denmark | 01/2026 |
| :iceland: | Iceland | 05/2024 |

## Data sources ##

The gas station data are hosted by our own [backend](https://github.com/tankste/backend). The backend 
gets the data from multiple data sources. We listing them on our [website](https://tankste.app/datenquellen).

## Get started ##

### Configuration ###

All secrets are needs to be defined in `config.json`.
At this moment we maintain an duplicated configuration for every platform. In future this should be
auto-generated created by build scripts.

* Flutter: `config.json`
* Android: `android/app/src/main/res/values/config.xml`
* iOS: `ios/Config.xcconfig`

## Development ##

### Modules ###

| Name         | Description                     |
| ------------ | ------------------------------- |
| `app`        | App entry point                 |
| `station`    | Station and gas price things    |
| `navigation` | Routing utils and widgets       |
| `sponsor`    | Sponsor & payment stuff         |
| `report`     | Report wrong station data forms |
| `map`        | Map utils                       |
| `settings`   | User settings page              |
| `core`       | Generic core and util functions |

### Code quality ###

The tankste! project is based on a prototype code. The quality of the code has improved since then,
but there is still a lot to do. We are on the right track. So please be patient or help us 
to improve the code.

## Special thanks ##

- [Tankerkönig](https://creativecommons.tankerkoenig.de/) that provides a free API for German gas stations. I would never have started the project without this offer.
- [Tim Brückner](https://twitter.com/cupofsoftware) from [Teuer Tanken](https://teuer-tanken.app/) for your help to implement the MTS-K API.
- [Sveinn Flóki Guðmundsson](https://github.com/Loknar) who builds [Gasvaktin](https://github.com/gasvaktin/gasvaktin). That project provides a free API for Iceland gas stations.

## License ##

> [!IMPORTANT]
> This license refers to the source code in this repository. The content provided by the app is protected by copyright.

tankste! - Your open source gas station mobile app.
Copyright (c) 2023 Fabian Keunecke

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
