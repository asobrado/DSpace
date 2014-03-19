<?xml version="1.0" encoding="UTF-8"?>
<!--

The contents of this file are subject to the license and copyright
detailed in the LICENSE and NOTICE files at the root of the source
tree and available online at

http://www.dspace.org/license/

-->
<!--
Main structure of the page, determines where
header, footer, body, navigation are structurally rendered.
Rendering of the header, footer, trail and alerts
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
    xmlns:confman="org.dspace.core.ConfigurationManager"
xmlns="http://www.w3.org/1999/xhtml"
exclude-result-prefixes="i18n dri mets xlink xsl dim xhtml mods dc confman">

    <xsl:output indent="yes" />

    <!--
Requested Page URI. Some functions may alter behavior of processing depending if URI matches a pattern.
Specifically, adding a static page will need to override the DRI, to directly add content.
-->
    <xsl:variable name="request-uri" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='URI']"/>

    <!--
The starting point of any XSL processing is matching the root element. In DRI the root element is document,
which contains a version attribute and three top level elements: body, options, meta (in that order).

This template creates the html document, giving it a head and body. A title and the CSS style reference
are placed in the html head, while the body is further split into several divs. The top-level div
directly under html body is called "ds-main". It is further subdivided into:
"ds-header" - the header div containing title, subtitle, trail and other front matter
"ds-body" - the div containing all the content of the page; built from the contents of dri:body
"ds-options" - the div with all the navigation and actions; built from the contents of dri:options
"ds-footer" - optional footer div, containing misc information

The order in which the top level divisions appear may have some impact on the design of CSS and the
final appearance of the DSpace page. While the layout of the DRI schema does favor the above div
arrangement, nothing is preventing the designer from changing them around or adding new ones by
overriding the dri:document template.
-->
    <xsl:template match="dri:document">
        <html class="no-js">
            <!-- First of all, build the HTML head element -->
            <xsl:call-template name="buildHead"/>
            <!-- Then proceed to the body -->

            <!--paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/-->
            <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 7 ]&gt; &lt;body class="ie6"&gt; &lt;![endif]--&gt;
                &lt;!--[if IE 7 ]&gt; &lt;body class="ie7"&gt; &lt;![endif]--&gt;
                &lt;!--[if IE 8 ]&gt; &lt;body class="ie8"&gt; &lt;![endif]--&gt;
                &lt;!--[if IE 9 ]&gt; &lt;body class="ie9"&gt; &lt;![endif]--&gt;
                &lt;!--[if (gt IE 9)|!(IE)]&gt;&lt;!--&gt;&lt;body&gt;&lt;!--&lt;![endif]--&gt;</xsl:text>

            <xsl:choose>
				<xsl:when test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='framing'][@qualifier='popup']">
					<xsl:apply-templates select="dri:body/*"/>
				</xsl:when>
				<xsl:otherwise>
                	<div id="ds-main">
                        <div id="wrapper">
	                        <!--The header div, complete with title, subtitle and other junk-->
	                        <xsl:call-template name="buildHeader"/>
	
	                        <!--javascript-disabled warning, will be invisible if javascript is enabled-->
	                        <div id="no-js-warning-wrapper" class="hidden">
	                            <div id="no-js-warning">
	                                <div class="notice failure">
	                                    <xsl:text>JavaScript is disabled for your browser. Some features of this site may not work without it.</xsl:text>
	                                </div>
	                            </div>
							</div>
							
							<div id="ds-content-wrapper">
	                            <div id="ds-content" class="clearfix">
	        						<xsl:apply-templates select="/dri:document/dri:options"/>
	        						<xsl:apply-templates select="/dri:document/dri:body"/>
	        						<xsl:apply-templates select="/dri:document/dri:meta"/>
	  							</div>
	                        </div>
							<xsl:call-template name="buildFooter"/>
						</div> 
					</div>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Javascript at the bottom for fast page loading -->
			<xsl:call-template name="addJavascript"/>
            <xsl:text disable-output-escaping="yes">&lt;/body&gt;</xsl:text>
        </html>
    </xsl:template>
    
    
        <!-- The HTML head element contains references to CSS as well as embedded JavaScript code. Most of this
        information is either user-provided bits of post-processing (as in the case of the JavaScript), or
        references to stylesheets pulled directly from the pageMeta element. -->
    <xsl:template name="buildHea2d">
        <head>

			<xsl:call-template name="buildLinkAndMeta" />
			
            <!-- Modernizr enables HTML5 elements & feature detects -->
            <script type="text/javascript">
                <xsl:attribute name="src">
		            <xsl:call-template name="print-path">
			            <xsl:with-param name="path">/themes/Mirage/lib/js/modernizr-1.7.min.js</xsl:with-param>
			        </xsl:call-template>
                </xsl:attribute>&#160;
            </script>

            <!-- Add the title in -->
            
            <title>
	            <xsl:variable name="page_title" select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='title']" />    
	            <xsl:choose>
                        <xsl:when test="starts-with($request-uri, 'page/about')">
                                <xsl:text>About This Repository</xsl:text>
                        </xsl:when>
                        <xsl:when test="not($page_title)">
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:when>
                        <xsl:when test="$page_title = ''">
                            <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                        </xsl:when>
                        <xsl:otherwise>
                                <xsl:copy-of select="$page_title/node()" />
                        </xsl:otherwise>
                </xsl:choose>
            </title>

            <!-- Head metadata in item pages -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='xhtml_head_item']"
                              disable-output-escaping="yes"/>
            </xsl:if>

        </head>
    </xsl:template>
    

    <xsl:template name="buildLinkAndMeta">
			
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>

            <!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame -->
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>

            <!--  Mobile Viewport Fix
                  j.mp/mobileviewport & davidbcalhoun.com/2010/viewport-metatag
            device-width : Occupy full width of the screen in its current orientation
            initial-scale = 1.0 retains dimensions instead of zooming out if page height > device height
            maximum-scale = 1.0 retains dimensions instead of zooming in if page width < device width
            -->
            <meta name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0;"/>

            <link rel="shortcut icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/images/favicon.ico</xsl:text>
                </xsl:attribute>
            </link>
            <link rel="apple-touch-icon">
                <xsl:attribute name="href">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/images/apple-touch-icon.png</xsl:text>
                </xsl:attribute>
            </link>

            <meta name="Generator">
              <xsl:attribute name="content">
                <xsl:text>DSpace</xsl:text>
                <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='dspace'][@qualifier='version']"/>
                </xsl:if>
              </xsl:attribute>
            </meta>
            <!-- Add stylesheets -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='stylesheet']">
                <link rel="stylesheet" type="text/css">
                    <xsl:attribute name="media">
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                        <xsl:text>/themes/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!-- Add syndication feeds -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='feed']">
                <link rel="alternate" type="application">
                    <xsl:attribute name="type">
                        <xsl:text>application/</xsl:text>
                        <xsl:value-of select="@qualifier"/>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </link>
            </xsl:for-each>

            <!--  Add OpenSearch auto-discovery link -->
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']">
                <link rel="search" type="application/opensearchdescription+xml">
                    <xsl:attribute name="href">
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='scheme']"/>
                        <xsl:text>://</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverName']"/>
                        <xsl:text>:</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='request'][@qualifier='serverPort']"/>
                        <xsl:value-of select="$context-path"/>
                        <xsl:text>/</xsl:text>
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='autolink']"/>
                    </xsl:attribute>
                    <xsl:attribute name="title" >
                        <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='opensearch'][@qualifier='shortName']"/>
                    </xsl:attribute>
                </link>
            </xsl:if>

            <!-- Add all Google Scholar Metadata values -->
            <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[substring(@element, 1, 9) = 'citation_']">
                <meta name="{@element}" content="{.}"></meta>
            </xsl:for-each>
    </xsl:template>
    
    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
placeholders for header images -->
    <xsl:template name="buildHeader">
        <div id="ds-header-wrapper">
            <div id="ds-header" class="clearfix">
				<div id="ds-header-logo-link">
					<xsl:call-template name="build-anchor">
						<xsl:with-param name="img.src">images/marca.png</xsl:with-param>
						<xsl:with-param name="img.alt">RIUNT</xsl:with-param>
						<xsl:with-param name="a.href">/</xsl:with-param>
					</xsl:call-template>
				</div>
			    <div id="header-bar">
	            	<xsl:call-template name="buildUserBox" />
    	            <xsl:call-template name="languageSelection" />
        		</div>
       		</div>
		</div>
    </xsl:template>
    <xsl:template name="buildUserBox">
		<ul >
			<xsl:if test="(//dri:userMeta/dri:metadata[@element='identifier' and @qualifier='group'] = $admin_group) or (//dri:userMeta/dri:metadata[@element='identifier' and @qualifier='group'] = 'Administrator')">
				<li>
				<xsl:call-template name="build-anchor">
					<xsl:with-param name="a.href">
						<xsl:value-of select="concat('/handle/', $autoarchivo_handle)"/>
					</xsl:with-param>
					<xsl:with-param name="a.value">
						Autoarchivo
					</xsl:with-param>
				</xsl:call-template>
				</li>
			</xsl:if>
			<xsl:for-each select="/dri:document/dri:options/dri:list[@n='account']/dri:item	">
				<xsl:sort select="position()" data-type="number" order="descending"/>
        
				<li>
				<xsl:call-template name="build-anchor">
					<xsl:with-param name="a.href">
						<xsl:value-of select="dri:xref/@target"/>
					</xsl:with-param>
					<xsl:with-param name="a.value">
						<xsl:copy-of select="dri:xref/*"/>
					</xsl:with-param>
				</xsl:call-template>
				</li>
			</xsl:for-each>
		</ul>
	 </xsl:template>
	 <xsl:template name="languageSelection">
				<xsl:call-template name="build-anchor">
					<xsl:with-param name="a.href">/?locale-attribute=es</xsl:with-param>
					<xsl:with-param name="img.src">images/esp.png</xsl:with-param>
					<xsl:with-param name="img.alt">Español</xsl:with-param>
				</xsl:call-template>
				<xsl:call-template name="build-anchor">
					<xsl:with-param name="a.href">/?locale-attribute=en</xsl:with-param>
					<xsl:with-param name="img.src">images/eng.png</xsl:with-param>
					<xsl:with-param name="img.alt">English</xsl:with-param>
				</xsl:call-template>
	 </xsl:template>
	 
	 
    <!-- The header (distinct from the HTML head element) contains the title, subtitle, login box and various
placeholders for header images -->
     <xsl:template name="buildTrail">
		<div id="ds-trail">
			
			<div id="right-trail">
				<xsl:text> </xsl:text>	
			</div>
		
			<ul id="left-trail">
				<xsl:choose>
				    <xsl:when test="starts-with($request-uri, 'page/')">
				        <li class="ds-trail-link first-link"><a>
				        	<xsl:attribute name="href"><xsl:value-of select="//dri:pageMeta/dri:metadata[@element='contextPath']"/></xsl:attribute>
				        	<xsl:text>Inicio</xsl:text>
			        	</a></li>
				        <li class="ds-trail-arrow"><xsl:text>&#8594;</xsl:text></li>
				        <li class="ds-trail-link"><xsl:text>Ayuda</xsl:text></li>
				    </xsl:when>
				    <xsl:when test="count(/dri:document/dri:meta/dri:pageMeta/dri:trail) = 0 or ($request-uri = '')">
				        <li class="ds-trail-link first-link"></li>
				    </xsl:when>
				    <xsl:otherwise>
				        <xsl:apply-templates select="/dri:document/dri:meta/dri:pageMeta/dri:trail"/>
				    </xsl:otherwise>
				</xsl:choose>
				
			</ul>
		
	</div>        
  </xsl:template>

    <xsl:template match="dri:trail">
        <!--put an arrow between the parts of the trail-->
	<xsl:if test="position()>1">
            <li class="ds-trail-arrow">
                <xsl:text>&#8594;</xsl:text>
            </li>
        </xsl:if>
        <li>
            <xsl:attribute name="class">
                <xsl:text>ds-trail-link </xsl:text>
                <xsl:if test="position()=1">
                    <xsl:text>ds-trail-link</xsl:text>
                </xsl:if>
                <xsl:if test="position()=last()">
                    <xsl:text>ds-trail-link</xsl:text>
                </xsl:if>
            </xsl:attribute>
            <!-- Determine whether we are dealing with a link or plain text trail link -->
            <xsl:choose>
                <xsl:when test="./@target">
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="./@target"/>
                        </xsl:attribute>
                        <xsl:apply-templates />
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>
    

    <!-- Like the header, the footer contains various miscellaneous text, links, and image placeholders -->
    <xsl:template name="buildFooter">
        <div id="ds-footer-wrapper"> 
			<div id="ds-footer">
				<div id="ds-footer-left">
								
					<xsl:call-template name="build-anchor">
						<xsl:with-param name="a.href">http://www.dspace.org/</xsl:with-param>
						<xsl:with-param name="img.src">images/dspace_footer.png</xsl:with-param>
						<xsl:with-param name="img.alt">DSpace</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="build-anchor">
						<xsl:with-param name="a.href">http://sedici.unlp.edu.ar/</xsl:with-param>
						<xsl:with-param name="img.src">images/sedici_footer.png</xsl:with-param>
						<xsl:with-param name="img.alt">SEDICI</xsl:with-param>
					</xsl:call-template>
					<xsl:call-template name="build-anchor">
						<xsl:with-param name="a.href">http://www.facet.unt.edu.ar/</xsl:with-param>
						<xsl:with-param name="img.src">images/facet_footer.png</xsl:with-param>
						<xsl:with-param name="img.alt">FACET</xsl:with-param>
					</xsl:call-template>
								
				</div>
				
				<div id="ds-footer-right">
					<div>
						<i18n:text>unt.footer.copyright</i18n:text>
					</div>
					<div class="direccion">
						<a href="https://plus.google.com/102293151160073378994/about?gl=ar">
							<i18n:text>unt.footer.address</i18n:text>
						</a>
					</div>
					
				</div>
			</div>
		</div>
    </xsl:template>





    <!--
The template to handle the dri:body element. It simply creates the ds-body div and applies
templates of the body's child elements (which consists entirely of dri:div tags).
-->
    <xsl:template match="dri:body">
        <div id="ds-body">
        <!--The trail is built by applying a template over pageMeta's trail children. -->
                        <xsl:call-template name="buildTrail"/>
            <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']">
                <div id="ds-system-wide-alert">
                    <p>
                        <xsl:copy-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='alert'][@qualifier='message']/node()"/>
                    </p>
                </div>
            </xsl:if>

            <!-- Check for the custom pages -->
            <xsl:choose>
	            <xsl:when test="$request-uri = ''">
	            	<xsl:call-template name="buildHomeBody"/>
	            </xsl:when>
	            <xsl:when test="starts-with($request-uri, 'page/')">
                    <div class="static-page">
                   		<xsl:copy-of select="document(concat('../../../',$request-uri,'.xhtml') )" />
                    </div>
                </xsl:when>

                <!-- Otherwise use default handling of body -->
                <xsl:otherwise>
                    <xsl:apply-templates />
                </xsl:otherwise>
            </xsl:choose>

        </div>
    </xsl:template>


    
	<xsl:template name="buildHomeBody">
		<ul id="launcher">
			<xsl:for-each select="/dri:document/dri:body/dri:div[@n='comunity-browser']/dri:referenceSet/dri:reference">
				<xsl:variable name="community_document" select="document(concat('cocoon:/', @url))"/>
	        	<xsl:variable name="community_title" select="$community_document/mets:METS/mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim/dim:field[@element='title' and @mdschema='dc']"/>
				<xsl:variable name="community_logo" select="$community_document/mets:METS/mets:fileSec/mets:fileGrp[@USE='LOGO']"/>
				
				<xsl:if test="not(starts-with($community_title,'.' ))">
					<li>
						<xsl:call-template name="build-anchor">
							<xsl:with-param name="a.value"><div class="icon-title"><xsl:value-of select="$community_title"/></div></xsl:with-param>
							<xsl:with-param name="a.href"><xsl:value-of select="$community_document/mets:METS/@OBJID"/></xsl:with-param>
							<xsl:with-param name="img.src"><xsl:value-of select="$community_logo/mets:file/mets:FLocat/@xlink:href"/></xsl:with-param>
						</xsl:call-template>
					</li>
				</xsl:if>
			</xsl:for-each>
		  </ul>
		
		  <div id="launcher-right">
			<xsl:call-template name="build-anchor">
				<xsl:with-param name="a.value"></xsl:with-param>
				<xsl:with-param name="a.href"><xsl:value-of select="concat('/handle/',	$autoarchivo_handle,'/submit')"/></xsl:with-param>
				<xsl:with-param name="img.src">images/autoarchivo.png</xsl:with-param>
				<xsl:with-param name="img.alt">Autoarchivo</xsl:with-param>
			</xsl:call-template>
			
			<xsl:call-template name="build-anchor">
				<xsl:with-param name="a.value"></xsl:with-param>
				<xsl:with-param name="a.href">/page/autoarchivo</xsl:with-param>
				<xsl:with-param name="img.src">images/video.png</xsl:with-param>
				<xsl:with-param name="img.alt">Autoarchivo</xsl:with-param>
			</xsl:call-template>
			
			<ul id="home-videos">
				<li>
					<xsl:call-template name="build-anchor">
						<xsl:with-param name="a.value">¿Qué es el RIUNT?</xsl:with-param>
						<xsl:with-param name="a.href">/page/acerca-de</xsl:with-param>
					</xsl:call-template>
				</li>
				<li>
					<xsl:call-template name="build-anchor">
						<xsl:with-param name="a.value">¿Cómo deposito mis publicaciones?</xsl:with-param>
						<xsl:with-param name="a.href">/page/autoarchivo</xsl:with-param>
					</xsl:call-template>
				</li>
				<li>
					<xsl:call-template name="build-anchor">
						<xsl:with-param name="a.value">¿Cuáles son mis derechos de autor?</xsl:with-param>
						<xsl:with-param name="a.href">/page/derechos-de-autor</xsl:with-param>
					</xsl:call-template>
				</li>
				<li>
					<xsl:call-template name="build-anchor">
						<xsl:with-param name="a.value">Si publico en RIUNT, ¿mis obras estarán protegidas?</xsl:with-param>
						<xsl:with-param name="a.href">/page/licencias</xsl:with-param>
					</xsl:call-template>
				</li>
			</ul>
			
		</div>
	</xsl:template>

</xsl:stylesheet>

