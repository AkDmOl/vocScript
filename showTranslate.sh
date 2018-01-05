#!/usr/bin/env bash

osascript << EOT
  display dialog "$(cat resultTransl)" buttons {"OK"} default button 1 with title "translate" 
EOT
