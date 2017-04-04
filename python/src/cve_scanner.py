#!/usr/bin/env python
try:
  import urllib
  import json
  import sys
  import os
except ImportError, err:
  print err
try:
  cve_id=sys.argv[1]
except IndexError, ie_err:
  print "Usage: %s <CVE_ID>" %(os.path.basename(__file__))
  sys.exit(1)

cve_url="http://cve.circl.lu/api/cve/%s" %(cve_id)

cve_db=urllib.urlopen(cve_url)
json_results=json.load(cve_db)
cve_db.close

print "%s|%s"%(json_results['id'],json_results['summary'])
