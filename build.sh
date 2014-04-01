#!/bin/bash
set -e

JAVA_OPTS="-Xmx512m"
# -Dhttp.proxyHost=10.1.0.27 -Dhttp.proxyPort=3128 -Dhttps.proxyHost=10.1.0.27 -Dhttps.proxyPort=3128"

cwd=`pwd`
DSPACE_SRC=/opt/dspace/source
DSPACE_DIR=/opt/dspace/install
TOMCAT="tomcat6"

#Funcion No probada
createdb()
{
	#echo "dspace ALL= NOPASSWD: /etc/init.d/$TOMCAT" > /etc/sudoers.d/dspace

	#dropdb dspace4
	#createdb -U dspace4 -E UNICODE dspace4 -h localhost
	
	#cd $DSPACE_DIR
	#./bin/dspace  dsrun org.dspace.administer.MetadataImporter -f config/registries/unt-types.xml
	
	echo -e "Instalando XMLWorkflow"
        #WORKFLOW_SCRIPTS="$INSTALL_DIR/etc/postgres/xmlworkflow"
        #./bin/dspace dsrun org.dspace.storage.rdbms.InitializeDatabase $WORKFLOW_SCRIPTS/xml_workflow.sql

	#./bin/dspace create-administrator
}

show_message()
{
   echo "#################################################################################################"
   echo "#################################################################################################"
   echo "# $1 #"
   echo "#################################################################################################"
   echo "#################################################################################################"
}

show_message "Actualizando la instalació de DSpace. Esta operación suele demorar un par de minutos."

show_message "Actualizamos el código fuente de github"
cd $DSPACE_SRC
git stash && git pull && git rebase && git stash pop

show_message "Empaquetamos dspace"
cd dspace 
MAVEN_OPTS=$JAVA_OPTS mvn package -q 

show_message "Paramos el tomcat"
sudo /etc/init.d/$TOMCAT stop

#sudo rm /var/lib/$TOMCAT/work/Catalina/localhost/_/cache-dir/cocoon-ehcache.data
#sudo rm /var/lib/$TOMCAT/work/Catalina/localhost/_/cache-dir/cocoon-ehcache.index

show_message "actualizamos los sources"
cd target/dspace-*
ANT_OPTS=$JAVA_OPTS ant update -q 

show_message "eliminamos directorios de bkp viejos"
ant clean_backups -Ddspace.dir=$DSPACE_DIR
#rm -r $DSPACE_DIR/bin.bak-* $DSPACE_DIR/etc.bak-* $DSPACE_DIR/lib.bak-* $DSPACE_DIR/webapps.bak-*
cd $DSPACE_SRC
MAVEN_OPTS=$JAVA_OPTS mvn clean -q 

show_message "iniciamos tomcat"
sudo /etc/init.d/$TOMCAT start

show_message "Se hicieron los siguientes reemplazos en la configuración"
find  $DSPACE_DIR/config/ -name "*.old"

show_message "Se actualizó correctamente dspace"
cd $cwd
