<?xml version="1.0" encoding="UTF-8"?>
<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    Helper templates
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
   
   <!-- Imprime la ruta absoluta al recurso indicado con el parámetro path -->
   	<xsl:template name="print-path">
   		<xsl:param name="path">/</xsl:param>
		<xsl:variable name="context-path" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']" />
		<xsl:if test="not(starts-with($path, $context-path))">
			<!-- Imprimo el context path si la URL no es absolta -->
			<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']" />
			<xsl:if test="not(starts-with($path, '/'))">
				<xsl:text>/</xsl:text>
			</xsl:if>
		</xsl:if>
		
		<xsl:value-of select="$path" />
	</xsl:template>
	
	<!-- Imprime la ruta absoluta al recurso indicado con el parámetro path -->   
   <xsl:template name="print-theme-path">
		<xsl:param name="path">/</xsl:param>
		<xsl:variable name="theme-path" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme' and @qualifier='path']" />
		<xsl:variable name="context-path" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']" />
		
		<xsl:if test="not(starts-with($path, '/'))">
			<!-- Imprimo el context path si la URL no es absoluta -->
			<xsl:value-of select="$context-path" />
			<xsl:text>/themes/</xsl:text>
			<xsl:value-of select="$theme-path" />
			<xsl:if test="not(starts-with($path, '/'))">
				<xsl:text>/</xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:value-of select="$path" />
	</xsl:template>
	
	<xsl:template name="build-anchor">
		<xsl:param name="a.href">/</xsl:param>
		<xsl:param name="a.value" select="$a.href"/>
		<xsl:param name="img.src"></xsl:param>
		<xsl:param name="img.alt"></xsl:param>
		<a>
			<xsl:attribute name="href">
				<xsl:if test="starts-with($a.href, 'http://')">
					<xsl:value-of select="$a.href"/>
				</xsl:if>
				<xsl:if test="not(starts-with($a.href, 'http://'))">
					<xsl:call-template name="print-path">
						<xsl:with-param name="path" select="$a.href"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:attribute>
			<xsl:if test="$img.src">
				<xsl:call-template name="build-img">	
					<xsl:with-param name="img.src" select="$img.src"/>
					<xsl:with-param name="img.alt" select="$img.alt"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="not($img.src) or ($a.value != $a.href)">
				<xsl:copy-of select="$a.value"/>
			</xsl:if>
		</a>
	</xsl:template>
	
	<xsl:template name="build-img">
		<xsl:param name="img.src"></xsl:param>
		<xsl:param name="img.alt">image</xsl:param>
		<img alt="{$img.alt}">
			<xsl:attribute name="src">
				<xsl:call-template name="print-theme-path">
					<xsl:with-param name="path" select="$img.src"/>
				</xsl:call-template>
			</xsl:attribute>
		</img>
	</xsl:template>
   
 </xsl:stylesheet>  