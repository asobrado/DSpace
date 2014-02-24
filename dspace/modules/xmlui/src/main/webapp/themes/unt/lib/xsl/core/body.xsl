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
				<h1>Comunidades DSpace</h1>
				<div id="col_iz">
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_1_.png" /></div>
					
					<div class="title"><a href="handle/123456789/1">INVESTIGACION</a></div>
				</div>
					
			
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_2_.png" width="80" height="95" /></div>
					<div class="title"><a href="handle/123456789/7">MEDIATEC</a></div>
				</div>
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_3_.png" /></div>
					<div class="title"><a href="handle/123456789/8">OTRAS OBRAS LITERARIAS </a></div>
				</div>
					<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_4_.png" /></div>
					<div class="title"><a href="handle/123456789/6">ARCHIVO HISTORICO DIGITAL</a> </div>
				</div>
				</div>
			
			<div id="col_der">
			<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_5_.png" /></div>
					<div class="title"><a href="handle/123456789/2">DOCENCIA</a></div>
				</div>
					
			
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_6_.png" /></div>
					<div class="title"><a href="handle/123456789/3">TESIS</a></div>
				</div>
				<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_7_.png" /></div>
					<div class="title"><a href="handle/123456789/4">REVISTAS</a></div>
				</div>
					<div class="objeto">
					<div class="icon"><img src="themes/unt/images/icono_8_.png" /></div>
					<div class="title"><a href="handle/123456789/5">INSTITUCIONAL</a></div>
				</div>
			
			</div>
		  
	   </xsl:template>
 </xsl:stylesheet>  