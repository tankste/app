#!/bin/bash

function pub_get () {
  echo "Get pubs for $1.."
  (cd $1; flutter pub get)
  echo -e "\n\n"
}

pub_get core
pub_get settings
pub_get sponsor
pub_get report
pub_get map
pub_get navigation
pub_get station
pub_get app
