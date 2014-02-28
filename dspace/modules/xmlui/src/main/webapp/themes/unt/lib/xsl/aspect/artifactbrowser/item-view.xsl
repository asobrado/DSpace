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
		
		<!-- title.subtitle row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'title-subtitle'"/>
			<xsl:with-param name="elements" select="dim:field[@element='title' and @qualifier='subtitle'] "/>
		</xsl:call-template>
		
		<!-- book-title row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-book-title'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='bookTitle'] "/>
		</xsl:call-template>

		

		<!-- embargo rows -->
		<xsl:if test="(dim:field[@element='embargo' and @qualifier='liftDate'])">
			<div id="embargo-info">
				<span class="embargo_msg"><i18n:text>xmlui.dri2xhtml.METS-1.0.embargoed-document-description</i18n:text></span>
				<span class="embargo_date">
					<xsl:call-template name="render-date">
						<xsl:with-param name="dateString" select="dim:field[@element='embargo' and @qualifier='liftDate'] "/>
					</xsl:call-template>
				</span>
			</div>
		</xsl:if>

		<!-- date.issued row -->
		<!-- date.exposure/date.issued : extraemos el año solamente -->
		<xsl:choose>
			<xsl:when test="dim:field[@element='date' and @qualifier='exposure']">
				<!--<xsl:call-template name="render-date-year">
					<xsl:with-param name="typeDate" select="dim:field[@element='date' and @qualifier='exposure']/@qualifier"/>
					<xsl:with-param name="dateString">
						<xsl:value-of select="dim:field[@element='date' and @qualifier='exposure']"/>
					</xsl:with-param>
				</xsl:call-template>-->
			</xsl:when>
			<xsl:when test="dim:field[@element='date' and @qualifier='issued']">
			<!--	<xsl:call-template name="render-date-year">
					<xsl:with-param name="typeDate" select="dim:field[@element='date' and @qualifier='issued']/@qualifier"/>
					<xsl:with-param name="dateString">
						<xsl:value-of select="dim:field[@element='date' and @qualifier='issued']"/>
					</xsl:with-param>
				</xsl:call-template>-->
			</xsl:when>
		</xsl:choose>
		<xsl:text>&#160;</xsl:text>
        
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
		<!-- relation.ciclo row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-ciclo'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='ciclo'] "/>
		</xsl:call-template>
		<!-- title.alternative row -->
		<xsl:call-template name="showAlternativeTitles"/>

		<!-- Abstract row -->
		<xsl:if test="(dim:field[@element='abstract'] )">
			<div class="simple-item-view-description">
				<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-abstract</i18n:text></h2>
				<div>
					<xsl:variable name="show_language_indicator">
						<xsl:choose>
							<xsl:when test="count(dim:field[@element='description' and @qualifier='abstract']) &gt; 1">1</xsl:when>
							<xsl:otherwise>0</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:for-each select="dim:field[@element='description' and @qualifier='abstract']">
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
		<!-- note row -->
		<xsl:if test="(dim:field[@element='description' and @qualifier='note'])">
			<div class="simple-item-view-description">
				<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-note</i18n:text></h2>
				<p>
					<xsl:value-of select="dim:field[@element='description' and @qualifier='note']" disable-output-escaping="yes"/>
				</p>
			</div>
		</xsl:if>

		<!-- Solo para el tipo tesis -->
		<xsl:if test="dim:field[@element='type'] = $tesis">
			<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.tesis-info</i18n:text></h2>
			<!-- contributor.director row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'contributor-director'"/>
				<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='director'] "/>
			</xsl:call-template>

			<!-- contributor.codirector row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'contributor-codirector'"/>
				<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='codirector'] "/>
			</xsl:call-template>

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

			<!-- affiliatedInstitution row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'institucion-desarrollo'"/>
				<xsl:with-param name="elements" select="dim:field[@element='institucionDesarrollo'] "/>
			</xsl:call-template>

			<!-- degree.name row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'degree-name'"/>
				<xsl:with-param name="elements" select="dim:field[@element='degree' and @qualifier='name'] "/>
			</xsl:call-template>

			<!-- degree.grantor row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'degree-grantor'"/>
				<xsl:with-param name="elements" select="dim:field[@element='degree' and @qualifier='grantor'] "/>
			</xsl:call-template>
		</xsl:if>


		<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.general-info</i18n:text></h2>
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

		<!-- identifier.expediente row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'identifier-expediente'"/>
			<xsl:with-param name="elements"	select="dim:field[@element='identifier' and @qualifier='expediente'] "/>
		</xsl:call-template>

		<!-- contributor.inscriber row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'contributor-inscriber'"/>
			<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='inscriber'] "/>
		</xsl:call-template>

		<xsl:if	test="(dim:field[@element='contributor' and (@qualifier='editor' or @qualifier='translator' or @qualifier='compiler' or @qualifier='juror' or @qualifier='colaborator')])">

			<!-- contributor.editor row -->
				<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'contributor-editor'" />
					<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='editor']" />
					<xsl:with-param name="separator" select="' | '"/>
				</xsl:call-template>
	
				<!-- contributor.translator row -->
				<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'contributor-translator'" />
					<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='translator']" />
					<xsl:with-param name="separator" select="' | '"/>
				</xsl:call-template>

			<!-- contributor.compiler row -->
				<xsl:if test="dim:field[@element='creator']">
					<xsl:call-template name="render-normal-field">
						<xsl:with-param name="name" select="'contributor-compiler'" />
						<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='compiler']" />
						<xsl:with-param name="separator" select="' | '"/>
					</xsl:call-template>
				</xsl:if>

			<!-- contributor.juror row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'contributor-juror'"/>
				<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='juror'] "/>
				<xsl:with-param name="separator" select="' | '"/>
			</xsl:call-template>

			<!-- contributor.colaborator row -->
			<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'contributor-colaborator'"/>
				<xsl:with-param name="elements" select="dim:field[@element='contributor' and @qualifier='colaborator'] "/>
				<xsl:with-param name="separator" select="' | '"/>
			</xsl:call-template>


		</xsl:if>
			
		<!-- language row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'language'"/>
			<xsl:with-param name="elements" select="dim:field[@element='language' and not(@qualifier)] "/>
			<xsl:with-param name="type" select="'i18n-code'"/>
		</xsl:call-template>
		
		<!-- Creation date, not Issued Date-->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'date-created'"/>
			<xsl:with-param name="elements" select="dim:field[@element='date'][@qualifier='created']"/>
			<xsl:with-param name="type" select="'date'"/>
		</xsl:call-template>

		<!-- Solo para el tipo tesis -->
		<xsl:choose>
			<xsl:when test="dim:field[@element='type'] = $audio">
				<!-- publisher row -->
					<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'produccion'"/>
					<xsl:with-param name="elements" select="dim:field[@element='publisher'] "/>
					</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
					<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'publisher'"/>
					<xsl:with-param name="elements" select="dim:field[@element='publisher'] "/>
					</xsl:call-template>
				</xsl:otherwise>		
		</xsl:choose>	

		<!-- Si hay informacion de la revista, mostramos el metadato -->
		<xsl:if test="dim:field[@element='relation' and @qualifier='journalTitle']">
			<div class="metadata simple-item-view-other relation-journal">
				<span class="metadata-label"><i18n:text>xmlui.dri2xhtml.METS-1.0.item-relation-journal</i18n:text>:</span>
				<span class="metadata-value">
					<xsl:value-of select="dim:field[@element='relation' and @qualifier='journalTitle']" disable-output-escaping="yes"/>
					<xsl:if test="dim:field[@element='relation' and @qualifier='journalVolumeAndIssue']">
						<xsl:text>; </xsl:text>
						<xsl:value-of select="dim:field[@element='relation' and @qualifier='journalVolumeAndIssue']" disable-output-escaping="yes"/>
					</xsl:if>
				</span>
			</div>
		</xsl:if>

		<!-- unt.relation.event row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-event'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='event'] "/>
		</xsl:call-template>

		<!-- relation.dossier row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-dossier'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='dossier'] "/>
		</xsl:call-template>

		<!-- originInfo row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'originInfo'"/>
			<xsl:with-param name="elements" select="dim:field[@element='originInfo']"/>
		</xsl:call-template>

		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'identifier-doi'"/>
			<xsl:with-param name="elements" select="dim:field[@element='identifier' and @qualifier='doi'] "/>
			<xsl:with-param name="separator" select="' | '"/>
			<xsl:with-param name="type" select="'url'"/>
		</xsl:call-template>

		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'identifier-handle'"/>
			<xsl:with-param name="elements" select="dim:field[@element='identifier' and @qualifier='handle'] "/>
			<xsl:with-param name="separator" select="' | '"/>
			<xsl:with-param name="type" select="'url'"/>
		</xsl:call-template>

		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'identifier-other'"/>
			<xsl:with-param name="elements" select="dim:field[@element='identifier' and @qualifier='other'] "/>
			<xsl:with-param name="separator" select="' | '"/>
			<xsl:with-param name="type" select="'url'"/>
		</xsl:call-template>

		<!-- identifier.issn row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'identifier-issn'"/>
			<xsl:with-param name="elements" select="dim:field[@element='identifier' and @qualifier='issn'] "/>
		</xsl:call-template>

		<!-- identifier.isbn row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'identifier-isbn'"/>
			<xsl:with-param name="elements" select="dim:field[@element='identifier' and @qualifier='isbn'] "/>
		</xsl:call-template>

		<!-- location row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'location'"/>
			<xsl:with-param name="elements" select="dim:field[@element='location'] "/>
			<xsl:with-param name="type" select="'url'"/>
			<xsl:with-param name="acotar" select="'true'"/>
		</xsl:call-template>

		<!-- coverage.spatial row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'coverage-spatial'"/>
			<xsl:with-param name="elements" select="dim:field[@element='coverage' and @qualifier='spatial'] "/>
		</xsl:call-template>

		<!-- coverage.temporal row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'coverage-temporal'"/>
			<xsl:with-param name="elements" select="dim:field[@element='coverage' and @qualifier='temporal'] "/>
		</xsl:call-template>

		<!-- format.medium row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'format-medium'"/>
			<xsl:with-param name="elements" select="dim:field[@element='format'][@qualifier='medium']"/>
		</xsl:call-template>
		
		<!-- format.extent row -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'format-extent'"/>
			<xsl:with-param name="elements" select="dim:field[@element='format' and @qualifier='extent'] "/>
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

				<!-- todos los descriptores (terminos de tesuaro) -->
				<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'subject-descriptores'"/>
					<xsl:with-param name="elements" select="dim:field[(@element='subject' and @qualifier='descriptores') or (@element='subject' and @qualifier='decs') or (@element='subject' and @qualifier='eurovoc') or (@element='subject' and @qualifier='acmcss98') or (@element='subject' and @qualifier='other')] "/>
				</xsl:call-template>

				<!-- subject.keyword row --> 
				<xsl:call-template name="render-normal-field">
					<xsl:with-param name="name" select="'subject-keyword'" />
					<xsl:with-param name="elements" select="dim:field[@element='subject' and @qualifier='keyword']" />
				</xsl:call-template>
			</div>
		</xsl:if>

		<!-- relation-review-of row (es probable que sea uno solo) -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-review-of'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='isReviewOf'] "/>
			<xsl:with-param name="type">url</xsl:with-param>
		</xsl:call-template>

		<!-- relation-reviewed-by row (es probable que sea uno solo) -->
		<xsl:call-template name="render-normal-field">
			<xsl:with-param name="name" select="'relation-reviewed-by'"/>
			<xsl:with-param name="elements" select="dim:field[@element='relation' and @qualifier='isReviewedBy'] "/>
			<xsl:with-param name="type">url</xsl:with-param>
		</xsl:call-template>
		
		<!-- relation.isPartOfSeries row -->
		
        <xsl:call-template name="render-normal-field">
    		<xsl:with-param name="name" select="'relation-isPartOfSeries'"/>
    		<xsl:with-param name="elements"    select="dim:field[@element='relation' and @qualifier='isPartOfSeries'] "/>
		</xsl:call-template>

		<!-- Mostramos los documentos relacionados (es probable que sean muchos) -->
		<xsl:if test="dim:field[@element='relation' and @qualifier='isRelatedWith']">
			<div class="metadata simple-item-view-other relation-related-with">
				<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.item-relation-related-with</i18n:text></h2>
				<ul>
					<xsl:for-each select="dim:field[@element='relation' and @qualifier='isRelatedWith']">
						<li>
							<a target="_blank">
								<xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute>
								<xsl:value-of select="."/>
							</a>
						</li>
					</xsl:for-each>
				</ul>
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


		<xsl:apply-templates select="/mets:METS" mode="generate-bitstream"/>

		<!-- peer_review row -->
		<!-- fulltext row -->
		<!-- Si el tipo es audio o video no se muestra que tiene a documento completo -->
		<xsl:if test="dim:field[@element='type'] = $audio and dim:field[@element='type'] = $imagen_en_movimiento">
					
			<xsl:if test="dim:field[@qualifier='peerReview'] or dim:field[@qualifier='fulltext']">
	        	<div id="other_attributes">
					<h2><i18n:text>xmlui.dri2xhtml.METS-1.0.other-attributes</i18n:text></h2>
					<ul>
						<xsl:if test="dim:field[@qualifier='peerReview']">
							<li class="metadata peer-review">
								<i18n:text>xmlui.dri2xhtml.METS-1.0.item-is-<xsl:value-of select="dim:field[@qualifier='peerReview']"/></i18n:text>
							</li>
						</xsl:if>
			
						<!-- fulltext row -->
						<xsl:if test="dim:field[@qualifier='fulltext']">
							<li class="metadata fulltext">
								<i18n:text>xmlui.dri2xhtml.METS-1.0.item-<xsl:value-of select="dim:field[@qualifier='fulltext']"/>-fulltext</i18n:text>
							</li>
						</xsl:if>
					</ul>
				</div>
			</xsl:if>
		</xsl:if>	
				
		<!-- mods.recordInfo.recordContentSource row -->
		<xsl:if test="dim:field[@element='recordInfo' and @qualifier='recordContentSource']">
			<div class="metadata simple-item-view-other record-source">
				<span class="metadata-value">
					<i18n:text>xmlui.dri2xhtml.METS-1.0.item-record-source</i18n:text>
					<xsl:value-of select="dim:field[@element='recordInfo' and @qualifier='recordContentSource']" disable-output-escaping="yes"/>
				</span>
			</div>
		</xsl:if>
		
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

 <xsl:template name="showAlternativeTitles">
    	<xsl:for-each select="dim:field[@element='title' and @qualifier='alternative']">
    		<xsl:call-template name="render-normal-field">
				<xsl:with-param name="name" select="'title-alternative'"/>
				<xsl:with-param name="elements" select="."/>
			</xsl:call-template>
    	</xsl:for-each>
    </xsl:template>
</xsl:stylesheet>