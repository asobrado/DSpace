#!/bin/bash
set -e

echo "dspace ALL= NOPASSWD: /etc/init.d/tomcat6" > /etc/sudoers.d/dspace


cwd=`pwd`
DSPACE_SRC=/opt/dspace/source
DSPACE_DIR=/opt/dspace/install

#Funcion No probada
createdb(){

	#dropdb dspace4
	#createdb -U dspace4 -E UNICODE dspace4 -h localhost

	#cd $DSPACE_DIR
	#./bin/dspace  dsrun org.dspace.administer.MetadataImporter -f config/registries/unt-types.xml

	#echo -e "Instalando XMLWorkflow"
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


show_message "Actualizamos el código fuente de github"
cd $DSPACE_SRC
git stash && git pull && git rebase && git stash pop

show_message "Empaquetamos dspace"
cd dspace 
mvn package -q

show_message "Paramos el tomcat"
sudo /etc/init.d/tomcat6 stop

show_message "actualizamos los sources"
cd target/dspace-*
ant update -q

show_message "iniciamos tomcat"
sudo /etc/init.d/tomcat6 start

show_message "Se hicieron los siguientes reemplazos en la configuración"
find  $DSPACE_DIR/config/ -name "*.old"

show_message "Se actualizó correctamente dspace"
cd $cwd
