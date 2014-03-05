<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    Rendering specific to the item display page.

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet
    xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
    xmlns:dri="http://di.tamu.edu/DRI/1.0/"
    xmlns:mets="http://www.loc.gov/METS/"
    xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
    xmlns:xlink="http://www.w3.org/TR/xlink/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:ore="http://www.openarchives.org/ore/terms/"
    xmlns:oreatom="http://www.openarchives.org/ore/atom/"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xalan="http://xml.apache.org/xalan"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
    xmlns:jstring="java.lang.String"
    xmlns:rights="http://cosimo.stanford.edu/sdr/metsrights/"
    exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util jstring rights">

    <xsl:output indent="yes"/>


	   <xsl:template name="itemSummaryView-DIM">
        <!-- Generate the info about the item from the metadata section -->
        <xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim" mode="itemSummaryView-DIM"/>

		<xsl:if test="$ds_item_view_toggle_url != ''">
			<div id="view-item-metadata">
				<a>
					<xsl:attribute name="href"><xsl:value-of select="$ds_item_view_toggle_url" /></xsl:attribute>
					<i18n:text>xmlui.ArtifactBrowser.ItemViewer.show_full</i18n:text>
				</a>
			</div>
		</xsl:if>
		
        <!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default)-->
        <!-- <xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CC-LICENSE'] "/> -->

    	</xsl:template>
	

<xsl:template name="itemSummaryView-DIM-fields">
      		<!-- Title row -->
		<xsl:choose>
			<xsl:when test="count(dim:field[@element='title'][not(@qualifier)]) &gt; 0">
				<!-- display first title as h1 -->
				<h1>
					<xsl:value-of select="dim:field[@element='title'][not(@qualifier)][1]/node()" disable-output-escaping="yes"/>
				</h1>
				<xsl:if test="dim:field[@element='title'][not(@qualifier)][2]">
					<div class="simple-item-view-title">
						<xsl:for-each select="dim:field[@element='title'][not(@qualifier)][position() &gt; 1]">
							<span class="metadata-value">
								<xsl:value-of select="./node()" disable-output-escaping="yes"/>
								<xsl:if test="count(following-sibling::dim:field[@element='title'][not(@qualifier)]) != 0">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</span>
						</xsl:for-each>
					</div>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<h1>
					<i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
				</h1>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Author(s) row -->	
		<div class="simple-item-view-authors">
			<xsl:call-template name="show-common-authors-compilador-editor"/>
		</div>		
		
		
		<!-- Para el Tipo de Documento mostramos el unt.subtype porque es mas especifico -->
		<!-- Si no hay subtype, mostramos el dc.type -->
		<xsl:choose>
			<xsl:when test="dim:field[@element='subtype']">
				<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'subtype'"/>
					<xsl:with-param name="elements" select="dim:field[@element='subtype'] "/>
					<xsl:with-param name="filter">type_filter</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="dim:field[@element='type']">
				<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'subtype'"/>
					<xsl:with-param name="elements" select="dim:field[@element='type'] "/>
					<xsl:with-param name="filter">type_filter</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<!-- No hay otherwise -->
		</xsl:choose>
		
		<!-- embargo rows -->
		<xsl:if test="(dim:field[@element='date' and @qualifier='embargoed'])">
			<div id="embargo-info">
				<span class="embargo_msg"><i18n:text>xmlui.dri2xhtml.METS-1.0.embargoed-document-description</i18n:text></span>
				<span class="embargo_date">
					<xsl:call-template name="render-date">
						<xsl:with-param name="dateString" select="dim:field[@element='date' and @qualifier='embargoed'] "/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>


		<!-- Abstract row -->
		<xsl:if test="(dim:field[@element='abstract'] )">
			<div class="simple-item-view-description">
				<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h2>
				<div>
					<xsl:variable name="show_language_indicator">
						<xsl:choose>
							<xsl:when test="count(dim:field[@element='abstract']) &gt; 1">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:for-each select="dim:field[@element='abstract']">
						<!-- Indicador del idioma (solo si hay multiples abstracts) -->
						<xsl:if test="$show_language_indicator = 1">
							<span class="metadata-lang"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-lang-<xsl:value-of select="@language"/></i18n:text></span>
						</xsl:if>
						<p>
							<xsl:value-of select="node()" disable-output-escaping="yes"/>
						</p>
					</xsl:for-each>
				</div>
			</div>
		</xsl:if>
		
		<!-- date.issued row -->
		<!-- date.exposure/date.issued : extraemos el año solamente -->
		<xsl:choose>
			<xsl:when test="dim:field[@element='date' and @qualifier='exposure']">
				<xsl:call-template name="render-date-year">
					<xsl:with-param name="typeDate" select="dim:field[@element='date' and @qualifier='exposure']"/>
					<xsl:with-param name="dateString">
						<xsl:value-of select="dim:field[@element='date' and @qualifier='exposure']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="dim:field[@element='date' and @qualifier='issued']">
				<xsl:call-template name="render-date-year">
					<xsl:with-param name="typeDate" select="dim:field[@element='date' and @qualifier='issued']"/>
					<xsl:with-param name="dateString">
						<xsl:value-of select="dim:field[@element='date' and @qualifier='issued']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<xsl:text>&#160;</xsl:text>
        
        
        <h2><i18n:text>xmlui.dri2xhtml.METS-1.0.general-info</i18n:text></h2>
		
		<!-- Solo para el tipo tesis -->
		<xsl:if test="dim:field[@element='type'] = $tesis">
			<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.tesis-info</i18n:text></h2>
			<!-- contributor.director row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'contributor'"/>
				<xsl:with-param name="elements" select="dim:field[@element='contributor'] "/>
			</xsl:call-template>

			<!-- contributor.advisor row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'contributor-advisor'"/>
				<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='advisor'] "/>
			</xsl:call-template>
		<!-- contributor.juror row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'contributor-juror'"/>
				<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='juror'] "/>
			</xsl:call-template>

			<!-- thesis.degree row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'thesis-degree'"/>
				<xsl:with-param name="elements" select="dim:field[@element='thesis' and @qualifier='degree'] "/>
			</xsl:call-template>
			
			<!-- thesis.grantor row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'thesis-grantor'"/>
				<xsl:with-param name="elements" select="dim:field[@element='thesis' and @qualifier='grantor'] "/>
			</xsl:call-template>
		</xsl:if>

		

		<xsl:if test="not(dim:field[@element='type'] = $tesis)">
			<!-- date.exposure row -->
			<xsl:choose>
				<xsl:when test="dim:field[@element='date' and @qualifier='exposure']">
					<!-- date.exposure row -->
					<xsl:call-template name="render-normal-field">
						<xsl:with-param name="name" select="'date-exposure'"/>
						<xsl:with-param name="elements" select="dim:field[@element='date' and @qualifier='exposure'] "/>
						<xsl:with-param name="type" select="'date'"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="(dim:field[@element='date' and @qualifier='issued']!=dim:field[@element='date' and @qualifier='accessioned'])">
					<!-- date.exposure row -->
					<xsl:call-template name="render-normal-field">
						<xsl:with-param name="name" select="'date-issued'"/>
						<xsl:with-param name="elements" select="dim:field[@element='date' and @qualifier='issued'] "/>
						<xsl:with-param name="type" select="'date'"/>
						
					</xsl:call-template>
				</xsl:when>
					
			</xsl:choose>	
		</xsl:if>

		<!-- unt.relation.event row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-event'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='event'] "/>
		</xsl:call-template>
		
		
		<!-- unt.relation.volumeAndIssue row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-volumeAndIssue'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='volumeAndIssue'] "/>
		</xsl:call-template>
		
		<!-- unt.relation.series row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-series'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='series'] "/>
		</xsl:call-template>
		
		<!-- unt.identifier.issn row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'identifier-issn'"/>
			<xsl:with-param name="elements" select="dim:field[@element='identifier' and @qualifier='issn'] "/>
		</xsl:call-template>

		<!-- unt.identifier.isbn row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'identifier-isbn'"/>
			<xsl:with-param name="elements" select="dim:field[@element='identifier' and @qualifier='isbn'] "/>
		</xsl:call-template>
		
		<!-- dcterms.publisher row -->
		
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'publisher'"/>
			<xsl:with-param name="elements" select="dim:field[@element='publisher'] "/>
		</xsl:call-template>
			
					
		
		<!-- Creation date, not Issued Date-->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'date-created'"/>
			<xsl:with-param name="elements" select="dim:field[@element='date'][@qualifier='created']"/>
			<xsl:with-param name="type" select="'date'"/>
		</xsl:call-template>

		
		<!-- subjects row -->
		<xsl:if test="dim:field[@element='subject']">
			<div id="subjects">
				<!-- subject.materias row -->
				<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'subject-materias'"/>
					<xsl:with-param name="elements" select="dim:field[@element='subject' and @qualifier='materias'] "/>
					<xsl:with-param name="filter">subject_filter</xsl:with-param>
				</xsl:call-template>

				<!-- dcterms.subject row --> 
				<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'subject'" />
					<xsl:with-param name="elements" select="dim:field[@element='subject']" />
				</xsl:call-template>
			</div>
		</xsl:if>

		
		<!-- date.available row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'date-exposure'" />
			<xsl:with-param name="elements" select="dim:field[@element='date' and @qualifier='exposure']" />
			<xsl:with-param name="type" select="'date'"/>
		</xsl:call-template>
		<!-- date.available row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'date-available'" />
			<xsl:with-param name="elements" select="dim:field[@element='date' and @qualifier='issued']" />
			<xsl:with-param name="type" select="'date'"/>
		</xsl:call-template>



<xsl:apply-templates select="." mode="generate-bitstream"/>
	<!-- unt.identifier.other row -->
		<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'identifier-other'"/>
					<xsl:with-param name="elements" select="dim:field[@element='identifier' and @qualifier='other'] "/>
					<xsl:with-param name="separator" select="' | '"/>
					<xsl:with-param name="type" select="'url'"/>
		</xsl:call-template>

		<!-- language row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'language'"/>
			<xsl:with-param name="elements" select="dim:field[@element='language' and not(@qualifier)] "/>
			<xsl:with-param name="type" select="'i18n-code'"/>
		</xsl:call-template>
		
		<!-- unt.description.origen row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'description'"/>
			<xsl:with-param name="elements" select="dim:field[@element='description' and @qualifier='origen'] "/>
			<xsl:with-param name="type" select="'i18n-code'"/>
		</xsl:call-template>
		
		<!-- dcterms.extent row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'extent'"/>
			<xsl:with-param name="elements" select="dim:field[@element='extent'] "/>
		</xsl:call-template>
		
		<!-- dcterms.description row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'description'"/>
			<xsl:with-param name="elements" select="dim:field[@element='description'] "/>
		</xsl:call-template>
		
		
		<!-- Info about how to cite this document -->
		<xsl:if test="./dim:field[@element='identifier'][@qualifier='uri']">
			<div id="item-URI-suggestion">
				<i18n:text>unt.items.handle.utilizacion_URI</i18n:text>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="./dim:field[@element='identifier'][@qualifier='uri']"/>
					</xsl:attribute>
					<xsl:value-of select="./dim:field[@element='identifier'][@qualifier='uri']"/>
				</a>
			</div>
		</xsl:if>
		
		<!-- Generate the Creative Commons license information from the file section (DSpace deposit license hidden by default) -->
		<xsl:apply-templates select="mets:fileSec/mets:fileGrp[@USE='CC-LICENSE'] "/>
		

	</xsl:template>

<xsl:template name="render-normal-field">
		<xsl:param name="name"/>
		<xsl:param name="elements"/>
		<xsl:param name="separator" select="'; '"/>
		<xsl:param name="type" select="'text'"/>
		<xsl:param name="acotar"/>
		<xsl:param name="filter" select="''"/>

		<!-- Generamos salida solo si hay algun elemento para mostrar -->
		<xsl:if test="count($elements) &gt; 0">
			<div>
				<xsl:attribute name="class">
					<xsl:text>metadata simple-item-view-other </xsl:text>
					<xsl:value-of select="$name"/>
				</xsl:attribute>

				<span class="metadata-label"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-<xsl:value-of select="$name"/></i18n:text>:</span>
								
				<xsl:call-template name="render-field-value">
					<xsl:with-param name="elements" select="$elements"/>
					<xsl:with-param name="index" select="1"/>
					<xsl:with-param name="separator" select="$separator"/>
					<xsl:with-param name="type" select="$type"/>
					<xsl:with-param name="acotar" select="$acotar"/>
					<xsl:with-param name="filter" select="$filter"/>
				</xsl:call-template>

			</div>
		</xsl:if>
	</xsl:template>
<xsl:template name="show-common-authors-compilador-editor">
	<h2>	
	<xsl:choose>
		<xsl:when test="dim:field[@element='creator' and @qualifier='author']">
			<xsl:call-template name="render-author-metadata-field">
				<xsl:with-param name="metadata-fields" select="dim:field[@element='creator'][@qualifier='author']"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<i18n:text>xmlui.dri2xhtml.METS-1.0.no-author</i18n:text>
		</xsl:otherwise>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="dim:field[@element='creator' and @qualifier='compilator']">
			<xsl:call-template name="render-author-metadata-field">
				<xsl:with-param name="metadata-fields" select="dim:field[@element='creator'][@qualifier='conpilator']"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
	<xsl:choose>
		<xsl:when test="dim:field[@element='creator' and @qualifier='editor']">
			<xsl:call-template name="render-author-metadata-field">
				<xsl:with-param name="metadata-fields" select="dim:field[@element='creator'][@qualifier='editor']"/>
			</xsl:call-template>
		</xsl:when>
	</xsl:choose>
</h2>
	</xsl:template>
<xsl:template name="render-date">
		<xsl:param name="dateString"/>
		<!-- TODO: se debería obtener el locale del usuario -->
		<!--<xsl:variable name="locale" select="java:java.util.Locale.new('es')"/>-->

		<!-- Se espera el formato YYYY-MM-DD[THH:mm:ssZ] -->

		

	</xsl:template>

<!-- This template receives an authors collection ('metadata-fields'), with same or different qualifiers (person,corporate,etc), and associates them with a 'general-qualifier' received as parameter. -->
	<xsl:template name="render-author-metadata-field">
		<xsl:param name="metadata-fields"/>
		<xsl:param name="general-qualifier"/>
			<xsl:if test="count($metadata-fields) &gt; 0">
				<div>
					<span class="metadata-label">
						<xsl:choose>
							<xsl:when test="count($metadata-fields) &gt; 1">
								<i18n:text>xmlui.dri2xhtml.METS-1.0.item-creators-<xsl:value-of select="$general-qualifier"/></i18n:text>: 
							</xsl:when>
							<xsl:otherwise>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.item-creator-<xsl:value-of select="$general-qualifier"/></i18n:text>: 
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<xsl:for-each select="$metadata-fields">
						<span class="metadata-value">
							<xsl:if test="@authority">
								<xsl:attribute name="class"><xsl:text>ds-dc_contributor_author-authority</xsl:text></xsl:attribute>
							</xsl:if>	
								
							<a>
								<xsl:attribute name="href">
									<xsl:call-template name="filterLink">
										<xsl:with-param name="filter">author_filter</xsl:with-param>
										<xsl:with-param name="value" select="."/>
									</xsl:call-template>
								</xsl:attribute>
								<xsl:copy-of select="node()" />
							</a>
							<xsl:if test="position() != last()">
								<xsl:text> | </xsl:text>
							</xsl:if>
						</span>
					</xsl:for-each>
				</div>
			</xsl:if>
	</xsl:template>
 <xsl:variable name="linkFilter"><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'] "/>/discover</xsl:variable>
    
  <xsl:template name="filterLink">
    	<xsl:param name="filter"/>
    	<xsl:param name="value"/>
    	
		<xsl:variable name="normalizedValue" select="translate(string($value),'áéíóú','aeiou')"/>

    	<xsl:value-of select="$linkFilter"/>
    	<xsl:text>?fq=</xsl:text>
    	<xsl:value-of select="$filter"/>
    	<xsl:text>:</xsl:text>
    	<xsl:value-of select="$normalizedValue"/>
    	<xsl:text>\|\|\|</xsl:text>
    	<xsl:value-of select="$normalizedValue"/>
    </xsl:template>

 <!-- Solo las urls se acotan en caso de que este explicitado -->
	<xsl:template name="render-field-value">
		<xsl:param name="elements"/>
		<xsl:param name="index"/>
		<xsl:param name="separator"/>
		<xsl:param name="type"/>
		<xsl:param name="acotar"/>
		<xsl:param name="filter"/>

		<span class="metadata-value">

			<xsl:choose>
				<xsl:when test="$type='url'">
				<!-- Si $type =url pero no es una url bien formada no se muestra como link. Si $acotar = true, pero es un handle, se muestra completo, de caso contrario solo se muestra el host -->
				  <xsl:choose>					      
			         
						<xsl:otherwise>
							<xsl:value-of select="$elements[$index]" disable-output-escaping="yes"/>
						</xsl:otherwise>
					</xsl:choose>

				</xsl:when>

				<xsl:when test="$type='date'">
					<xsl:call-template name="render-date">
						<xsl:with-param name="dateString" select="$elements[$index] "/>
					</xsl:call-template>
				</xsl:when>

				<xsl:when test="$type='i18n-code'">
					<i18n:text>xmlui.dri2xhtml.METS-1.0.code-value-<xsl:value-of select="$elements[$index]"/></i18n:text>
				</xsl:when>

				<xsl:when test="$filter!=''">
					<a>
						<xsl:attribute name="href">
							<xsl:call-template name="filterLink">
								<xsl:with-param name="filter" select="$filter"/>
								<xsl:with-param name="value" select="$elements[$index]"/>
							</xsl:call-template>
						</xsl:attribute>
						<xsl:value-of select="$elements[$index]" disable-output-escaping="yes"/>
					</a>
				</xsl:when>

				<xsl:otherwise>
					<xsl:value-of select="$elements[$index]" disable-output-escaping="yes"/>
				</xsl:otherwise>
			</xsl:choose>

		</span>

		<xsl:if test="($index &lt; count($elements))">
			<xsl:if test="($separator != '')"><xsl:value-of select="$separator"/></xsl:if>
			<xsl:call-template name="render-field-value">
				<xsl:with-param name="elements" select="$elements"/>
				<xsl:with-param name="index" select="($index + 1)"/>
				<xsl:with-param name="separator" select="$separator"/>
				<xsl:with-param name="type" select="$type"/>
				<xsl:with-param name="acotar" select="$acotar"/>
				<xsl:with-param name="filter" select="$filter"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
<xsl:template name="render-date-year">
			<xsl:param name="typeDate"/>
			<xsl:param name="dateString"/>
		<div class="simple-metadata-view-date">
			<span>
				<xsl:attribute name="class">
					<xsl:text>date-</xsl:text>
					<xsl:value-of select="$typeDate"/>
				</xsl:attribute>
				<xsl:value-of select="$dateString"/>
			</span>
		</div>
	</xsl:template>




	<xsl:template match="mets:METS" mode="generate-bitstream">

		<!-- Generate the bitstream information from the file section -->
		<div id="item-file-section">
			<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
			<xsl:choose>
				<xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='ORE'] or ./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='identifier' and @qualifier='uri' and @mdschema='sedici']">
					<xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
						<xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
							<xsl:with-param name="context" select="."/>
							<xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
						</xsl:apply-templates>
					</xsl:if>

					<!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
					<xsl:if test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
						<xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE'] "/>
					</xsl:if>

					<!-- Localizacion Electronica -->
					<xsl:if test="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='identifier' and @qualifier='uri' and @mdschema='sedici']">
						<xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='identifier' and @qualifier='uri' and @mdschema='sedici'] "/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="mets:fileGrp[@USE='CONTENT']">
		<xsl:param name="context"/>
		<xsl:param name="primaryBitstream" select="-1"/>

		<div class="file-list">
			<xsl:choose>
				<!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
				<xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
					<xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:when>
				<!-- Otherwise, iterate over and display all of them -->
				<xsl:otherwise>
					<xsl:apply-templates select="mets:file">
						<!--Do not sort any more bitstream order can be changed -->
						<!--<xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending"/> -->
						<!--<xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/> -->
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="mets:file">
		<xsl:param name="context" select="."/>

		<!-- nuevo nombre para el documento a descargar -->
		<xsl:variable name="documentTitle">
			<xsl:choose>
				<xsl:when test="mets:FLocat[@LOCTYPE='URL']/@xlink:label">
					<xsl:value-of select="(string(mets:FLocat[@LOCTYPE='URL']/@xlink:label))"/>
				</xsl:when>
				<xsl:when test="$context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title'][@mdschema='dc']">
					<xsl:value-of select="(string($context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title'][@mdschema='dc']))"/>
				</xsl:when>
				<xsl:otherwise>
					<i18n:text>xmlui.bitstream.downloadName</i18n:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="extension" select="substring-after(mets:FLocat[@LOCTYPE='URL']/@xlink:title, '.')"/>
		<xsl:variable name="sequence" select="substring-after(mets:FLocat[@LOCTYPE='URL']/@xlink:href, '?')"/>

		<xsl:variable name="link"> 
           <xsl:value-of select="substring-before(mets:FLocat[@LOCTYPE='URL']/@xlink:href, substring-after($context/@ID, ':'))"/><xsl:value-of select="substring-after($context/@ID, ':')"/>/<xsl:value-of select="$documentTitle"/>.<xsl:value-of select="$extension"/>?<xsl:value-of select="$sequence"/>
        </xsl:variable>

		<div class="file-wrapper clearfix">
			<div class="thumbnail-wrapper">
				<xsl:choose>
             	<xsl:when test="$context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='embargo' and @qualifier='liftDate']">
	              <i18n:text>sedici.comunidades.tesis.embargo</i18n:text>
						<br />
						<span>
							<xsl:choose>
	                        <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]">
	                            <img alt="Thumbnail">
										<xsl:attribute name="src">
	                                    <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
	                                </xsl:attribute>
									</img>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="file_type" select="substring-before(@MIMETYPE, '/')"/>
									<xsl:variable name="file_subtype" select="substring-after(@MIMETYPE, '/')"/>
	                        	<xsl:variable name="img_path">
										<xsl:choose>
		                        		<xsl:when test="$file_type = 'image'">mime_img.png</xsl:when>
		                        		<xsl:when test="$file_subtype = 'pdf'">mime_pdf.png</xsl:when>
		                        		<xsl:when test="$file_subtype = 'msword'">mime_msword.png</xsl:when>
		                        		<xsl:otherwise>mime.png</xsl:otherwise>
		                        	</xsl:choose>
									</xsl:variable>
									<img alt="Icon" src="{concat($theme-path, '/images/',$img_path)}"/>
								</xsl:otherwise>
							</xsl:choose>
						</span>

					</xsl:when>
					<xsl:otherwise>
						<a class="image-link" target="_blank">
							<xsl:attribute name="href">
	                        <xsl:value-of select="$link"/>                        
	                    </xsl:attribute>

						 <xsl:choose>
	                        <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]">
	                            <img alt="Thumbnail">
	                                <xsl:attribute name="src">
	                                    <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
	                                </xsl:attribute>
	                            </img>
	                        </xsl:when>
	                        <xsl:otherwise>
	                        	<xsl:variable name="file_type" select="substring-before(@MIMETYPE, '/')"/>
	                        	<xsl:variable name="file_subtype" select="substring-after(@MIMETYPE, '/')"/>
	                        	<xsl:variable name="img_path">
		                        	<xsl:choose>
		                        		<xsl:when test="$file_type = 'image'">mime_img.png</xsl:when>
		                        		<xsl:when test="$file_type = 'audio'">mime_audio.png</xsl:when>
		                        		<xsl:when test="$file_subtype = 'pdf'">mime_pdf.png</xsl:when>
		                        		<xsl:when test="$file_subtype = 'msword'">mime_msword.png</xsl:when>
		                        		<xsl:otherwise>mime.png</xsl:otherwise>
		                        	</xsl:choose>
	                        	</xsl:variable>
	                            <img alt="Icon" src="{concat($theme-path, '/images/',$img_path)}"/>
	                         </xsl:otherwise>
	                         </xsl:choose>
	                      </a>
	                      </xsl:otherwise> 
	                      </xsl:choose>
	                      </div></div>  
	    <!--  <xsl:template match="mets:METS" mode="generate-bitstream">  -->

		<!-- Generate the bitstream information from the file section -->
		<div id="item-file-section">
			<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-files-head</i18n:text></h2>
			<xsl:choose>
				<xsl:when test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL' or @USE='ORE'] or ./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='identifier' and @qualifier='uri' and @mdschema='sedici']">
					<xsl:if test="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
						<xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='CONTENT' or @USE='ORIGINAL']">
							<xsl:with-param name="context" select="."/>
							<xsl:with-param name="primaryBitstream" select="./mets:structMap[@TYPE='LOGICAL']/mets:div[@TYPE='DSpace Item']/mets:fptr/@FILEID"/>
						</xsl:apply-templates>
					</xsl:if>

					<!-- Special case for handling ORE resource maps stored as DSpace bitstreams -->
					<xsl:if test="./mets:fileSec/mets:fileGrp[@USE='ORE']">
						<xsl:apply-templates select="./mets:fileSec/mets:fileGrp[@USE='ORE'] "/>
					</xsl:if>

					<!-- Localizacion Electronica -->
					<xsl:if test="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='identifier' and @qualifier='uri' and @mdschema='sedici']">
						<xsl:apply-templates select="./mets:dmdSec/mets:mdWrap[@OTHERMDTYPE='DIM']/mets:xmlData/dim:dim/dim:field[@element='identifier' and @qualifier='uri' and @mdschema='sedici'] "/>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
					<p><i18n:text>xmlui.dri2xhtml.METS-1.0.item-no-files</i18n:text></p>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="mets:fileGrp[@USE='CONTENT']">
		<xsl:param name="context"/>
		<xsl:param name="primaryBitstream" select="-1"/>

		<div class="file-list">
			<xsl:choose>
				<!-- If one exists and it's of text/html MIME type, only display the primary bitstream -->
				<xsl:when test="mets:file[@ID=$primaryBitstream]/@MIMETYPE='text/html'">
					<xsl:apply-templates select="mets:file[@ID=$primaryBitstream]">
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:when>
				<!-- Otherwise, iterate over and display all of them -->
				<xsl:otherwise>
					<xsl:apply-templates select="mets:file">
						<!--Do not sort any more bitstream order can be changed -->
						<!--<xsl:sort data-type="number" select="boolean(./@ID=$primaryBitstream)" order="descending"/> -->
						<!--<xsl:sort select="mets:FLocat[@LOCTYPE='URL']/@xlink:title"/> -->
						<xsl:with-param name="context" select="$context"/>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="mets:file">
		<xsl:param name="context" select="."/>

		<!-- nuevo nombre para el documento a descargar -->
		<xsl:variable name="documentTitle">
			<xsl:choose>
				<xsl:when test="mets:FLocat[@LOCTYPE='URL']/@xlink:label">
					<xsl:value-of select="(string(mets:FLocat[@LOCTYPE='URL']/@xlink:label))"/>
				</xsl:when>
				<xsl:when test="$context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title'][@mdschema='dc']">
					<xsl:value-of select="(string($context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title'][@mdschema='dc']))"/>
				</xsl:when>
				<xsl:otherwise>
					<i18n:text>xmlui.bitstream.downloadName</i18n:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="extension" select="substring-after(mets:FLocat[@LOCTYPE='URL']/@xlink:title, '.')"/>
		<xsl:variable name="sequence" select="substring-after(mets:FLocat[@LOCTYPE='URL']/@xlink:href, '?')"/>

		<xsl:variable name="link"> 
           <xsl:value-of select="substring-before(mets:FLocat[@LOCTYPE='URL']/@xlink:href, substring-after($context/@ID, ':'))"/><xsl:value-of select="substring-after($context/@ID, ':')"/>/<xsl:value-of select="$documentTitle"/>.<xsl:value-of select="$extension"/>?<xsl:value-of select="$sequence"/>
        </xsl:variable>

		<div class="file-wrapper clearfix">
			<div class="thumbnail-wrapper">
				<xsl:choose>
             	<xsl:when test="$context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='embargo' and @qualifier='liftDate']">
	              <i18n:text>sedici.comunidades.tesis.embargo</i18n:text>
						<br />
						<span>
							<xsl:choose>
	                        <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]">
	                            <img alt="Thumbnail">
										<xsl:attribute name="src">
	                                    <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
	                                </xsl:attribute>
									</img>
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="file_type" select="substring-before(@MIMETYPE, '/')"/>
									<xsl:variable name="file_subtype" select="substring-after(@MIMETYPE, '/')"/>
	                        	<xsl:variable name="img_path">
										<xsl:choose>
		                        		<xsl:when test="$file_type = 'image'">mime_img.png</xsl:when>
		                        		<xsl:when test="$file_subtype = 'pdf'">mime_pdf.png</xsl:when>
		                        		<xsl:when test="$file_subtype = 'msword'">mime_msword.png</xsl:when>
		                        		<xsl:otherwise>mime.png</xsl:otherwise>
		                        	</xsl:choose>
									</xsl:variable>
									<img alt="Icon" src="{concat($theme-path, '/images/',$img_path)}"/>
								</xsl:otherwise>
							</xsl:choose>
						</span>

					</xsl:when>
					<xsl:otherwise>
						<a class="image-link" target="_blank">
							<xsl:attribute name="href">
	                        <xsl:value-of select="$link"/>                        
	                    </xsl:attribute>

						 <xsl:choose>
	                        <xsl:when test="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]">
	                            <img alt="Thumbnail">
	                                <xsl:attribute name="src">
	                                    <xsl:value-of select="$context/mets:fileSec/mets:fileGrp[@USE='THUMBNAIL']/mets:file[@GROUPID=current()/@GROUPID]/mets:FLocat[@LOCTYPE='URL']/@xlink:href"/>
	                                </xsl:attribute>
	                            </img>
	                        </xsl:when>
	                        <xsl:otherwise>
	                        	<xsl:variable name="file_type" select="substring-before(@MIMETYPE, '/')"/>
	                        	<xsl:variable name="file_subtype" select="substring-after(@MIMETYPE, '/')"/>
	                        	<xsl:variable name="img_path">
		                        	<xsl:choose>
		                        		<xsl:when test="$file_type = 'image'">mime_img.png</xsl:when>
		                        		<xsl:when test="$file_type = 'audio'">mime_audio.png</xsl:when>
		                        		<xsl:when test="$file_subtype = 'pdf'">mime_pdf.png</xsl:when>
		                        		<xsl:when test="$file_subtype = 'msword'">mime_msword.png</xsl:when>
		                        		<xsl:otherwise>mime.png</xsl:otherwise>
		                        	</xsl:choose>
	                        	</xsl:variable>
	                            <img alt="Icon" src="{concat($theme-path, '/images/',$img_path)}"/>
	                         </xsl:otherwise>
	                    </xsl:choose>
                	</a>
                </xsl:otherwise>
             </xsl:choose>
            </div>

			<div class="file-metadata">
				<xsl:choose>
					<xsl:when test="$context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='embargo' and @qualifier='liftDate']">
						<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" disable-output-escaping="yes"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
							<div>
								<a class="image-link" target="_blank">
									<xsl:attribute name="href">
				                        <xsl:value-of select="$link"/>
				                    </xsl:attribute>
									<span><xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" disable-output-escaping="yes"/></span>
								</a>
							</div>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<div>
					<span>
						<xsl:choose>
							<xsl:when test="@SIZE &lt; 1024">
								<xsl:value-of select="@SIZE"/>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
							</xsl:when>
							<xsl:when test="@SIZE &lt; 1024 * 1024">
								<xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
							</xsl:when>
							<xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
								<xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<xsl:text> - </xsl:text>
	                <!-- Lookup File Type description in local messages.xml based on MIME Type.
			         In the original DSpace, this would get resolved to an application via
			         the Bitstream Registry, but we are constrained by the capabilities of METS
			         and can't really pass that info through. -->
                    <span>
						<xsl:call-template name="getFileTypeDesc">
							<xsl:with-param name="mimetype">
								<xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
								<xsl:text>/</xsl:text>
								<xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
							</xsl:with-param>
						</xsl:call-template>
					</span>
				</div>
			</div>

		</div>              

			<div class="file-metadata">
				<xsl:choose>
					<xsl:when test="$context/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='embargo' and @qualifier='liftDate']">
						<xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" disable-output-escaping="yes"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="mets:FLocat[@LOCTYPE='URL']/@xlink:label != ''">
							<div>
								<a class="image-link" target="_blank">
									<xsl:attribute name="href">
				                        <xsl:value-of select="$link"/>
				                    </xsl:attribute>
									<span><xsl:value-of select="mets:FLocat[@LOCTYPE='URL']/@xlink:label" disable-output-escaping="yes"/></span>
								</a>
							</div>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
				<div>
					<span>
						<xsl:choose>
							<xsl:when test="@SIZE &lt; 1024">
								<xsl:value-of select="@SIZE"/>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.size-bytes</i18n:text>
							</xsl:when>
							<xsl:when test="@SIZE &lt; 1024 * 1024">
								<xsl:value-of select="substring(string(@SIZE div 1024),1,5)"/>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.size-kilobytes</i18n:text>
							</xsl:when>
							<xsl:when test="@SIZE &lt; 1024 * 1024 * 1024">
								<xsl:value-of select="substring(string(@SIZE div (1024 * 1024)),1,5)"/>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.size-megabytes</i18n:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring(string(@SIZE div (1024 * 1024 * 1024)),1,5)"/>
								<i18n:text>xmlui.dri2xhtml.METS-1.0.size-gigabytes</i18n:text>
							</xsl:otherwise>
						</xsl:choose>
					</span>
					<xsl:text> - </xsl:text>
	                <!-- Lookup File Type description in local messages.xml based on MIME Type.
			         In the original DSpace, this would get resolved to an application via
			         the Bitstream Registry, but we are constrained by the capabilities of METS
			         and can't really pass that info through. -->
                    <span>
						<xsl:call-template name="getFileTypeDesc">
							<xsl:with-param name="mimetype">
								<xsl:value-of select="substring-before(@MIMETYPE,'/')"/>
								<xsl:text>/</xsl:text>
								<xsl:value-of select="substring-after(@MIMETYPE,'/')"/>
							</xsl:with-param>
						</xsl:call-template>
					</span>
				</div>
			</div>



	</xsl:template>
	

	
 </xsl:stylesheet>