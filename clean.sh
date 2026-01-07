#!/bin/bash

function clean () {
  echo "Clean on $1.."
  (cd $1; flutter clean)
  echo -e "\n\n"
}

clean core
clean settings
clean report
clean map
clean navigation
clean station
clean app
