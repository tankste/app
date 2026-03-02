CHANGELOG
=========

| Symbol | Meaning             |
|--------|---------------------|
| 🌟     | New function        |
| 🧹     | Improvement changes |
| 🐞     | Bug fixing          |

## Upcoming version ##

## 2.2.1 (2026-03-02) ##

- 🌟 Create review package with closed & floss variants
- 🌟 Create location package with closed & floss variants
- 🧹 Show `NULL` prices instead of hiding them
- 🌟 Create FOSS package of navigation
- 🐞 Fix reporting of new fuel types
- 🧹 Price history chart: Don't show all data points on longer time ranges
- 🧹 Price history chart: Show step line instead of curve line
- 🌟 Create FOSS package of sponsor
- 🌟 Create FOSS package of map

## 2.2.0 (2026-01-14) ##

- 🧹 New sponsor way & design
- 🧹 Dynamically load price fuel type
- 🐞 Fix translation link
- 🌟 Show price history chart on station details
- 🌟 Add Danish translation
- 🌟 Add Danish kroner currency

## 2.1.0 (2024-05-03) ##

- 🧹 Add terms & privacy also to purchase screen to conform Apple review rules
- 🧹 Replace subscriptions by one-time purchases to conform Apple review rules
- 🐞 Fix hanging map when re-open from background (Android only)
- 🌟 Show station IDs on details page
- 🐞 Fix not-overlapping MapLibre symbols
- 🧹 Finalize logging ([#66](https://github.com/tankste/app/issues/66))
  - Add options to settings
  - Log all errors
  - Allow share logs
- 🌟 Add currency ([#65](https://github.com/tankste/app/issues/65))
- 🌟 Add translations ([#18](https://github.com/tankste/app/issues/18))

## 2.0.1 (12.02.204) ##

- 🧹 Add error logging
- 🌟 Add logging framework ([#66](https://github.com/tankste/app/issues/66))
- 🐞 Fix initial state hangup ([#64](https://github.com/tankste/app/issues/64))

## 2.0.0 (29.01.2024) ##

- 🧹 Add pull-to-refresh action to station details
- 🌟 Show data source origin ([#55](https://github.com/tankste/app/issues/55))
- 🌟 Add report wrong data form ([#54](https://github.com/tankste/app/issues/54))
- 🌟 Add date of last price change to details ([#2](https://github.com/tankste/app/issues/2))
- 🧹 No longer enforce location permission ([#6](https://github.com/tankste/app/issues/6))
- 🌟 Add settings option for changing the map provider ([#51](https://github.com/tankste/app/issues/51))
- 🌟 Add sponsor page to settings ([#56](https://github.com/tankste/app/issues/49))
- 🧹 Use tankste! backend and remove Tankerkoenig usage ([#49](https://github.com/tankste/app/issues/49))
- 🧹 Replace OpenStreetMap by MapLibre ([#52](https://github.com/tankste/app/issues/52))
- 🧹 Improve code base ([#21](https://github.com/tankste/app/issues/21))
    - Move app to own module folder
    - Remove unused flutter generated files
    - Improve module folder structures
    - Migrate prototype map code to own widget with BLoC pattern

## 1.2.2 (2022-12-13) ##

- 🐞 Integer coordinates were not parsed correctly ([#47](https://github.com/tankste/app/issues/44))

## 1.2.1 (2022-11-21) ##

- 🐞 Integer prices were not parsed correctly ([#44](https://github.com/tankste/app/issues/44))

## 1.2.0 (2022-11-13) ##

- 🐞 Refresh map by coming back to foreground ([#5](https://github.com/tankste/app/issues/5))
- 🐞 Wrong marker resolutions ([#25](https://github.com/tankste/app/issues/25))
- 🧹 Highlight searched gas price on page details
- 🧹 Show progress & errors ([#16](https://github.com/tankste/app/issues/16))
- 🌟 Navigation app selection in settings ([#27](https://github.com/tankste/app/issues/27))
- 🌟 Developer settings ([#30](https://github.com/tankste/app/issues/30))
- 🌟 Apple Maps for iOS ([#4](https://github.com/tankste/app/issues/4))
- 🌟 Open Street Map for Android ([#7](https://github.com/tankste/app/issues/7))

## 1.1.0 (2022-07-12) ##

- 🌟 Details station page
    - 🌟 Station address
    - 🌟 Open times
    - 🌟 All gas prices
    - 🌟 Route preview
    - 🌟 Open navigation app for routing

## 1.0.0 (2022-07-07) ##

- 🌟 Map with green/orange/red station markers
- 🌟 Filter for gas types (E5, E10, Diesel)
- 🌟 Settings page
