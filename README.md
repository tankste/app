tankste!
========

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)


Your open source gas station mobile app. We love the minimalistic of the Bertha app from Mercedes and want to keep them alive! So we create this project.

## Configuration ##

All secrets are needs to be defined in `config.json`. 
At this moment we maintain an duplicated configuration for every platform. In future this should be auto-generated created by build scripts.

* Flutter: `config.json`
* Android: `android/app/src/main/res/values/config.xml`
* iOS: `ios/Config.xcconfig`

## Data source ##

The gas station data are provided by [Tankerkönig](https://creativecommons.tankerkoenig.de/). Thanks for this API! We will replace this by our own API in future days.

## TODOs ##

We created this project as an MVP (Minimum Viable Product). If it becomes populary we will continue
our work to the following todos:

- [x] Station detail page
- [ ] Allow ussage without GPS (+ restore last map position)
- [ ] Refactore code (yes, the `main.dart` is very ugly at the moment!!, we know that!) with architecture: BLoC pattern / use case / repositories / flavors
- [ ] iOS: Apple Maps
- [ ] Dark Mode
- [ ] Onboarding (filter preselection, terms)
- [ ] Android Auto / Car Play
- [ ] Design improvements (rounded corners for markers, fonts, colors)
- [ ] Station companies filters
- [ ] Station card filters
- [ ] Favorites
- [ ] "No internet connection"-note
- [ ] Loading / Request error note
- [ ] More countries
- [ ] Translations
- [ ] Own backend
  - [ ] Multiple data sources ("Kartellamt", Aral, Shell, HEM, ...)
  - [ ] History data (for charts #1)
  - [ ] Backend calculated price ranges
- [ ] Payment (?)

**Note: This list will be converted to Github issues soon..**

## License ##

tankste! - Your open source gas station mobile app.
Copyright (C) 2022 Fabian Keunecke

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
