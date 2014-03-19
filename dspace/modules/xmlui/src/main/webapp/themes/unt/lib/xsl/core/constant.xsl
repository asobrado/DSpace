<?xml version="1.0" encoding="UTF-8"?>
<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
	Constantes 
	
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
	xmlns:exslt="http://exslt.org/common"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc">

    <xsl:output indent="yes"/>

  
	  <xsl:variable name="tesis">Tesis</xsl:variable>
	  <xsl:variable name="imagen_en_movimiento">Imagen en movimiento</xsl:variable>
	  <xsl:variable name="articulo">Articulo</xsl:variable>
	  <xsl:variable name="objeto_de_conferencia">Objeto de conferencia</xsl:variable>
	  <xsl:variable name="audio">Audio</xsl:variable>
	  <xsl:variable name="libro">Libro</xsl:variable>
	  <xsl:variable name="documento_institucional">Documento institucional</xsl:variable>
	  <xsl:variable name="imagen_fija">Imagen fija</xsl:variable>
	  <xsl:variable name="objeto_fisico">Objeto Fisico</xsl:variable>
	  <xsl:variable name="objeto_de_aprendizaje">Objeto de aprendizaje</xsl:variable>
	
	  <xsl:variable name="autoarchivo_handle">11327/92</xsl:variable>
	  <xsl:variable name="admin_group">RIUNT_ADMIN</xsl:variable>

</xsl:stylesheet>
