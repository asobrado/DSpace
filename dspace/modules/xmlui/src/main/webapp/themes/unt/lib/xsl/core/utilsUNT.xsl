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
<xsl:template name="buildCommunitiesBox">
	   <div id='home_main_communities'>
	   	 <h1 class="communities_header"><i18n:text>sedici.comunidades.header</i18n:text></h1>
	   	 <xsl:call-template name="render-community-section">
	   	 	<xsl:with-param name="elements" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='home-link']"/>
	   	 </xsl:call-template>
	   </div>
   </xsl:template>
    
   <!-- mostramos los links del home basados en la propiedad de configuracion xmlui.community-list.home-links -->
   <xsl:template name="render-community-section">
   		<xsl:param name="elements"/>

		<xsl:for-each select="$elements">
         	<xsl:variable name="slug" select="@qualifier"/>
         	<xsl:variable name="link" select="."/>
		
	         <div class="community_icon_container">
	         	<xsl:attribute name="id">icono_<xsl:value-of select="$slug"/></xsl:attribute>
		 		<a>
		 		    <xsl:attribute name="href"><xsl:value-of select="$link"/></xsl:attribute>
			 		<h2><i18n:text>sedici.comunidades.<xsl:value-of select="$slug"/>.nombre</i18n:text></h2>
			 		<p><i18n:text>sedici.comunidades.<xsl:value-of select="$slug"/>.info</i18n:text></p>
		 		</a>
		 	 </div>
   		</xsl:for-each>
   
   </xsl:template>
   
   <!-- Imprime la ruta absoluta al recurso indicado con el parámetro path -->
   	<xsl:template name="print-path">
		<xsl:param name="path">/</xsl:param>
		<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']" />
		<xsl:value-of select="$path" />
	</xsl:template>
	
	<!-- Imprime la ruta absoluta al recurso indicado con el parámetro path -->   
   <xsl:template name="print-theme-path">
		<xsl:param name="path">/</xsl:param>
		<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']" />
		<xsl:text>/</xsl:text>
		<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme' and @qualifier='path']" />
		<xsl:value-of select="$path" />
	</xsl:template>
   
 </xsl:stylesheet>  