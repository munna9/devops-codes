#!/usr/bin/env bash
set -o nounset # Treat unset variables as an error
ELASTICSEARCH=${ELASTICSEARCH:-http://dev-elasticsearch01.aws.phenom.local:9200}
KIBANA_INDEX=${KIBANA_INDEX:-.kibana}
sed -ri "s|^(\\#\\s*)?(elasticsearch.url:).*|\\2 '$ELASTICSEARCH'|; \
                s|^(\\#\\s*)?(kibana.index:).*|\\2 '$KIBANA_INDEX'|; " /opt/kibana/config/kibana.yml

exec su -l kibana -s /bin/bash -c "/usr/share/kibana/bin/kibana -c /opt/kibana/config/kibana.yml" > /opt/kibana/logs/kibana.log