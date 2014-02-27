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
		<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']" />
		<xsl:text>/</xsl:text>
		<xsl:value-of select="$path" />
	</xsl:template>
	
	<!-- Imprime la ruta absoluta al recurso indicado con el parámetro path -->   
   <xsl:template name="print-theme-path">
		<xsl:param name="path">/</xsl:param>
		<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath']" />
		<xsl:text>/themes/</xsl:text>
		<xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme' and @qualifier='path']" />
		<xsl:value-of select="$path" />
	</xsl:template>
   
 </xsl:stylesheet>  