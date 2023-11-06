tankste!
========

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

Your open source gas station mobile app. We love the minimalistic of the Bertha app from Mercedes
and want to keep them alive! So we create this project.

## Modules ##

| Name       | Description                     |
|------------|---------------------------------|
| app        | App entry point                 |
| station    | Station and gas price things    |
| navigation | Routing utils and widgets       |
| map        | Map specific parts              |
| settings   | User settings page              |
| core       | Generic core and util functions |

## Configuration ##

All secrets are needs to be defined in `config.json`.
At this moment we maintain an duplicated configuration for every platform. In future this should be
auto-generated created by build scripts.

* Flutter: `config.json`
* Android: `android/app/src/main/res/values/config.xml`
* iOS: `ios/Config.xcconfig`

## Data source ##

The gas station data are provided by [Tankerkönig](https://creativecommons.tankerkoenig.de/). Thanks
for this API! We will replace this by our own API in future days.

## License ##

tankste! - Your open source gas station mobile app.
Copyright (C) 2022 Fabian Keunecke

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
