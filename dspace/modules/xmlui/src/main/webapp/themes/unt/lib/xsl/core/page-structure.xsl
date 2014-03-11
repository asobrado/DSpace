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

Author: art.lowel at atmire.com
Author: lieven.droogmans at atmire.com
Author: ben at atmire.com
Author: Alexey Maslov

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
    
    <xsl:template name="cc-license">
        <xsl:param name="metadataURL"/>
        <xsl:variable name="externalMetadataURL">
            <xsl:text>cocoon:/</xsl:text>
            <xsl:value-of select="$metadataURL"/>
            <xsl:text>?sections=dmdSec,fileSec&amp;fileGrpTypes=THUMBNAIL</xsl:text>
        </xsl:variable>

        <xsl:variable name="ccLicenseName"
                      select="document($externalMetadataURL)//dim:field[@element='rights']"
                      />
        <xsl:variable name="ccLicenseUri"
                      select="document($externalMetadataURL)//dim:field[@element='rights'][@qualifier='uri']"
                      />
        <xsl:variable name="handleUri">
                    <xsl:for-each select="document($externalMetadataURL)//dim:field[@element='identifier' and @qualifier='uri']">
                        <a>
                            <xsl:attribute name="href">
                                <xsl:copy-of select="./node()"/>
                            </xsl:attribute>
                            <xsl:copy-of select="./node()"/>
                        </a>
                        <xsl:if test="count(following-sibling::dim:field[@element='identifier' and @qualifier='uri']) != 0">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                </xsl:for-each>
        </xsl:variable>

   <xsl:if test="$ccLicenseName and $ccLicenseUri and contains($ccLicenseUri, 'creativecommons')">
        <div about="{$handleUri}" class="clearfix">
            <xsl:attribute name="style">
                <xsl:text>margin:0em 2em 0em 2em; padding-bottom:0em;</xsl:text>
            </xsl:attribute>
            <a rel="license"
                href="{$ccLicenseUri}"
                alt="{$ccLicenseName}"
                title="{$ccLicenseName}"
                >
                <xsl:call-template name="cc-logo">
                    <xsl:with-param name="ccLicenseName" select="$ccLicenseName"/>
                    <xsl:with-param name="ccLicenseUri" select="$ccLicenseUri"/>
                </xsl:call-template>
            </a>
            <span>
                <xsl:attribute name="style">
                    <xsl:text>vertical-align:middle; text-indent:0 !important;</xsl:text>
                </xsl:attribute>
                <i18n:text>xmlui.dri2xhtml.METS-1.0.cc-license-text</i18n:text>
                <xsl:value-of select="$ccLicenseName"/>
            </span>
        </div>
        </xsl:if>
    </xsl:template>

    <xsl:template name="cc-logo">
        <xsl:param name="ccLicenseName"/>
        <xsl:param name="ccLicenseUri"/>
        <xsl:variable name="ccLogo">
             <xsl:choose>
                  <xsl:when test="starts-with($ccLicenseUri,
'http://creativecommons.org/licenses/by/')">
                       <xsl:value-of select="'cc-by.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
'http://creativecommons.org/licenses/by-sa/')">
                       <xsl:value-of select="'cc-by-sa.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
'http://creativecommons.org/licenses/by-nd/')">
                       <xsl:value-of select="'cc-by-nd.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
'http://creativecommons.org/licenses/by-nc/')">
                       <xsl:value-of select="'cc-by-nc.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
'http://creativecommons.org/licenses/by-nc-sa/')">
                       <xsl:value-of select="'cc-by-nc-sa.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
'http://creativecommons.org/licenses/by-nc-nd/')">
                       <xsl:value-of select="'cc-by-nc-nd.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
'http://creativecommons.org/publicdomain/zero/')">
                       <xsl:value-of select="'cc-zero.png'" />
                  </xsl:when>
                  <xsl:when test="starts-with($ccLicenseUri,
'http://creativecommons.org/publicdomain/mark/')">
                       <xsl:value-of select="'cc-mark.png'" />
                  </xsl:when>
                  <xsl:otherwise>
                       <xsl:value-of select="'cc-generic.png'" />
                  </xsl:otherwise>
             </xsl:choose>
        </xsl:variable>
        <xsl:variable name="ccLogoImgSrc">
            <xsl:value-of select="$theme-path"/>
            <xsl:text>/images/creativecommons/</xsl:text>
            <xsl:value-of select="$ccLogo"/>
        </xsl:variable>
        <img>
             <xsl:attribute name="src">
                <xsl:value-of select="$ccLogoImgSrc"/>
             </xsl:attribute>
             <xsl:attribute name="alt">
                 <xsl:value-of select="$ccLicenseName"/>
             </xsl:attribute>
             <xsl:attribute name="style">
                 <xsl:text>float:left; margin:0em 1em 0em 0em; border:none;</xsl:text>
             </xsl:attribute>
        </img>
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
The meta, body, options elements; the three top-level elements in the schema
-->




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


    <!-- Currently the dri:meta element is not parsed directly. Instead, parts of it are referenced from inside
other elements (like reference). The blank template below ends the execution of the meta branch -->
    <xsl:template match="dri:meta">
    </xsl:template>

    <!-- Meta's children: userMeta, pageMeta, objectMeta and repositoryMeta may or may not have templates of
their own. This depends on the meta template implementation, which currently does not go this deep.
<xsl:template match="dri:userMeta" />
<xsl:template match="dri:pageMeta" />
<xsl:template match="dri:objectMeta" />
<xsl:template match="dri:repositoryMeta" />
-->

    <xsl:template name="addJavascript">
        <xsl:variable name="jqueryVersion">
            <xsl:text>1.6.2</xsl:text>
        </xsl:variable>

        <xsl:variable name="protocol">
            <xsl:choose>
                <xsl:when test="starts-with(confman:getProperty('dspace.baseUrl'), 'https://')">
                    <xsl:text>https://</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>http://</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <script type="text/javascript" src="{concat($protocol, 'ajax.googleapis.com/ajax/libs/jquery/', $jqueryVersion ,'/jquery.min.js')}">&#160;</script>

        <xsl:variable name="localJQuerySrc">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
            <xsl:text>/static/js/jquery-</xsl:text>
            <xsl:value-of select="$jqueryVersion"/>
            <xsl:text>.min.js</xsl:text>
        </xsl:variable>

        <script type="text/javascript">
            <xsl:text disable-output-escaping="yes">!window.jQuery &amp;&amp; document.write('&lt;script type="text/javascript" src="</xsl:text><xsl:value-of
                select="$localJQuerySrc"/><xsl:text disable-output-escaping="yes">"&gt;&#160;&lt;\/script&gt;')</xsl:text>
        </script>



        <!-- Add theme javascipt -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='url']">
            <script type="text/javascript">
                <xsl:attribute name="src">
                    <xsl:value-of select="."/>
                </xsl:attribute>&#160;</script>
        </xsl:for-each>

        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][not(@qualifier)]">
            <script type="text/javascript">
                <xsl:attribute name="src">
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                    <xsl:text>/themes/</xsl:text>
                    <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:attribute>&#160;</script>
        </xsl:for-each>

        <!-- add "shared" javascript from static, path is relative to webapp root -->
        <xsl:for-each select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='javascript'][@qualifier='static']">
            <!--This is a dirty way of keeping the scriptaculous stuff from choice-support
out of our theme without modifying the administrative and submission sitemaps.
This is obviously not ideal, but adding those scripts in those sitemaps is far
from ideal as well-->
            <xsl:choose>
                <xsl:when test="text() = 'static/js/choice-support.js'">
                    <script type="text/javascript">
                        <xsl:attribute name="src">
                            <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                            <xsl:text>/themes/</xsl:text>
                            <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                            <xsl:text>/lib/js/choice-support.js</xsl:text>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
                <xsl:when test="not(starts-with(text(), 'static/js/scriptaculous'))">
                    <script type="text/javascript">
                        <xsl:attribute name="src">
                            <xsl:value-of
                                    select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                            <xsl:text>/</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:attribute>&#160;</script>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- add setup JS code if this is a choices lookup page -->
        <xsl:if test="dri:body/dri:div[@n='lookup']">
          <xsl:call-template name="choiceLookupPopUpSetup"/>
        </xsl:if>

        <!--PNG Fix for IE6-->
        <xsl:text disable-output-escaping="yes">&lt;!--[if lt IE 7 ]&gt;</xsl:text>
        <script type="text/javascript">
            <xsl:attribute name="src">
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='contextPath'][not(@qualifier)]"/>
                <xsl:text>/themes/</xsl:text>
                <xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='theme'][@qualifier='path']"/>
                <xsl:text>/lib/js/DD_belatedPNG_0.0.8a.js?v=1</xsl:text>
            </xsl:attribute>&#160;</script>
        <script type="text/javascript">
            <xsl:text>DD_belatedPNG.fix('#ds-header-logo');DD_belatedPNG.fix('#ds-footer-logo');$.each($('img[src$=png]'), function() {DD_belatedPNG.fixPng(this);});</xsl:text>
        </script>
        <xsl:text disable-output-escaping="yes" >&lt;![endif]--&gt;</xsl:text>


        <script type="text/javascript">
            runAfterJSImports.execute();
        </script>

        <!-- Add a google analytics script if the key is present -->
        <xsl:if test="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']">
            <script type="text/javascript"><xsl:text>
                   var _gaq = _gaq || [];
                   _gaq.push(['_setAccount', '</xsl:text><xsl:value-of select="/dri:document/dri:meta/dri:pageMeta/dri:metadata[@element='google'][@qualifier='analytics']"/><xsl:text>']);
                   _gaq.push(['_trackPageview']);

                   (function() {
                       var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                       ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                       var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
                   })();
           </xsl:text></script>
        </xsl:if>
    </xsl:template>
    
    
	<xsl:template name="buildHomeBody">
<!-- 	<h1>Comunidades DSpace</h1> -->
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
			<h1>Autoarchivo</h1>
			<xsl:call-template name="build-anchor">
				<xsl:with-param name="a.value"></xsl:with-param>
				<xsl:with-param name="a.href">/handle/11327/78</xsl:with-param>
				<xsl:with-param name="img.src">images/autoarchivo.png</xsl:with-param>
				<xsl:with-param name="img.alt">Autoarchivo</xsl:with-param>
			</xsl:call-template>
			<object width="276" height="207">
				<param name="movie" value="//www.youtube.com/v/umLtdb5i2LE?hl=es_MX"></param>
				<param name="allowFullScreen" value="true"></param>
				<param name="allowscriptaccess" value="always"></param>
				<embed src="//www.youtube.com/v/umLtdb5i2LE?hl=es_MX" type="application/x-shockwave-flash" width="276" height="207" allowscriptaccess="always" allowfullscreen="true"></embed>
			</object>
		</div>
	</xsl:template>

</xsl:stylesheet>

