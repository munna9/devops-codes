#!/usr/bin/env bash
if [ -f ${STORM_HOME}/bin/storm ];then
   ${STORM_HOME}/bin/storm nimbus > ${STORM_HOME}/logs/nimbus.out
fi