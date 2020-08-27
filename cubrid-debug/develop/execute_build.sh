#!/bin/bash

cubrid service stop

rm -rf /home/cubrid/CUBRID

cd /home/cubrid/github/cubrid \
	&& ./build.sh -m debug -p /home/cubrid/CUBRID -j /usr/lib/jvm/java build \
	&& echo 'java_stored_procedure=y' >> /home/cubrid/CUBRID/conf/cubrid.conf \
	&& mkdir -p /home/cubrid/CUBRID/databases \
		/home/cubrid/CUBRID/tmp \
		/home/cubrid/CUBRID/var/CUBRID_SOCK

. /home/cubrid/cubrid.sh

mkdir -p $CUBRID_DATABASES/demodb \
	&& cubrid createdb -F $CUBRID_DATABASES/demodb demodb ko_KR.utf8 \
	&& cubrid loaddb -u dba -s $CUBRID/demo/demodb_schema -d $CUBRID/demo/demodb_objects -v demodb \
	&& sed s/#server=foo,bar/server=demodb/g -i $CUBRID/conf/cubrid.conf

cubrid service restart
