#!/bin/bash

function pub_get () {
  echo "Get pubs for $1.."
  (cd $1; flutter pub get)
  echo -e "\n\n"
}

pub_get core
pub_get sponsor/core
pub_get sponsor/data_closed
pub_get sponsor/data_foss
pub_get sponsor/ui
pub_get settings
pub_get report
pub_get map/core
pub_get map/maplibre
pub_get map/apple_closed
pub_get map/apple_foss
pub_get map/google_closed
pub_get map/google_foss
pub_get map/map
pub_get sponsor/ui
pub_get navigation/core
pub_get navigation/impl_google
pub_get navigation/impl_foss
pub_get navigation/navigation
pub_get station
pub_get app
