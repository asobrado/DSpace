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

	
  <xsl:template name="buildBody">
	   <xsl:choose>
	   		
            <xsl:when test="(contains(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request' and @qualifier='URI'],''))">
            		<xsl:if match="/dri:document/dri:body/dri:div[@id='aspect.artifactbrowser.CommunityBrowser.div.comunity-browser']" >
            			<div id="tercera_columna"><h1>Videos</h1>
							<img src="themes/unt/images/videos.png" />
							<div class="imagen">  <img src="themes/unt/images/autoarchivo.png" /></div>
							AUTOARCHIVO
							</div>
            			<xsl:call-template name="buildCommunities"/>
            		</xsl:if>	
		   </xsl:when>
		    <xsl:when test="(contains(/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request' and @qualifier='URI'],'static'))">
		   </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
   </xsl:template>
	


<xsl:template name="buildCommunities">
	   <h1>Comunidades DSpace</h1>
<div id="col_iz">
	<div class="objeto">
		<div class="icon"><img src="icono_1_.png" /></div>
		
		<div class="title">INVESTIGACION</div>
	</div>
		

	<div class="objeto">
		<div class="icon"><img src="icono_2_.png" width="80" height="95" /></div>
		<div class="title">MEDIATECA</div>
	</div>
	<div class="objeto">
		<div class="icon"><img src="icono_3_.png" /></div>
		<div class="title">OTRAS OBRAS LITERARIAS </div>
	</div>
		<div class="objeto">
		<div class="icon"><img src="icono_4_.png" /></div>
		<div class="title">ARCHIVO HISTORICO DIGITAL </div>
	</div>
	</div>

<div id="col_der">
<div class="objeto">
		<div class="icon"><img src="icono_5_.png" /></div>
		<div class="title">DOCENCIA</div>
	</div>
		

	<div class="objeto">
		<div class="icon"><img src="icono_6_.png" /></div>
		<div class="title">TESIS</div>
	</div>
	<div class="objeto">
		<div class="icon"><img src="icono_7_.png" /></div>
		<div class="title">REVISTAS</div>
	</div>
		<div class="objeto">
		<div class="icon"><img src="icono_8_.png" /></div>
		<div class="title">INSTITUCIONAL</div>
	</div>

</div>
	  
   </xsl:template>
 </xsl:stylesheet>  