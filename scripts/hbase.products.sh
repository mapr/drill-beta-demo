#!/usr/bin/bash -x

echo "script hbase.products.sh"

HBVERSION=$( cat /opt/mapr/hbase/hbaseversion )




export HBASE_HOME=/opt/mapr/hbase/hbase-${HBVERSION}
CLUSTERNAME=$( cat /opt/mapr/conf/mapr-clusters.conf |awk {'print $1'} )
TABLENAME="products"

#first delete table via hbase shell
echo 'disable '"'${TABLENAME}'"'' | hbase shell

echo 'drop '"'${TABLENAME}'"'' | hbase shell

#create table + 2 CF's
echo 'create '"'${TABLENAME}'"',"details","pricing"' | hbase shell

#import

echo "Running importtsv command on products.csv for HBase"

hadoop jar $HBASE_HOME/hbase-0.98.9-mapr-1503.jar \
        importtsv -Dimporttsv.separator=, \
        -Dimporttsv.columns=HBASE_ROW_KEY,details:name,details:category,pricing:price \
        ${TABLENAME} \
        /mapr/${CLUSTERNAME}/drill-beta-demo/data/output/products/products.csv

echo "Finished running importtsv command on products.csv for HBase"
