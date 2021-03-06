<?xml version="1.0" encoding="UTF-8"?>
<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!-- 
	Theme por http://www.repositorio.unt.edu.ar/
	BASED ON THEME MIRAGE FROM @mire http://atmire.com/
	
	Author: Ariel Lira - alira at sedici.unlp.edu.ar
	Author: Ariel Sobrado - asobrado at sedici.unlp.edu.ar

-->
<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/" xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	version="1.0" xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">


	<xsl:import href="../Mirage/Mirage.xsl" />
	<xsl:import href="lib/xsl/core/constant.xsl" />
	<xsl:import href="lib/xsl/core/navigation.xsl" />
	<xsl:import href="lib/xsl/core/utilsUNT.xsl" />
	<xsl:import href="lib/xsl/core/page-structure.xsl" />
	<xsl:import href="lib/xsl/aspect/artifactbrowser/container-view.xsl" />
	<xsl:import href="lib/xsl/aspect/artifactbrowser/item-view.xsl" />
	<xsl:import href="lib/xsl/aspect/artifactbrowser/community-list.xsl" />
	<xsl:output indent="yes" />

</xsl:stylesheet>