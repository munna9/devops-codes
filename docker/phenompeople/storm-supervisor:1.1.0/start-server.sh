#!/usr/bin/env bash
if [ -f ${STORM_HOME}/bin/storm ];then
   ${STORM_HOME}/bin/storm supervisor > ${STORM_HOME}/logs/supervisor.out
fi