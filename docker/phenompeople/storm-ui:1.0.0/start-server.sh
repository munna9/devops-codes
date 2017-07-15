#!/usr/bin/env bash
if [ -f ${STORM_HOME}/bin/storm ];then
   ${STORM_HOME}/bin/storm ui > ${STORM_HOME}/logs/storm-ui.out
fi