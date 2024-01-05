CHANGELOG
=========

| Symbol | Meaning             |
|--------|---------------------|
| ➕     | New function        |
| 🛠     | Improvement changes |
| 🐞     | Bug fixing          |

## Upcoming version ##

* ➕ Add report wrong data form ([#54](https://github.com/tankste/app/issues/54))
* ➕ Add date of last price change to details ([#2](https://github.com/tankste/app/issues/2))
* 🛠 No longer enforce location permission ([#6](https://github.com/tankste/app/issues/6))
* ➕ Add settings option for changing the map provider ([#51](https://github.com/tankste/app/issues/51))
* ➕ Add sponsor page to settings ([#56](https://github.com/tankste/app/issues/49))
* 🛠 Use tankste! backend and remove Tankerkoenig usage ([#49](https://github.com/tankste/app/issues/49))
* 🛠 Replace OpenStreetMap by MapLibre ([#52](https://github.com/tankste/app/issues/52))
* 🛠 Improve code base ([#21](https://github.com/tankste/app/issues/21))
    * Move app to own module folder
    * Remove unused flutter generated files
    * Improve module folder structures
    * Migrate prototype map code to own widget with BLoC pattern

## 1.2.2 (2022-12-13) ##

* 🐞 Integer coordinates were not parsed correctly ([#47](https://github.com/tankste/app/issues/44))

## 1.2.1 (2022-11-21) ##

* 🐞 Integer prices were not parsed correctly ([#44](https://github.com/tankste/app/issues/44))

## 1.2.0 (2022-11-13) ##

* 🐞 Refresh map by coming back to foreground ([#5](https://github.com/tankste/app/issues/5))
* 🐞 Wrong marker resolutions ([#25](https://github.com/tankste/app/issues/25))
* 🛠 Highlight searched gas price on page details
* 🛠 Show progress & errors ([#16](https://github.com/tankste/app/issues/16))
* ➕ Navigation app selection in settings ([#27](https://github.com/tankste/app/issues/27))
* ➕ Developer settings ([#30](https://github.com/tankste/app/issues/30))
* ➕ Apple Maps for iOS ([#4](https://github.com/tankste/app/issues/4))
* ➕ Open Street Map for Android ([#7](https://github.com/tankste/app/issues/7))

## 1.1.0 (2022-07-12) ##

* ➕ Details station page
    * ➕ Station address
    * ➕ Open times
    * ➕ All gas prices
    * ➕ Route preview
    * ➕ Open navigation app for routing

## 1.0.0 (2022-07-07) ##

* ➕ Map with green/orange/red station markers
* ➕ Filter for gas types (E5, E10, Diesel)
* ➕ Settings page