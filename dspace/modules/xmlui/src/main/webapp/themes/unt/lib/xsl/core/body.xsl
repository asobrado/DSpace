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

	<xsl:template name="buildHomeCommunities">
<!-- 				<h1>Comunidades DSpace</h1> -->
				<div id="col_iz">
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_1_.png" /></div>
					
					<div class="title"><a href="handle/123456789/2">INVESTIGACION</a></div>
				</div>
					
			
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_2_.png" width="80" height="95" /></div>
					<div class="title"><a href="handle/123456789/7">MEDIATECA</a></div>
				</div>
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_3_.png" /></div>
					<div class="title"><a href="handle/123456789/24">OTRAS OBRAS LITERARIAS </a></div>
				</div>
					<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_4_.png" /></div>
					<div class="title"><a href="handle/123456789/4">ARCHIVO HISTORICO DIGITAL</a> </div>
				</div>
				</div>
			
			<div id="col_der">
			<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_5_.png" /></div>
					<div class="title"><a href="handle/123456789/1">DOCENCIA</a></div>
				</div>
					
			
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_6_.png" /></div>
					<div class="title"><a href="handle/123456789/3">TESIS</a></div>
				</div>
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_7_.png" /></div>
					<div class="title"><a href="handle/123456789/5">REVISTAS</a></div>
				</div>
					<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_8_.png" /></div>
					<div class="title"><a href="handle/123456789/6">INSTITUCIONAL</a></div>
				</div>
			
			</div>
		  
	   </xsl:template>
	   
	   
	
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
								<xsl:text>/images/boton_explorar.png</xsl:text>
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
