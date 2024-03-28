#!/bin/bash

function pub_upgrade () {
  echo "Upgrade pubs for $1.."
  (cd $1; flutter pub upgrade --major-versions)
  echo -e "\n\n"
}

pub_upgrade core
pub_upgrade settings
pub_upgrade sponsor
pub_upgrade report
pub_upgrade map
pub_upgrade navigation
pub_upgrade station
pub_upgrade app
