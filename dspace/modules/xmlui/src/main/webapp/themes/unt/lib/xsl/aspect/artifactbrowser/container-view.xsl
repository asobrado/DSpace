<?xml version="1.0" encoding="UTF-8"?>
<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    Rendering of a community or collection
	
	BASED ON THEME MIRAGE FROM @mire http://atmire.com/
	
	Author: Ariel Lira - alira at sedici.unlp.edu.ar
	Author: Ariel Sobrado - asobrado at sedici.unlp.edu.ar

-->

<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
	xmlns:dri="http://di.tamu.edu/DRI/1.0/"
	xmlns:mets="http://www.loc.gov/METS/"
	xmlns:xlink="http://www.w3.org/TR/xlink/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">

    <xsl:output indent="yes"/>

<!-- 	   @id='aspect.artifactbrowser.CommunityViewer.div.community-home' and -->
	   <xsl:template match="dri:div[@n='community-home' or @n='collection-home']">
<!-- 	   		<h1 class="ds-div-head"><xsl:value-of select="head"/></h1> -->
	   		<xsl:apply-templates select="dri:head"/>
	   		<a class="discover-container-contents">
				<xsl:attribute name="href">
					<xsl:call-template name="print-path">
						<xsl:with-param name="path">
							<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request' and @qualifier='URI']" />
							<xsl:text>/discover</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:attribute>
				
				<img alt="Explorar documentos">
					<xsl:attribute name="src">
						<xsl:call-template name="print-theme-path">
							<xsl:with-param name="path">
								<xsl:text>images/boton_explorar.png</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:attribute>
				</img>
			</a>
			<!-- Oculto las cajas de busqueda y exploración para la vista de la comunidad -->
			<!-- <xsl:apply-templates select="dri:div[@n='community-search-browse']"/> -->
			<xsl:apply-templates select="dri:div[@n='community-view' or @n='collection-view']"/>
			
			<xsl:apply-templates select="dri:div[@n='community-recent-submission' or @n='collection-recent-submission']"/>
			   
	   </xsl:template>
	   
 </xsl:stylesheet>  
