<?xml version="1.0" encoding="utf-8"?>
<!-- 
    Copyright © 2009,2010 Łukasz Rekucki

    This file is part of WL2PDF

    WL2PDF is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    WL2PDF is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with WL2PDF.  If not, see <http://www.gnu.org/licenses/>.
 -->
<xsl:stylesheet version="2.0"

    xmlns:wlml="http://nowoczesnapolska.org.pl/ML/Lektury/1.1"
	
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
       
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:wlf="http://wolnelektury.pl/functions" >


    <!-- generic template parameters -->
    <xsl:param name="base-font-size" select="xs:integer(12)" />
    <xsl:param name="base-font" select="'DejaVu Serif'" />        
    
    <xsl:variable name="footnote-font-size" select="$base-font-size - 2" />
    <xsl:variable name="header-font-size" select="$base-font-size" />    				
          
    <xsl:include href="wl2fo_pagemaster.xsl" />    
    
    <xsl:output method="xml"
        encoding="utf-8"
        indent="yes"
        omit-xml-declaration = "yes" />


    <!-- main templates -->
    <xsl:template match="/">
        <fo:root >
            <xsl:call-template name="layout-masters" />

            <fo:page-sequence master-reference="book-titles">
                <xsl:call-template name="title-page" />
            </fo:page-sequence>

            <fo:page-sequence
                language="pl"
                master-reference="main"
                initial-page-number="1"
                force-page-count="even">


                 <!-- RUNNING HEADERS -->

                <fo:static-content
                    flow-name="xsl-footnote-separator">
                    <fo:block text-align-last="justify"><fo:leader leader-pattern="rule"/></fo:block>
                </fo:static-content>

                <fo:static-content
                    flow-name="odd-after" font-family="{$base-font}" text-align="center">
                    <fo:block>
                        <fo:page-number />
                    </fo:block>
                </fo:static-content>

                <fo:static-content
                    flow-name="even-after" font-family="{$base-font}" text-align="center">
                    <fo:block>
                        <fo:page-number />
                    </fo:block>
                </fo:static-content>


                <fo:static-content
                    flow-name="even-before"
                    font-family="DejaVu Serif"
                    text-align="right">

                    <fo:block border-bottom-width="0.2mm"
                        border-bottom-style="solid"
                        border-bottom-color="black">
                           <fo:retrieve-marker retrieve-class-name="odd-header" />
                    </fo:block>
                </fo:static-content>

                <fo:static-content
                    flow-name="odd-before"
                    font-family="DejaVu Serif"
                    text-align="left">
                        
                    <fo:block border-after-width="0.2mm"
                        border-after-style="solid"
                        border-after-color="black">
                        <fo:retrieve-marker retrieve-class-name="even-header" />
                    </fo:block>
                </fo:static-content>

                <fo:flow 
                	flow-name="xsl-region-body" 
                	font-family="{$base-font}"
                	font-size="{concat($base-font-size, 'pt')}"
                    line-height-shift-adjustment="disregard-shifts" >
                    
                    <fo:marker marker-class-name="even-header">
                        <xsl:value-of select="//wlml:author" />
                    </fo:marker>
                    <fo:marker marker-class-name="odd-header">
                        <xsl:value-of select="//wlml:title" />
                    </fo:marker>

                    <xsl:apply-templates select="//wlml:main-text" />
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>

    <xsl:template match="wlml:main-text">        
        <xsl:apply-templates select="child::*" />
    </xsl:template>

<!-- 
    PROZA: elementy proste 
-->

    <xsl:template match="wlml:chapter">
        <fo:block text-align="left" font-size="300%"
            font-weight="bold" 
            page-break-before="right">
            
            <fo:marker marker-class-name="even-header">
                <xsl:apply-templates select="node()" />
            </fo:marker>
            <xsl:apply-templates select="node()" />            
        </fo:block>
    </xsl:template>

    <xsl:template match="wlml:p">
        <fo:block        	
            text-align="justify"
            hyphenate="true" line-height="1.5"
            space-before="1em"
            space-after="1em"
            text-indent="1.5em">
            <xsl:apply-templates select="child::node()" />
        </fo:block>
    </xsl:template>

    <xsl:template match="wlml:pd">
        <fo:block text-align="justify" hyphenate="true" line-height="1.5"
        space-before="1em" 
        space-after="1em" 
        text-indent="1.5em"
    >&#x2014;<fo:character character="&#x2060;" /><fo:character character="&#x2002;" /><xsl:apply-templates select="child::node()" />
        </fo:block>
    </xsl:template>

<!-- 
    POEZJA
-->
    <xsl:template match="wlml:stanza">
        <fo:block space-before="1.5em" space-after="1.5em" keep-together.within-page="50">
            <xsl:apply-templates select="child::node()" />            
        </fo:block>
    </xsl:template>

    <xsl:template match="wlml:v|wlml:vc">
    	<fo:block line-height="1.4"><xsl:apply-templates select="node()" /></fo:block>        
    </xsl:template>
    
    <xsl:template match="wlml:vi">
    	    	 
    	<fo:block line-height="1.4">
    	<xsl:attribute name="text-indent">
    		<xsl:choose>
    			<xsl:when test="@size">
    				<xsl:value-of select="concat(xs:string(xs:integer(@size)), 'em')" />
    			</xsl:when>
    			<xsl:otherwise>1em</xsl:otherwise>    			
    		</xsl:choose>    	
   		</xsl:attribute>
   		<xsl:apply-templates select="node()" />
    	</fo:block>        
    </xsl:template>

<!--
    DRAMAT
-->

<xsl:template match="wlml:drama-line">        
    <xsl:apply-templates select="child::node()" />       
</xsl:template>

<xsl:template match="wlml:drama-line/wlml:person">
    <fo:block 
    	font-weight="bold"    	
    	text-transform="uppercase"   	
    	
        keep-with-next.within-page="always"
        keep-with-previous.within-page="0">
        <xsl:apply-templates select="node()" />
    </fo:block>
</xsl:template>

<xsl:template match="wlml:drama-line/wlml:stanza" priority="10">
        <fo:block space-before="0.5em" space-after="1.5em" 
        	keep-together.within-page="50"
        	keep-with-previous.within-page="10" >        	
            <xsl:apply-templates select="child::node()" />
        </fo:block>
</xsl:template>

<xsl:template match="wlml:person-list">
<fo:block keep-together.within-page="100"
	break-before="page" break-after="page">
<fo:block text-transform="uppercase" 
	font-weight="bold" font-size="150%"
	line-height="1.4" space-after="2em">
	<xsl:value-of select="wlml:caption" />
</fo:block>
<xsl:apply-templates select="wlml:person" />
</fo:block>
</xsl:template>

<xsl:template match="wlml:person">
<fo:block space-after="1em">
	<xsl:apply-templates select="child::node()" />
</fo:block>
</xsl:template> 


<!--
    Wyroznienia
-->
    <xsl:template match="wlml:foreign">
        <fo:inline font-style="italic">
            <xsl:apply-templates select="node()" />
        </fo:inline><fo:character character="&#8197;" />
    </xsl:template>


<!--
    Przypisy
-->
<xsl:template match="wlml:anchor">
    <xsl:variable name="annot" select="/wlml:doc/wlml:annotations/wlml:annotation[@refs = current()/@id]" />
    <fo:footnote>
        <fo:inline vertical-align="super" font-size="0.75em"><xsl:number from="wlml:main-text|wlml:chapter" level="any" />) </fo:inline>
        <!-- <fo:inline>* </fo:inline> -->
        <fo:footnote-body>      	        
            <fo:block 
            	font-weight="normal" font-style="normal"
            	font-size="{concat($footnote-font-size, 'pt')}" 
            	text-align="justify" text-indent="1.5em" space-after="1em">            	 
            <xsl:number level="any" from="wlml:main-text|wlml:chapter"/>)<fo:character character="&#x2008;" />
            
            <xsl:if test="$annot/wlml:definition">
            <fo:inline letter-spacing="0.1em"><xsl:apply-templates select="$annot/wlml:definition/node()" /></fo:inline>
            <fo:character character="&#8197;" />&#x2014;<fo:character character="&#8197;" />
            </xsl:if>
            
            <xsl:apply-templates select="$annot/wlml:body/node()" />            
            </fo:block>                        
        </fo:footnote-body>        
    </fo:footnote>
</xsl:template>

<xsl:template match="*" />


<xsl:template match="text()">
	<xsl:value-of select="wlf:enchance-for-print(.)" />
</xsl:template>

<xsl:function name="wlf:enchance-for-print">
	<xsl:param name="text" />	
	<xsl:value-of select="wlf:reduce-tokens(wlf:map-text-tokens(tokenize($text, '\s+')))" />	
</xsl:function>

<!--  Some usefull functions -->


<xsl:function name="wlf:map-text-tokens">
    	<xsl:param name="tokens" />
    	<xsl:for-each select="$tokens">
    		<xsl:sequence select='    		
    			replace(
    			replace(
    			replace(
    			replace(
    			replace(current(), 
    				"---", "&#x2014;"),
    				"--", "&#x2013;"),
    				",,", "&#x201E;"),
    				"""", "&#x201D;"),
    				"\.\.+", "&#x2026;") ' />    			
    	</xsl:for-each>    	
    </xsl:function>
    
    <xsl:function name="wlf:reduce-tokens">
    	<xsl:param name="tokens" />    	
    	<xsl:for-each select="0 to count($tokens)">    		
    		<xsl:variable name="cur" select="$tokens[current()]" />
    		<xsl:variable name="next" select="$tokens[current()+1]" />
    		<xsl:choose>
    			<xsl:when test="not($cur)" />
    			<xsl:when test="$next = '&#x2014;'">
    				<xsl:value-of select="concat($cur, '&#8197;')" />   			
    			</xsl:when>
    			<xsl:when test="$cur = '&#x2014;'">    				
    				<xsl:value-of select="concat($cur, '&#8197;')" />   			
    			</xsl:when>
    			<xsl:when test="$next and string-length($cur) = 1">
    				<!--  non breaking space -->
    				<xsl:value-of select="concat($cur, '&#x00a0;')" />
    			</xsl:when>    			    			
    			<xsl:when test="$next">
    				<xsl:value-of select="concat($cur, ' ')" />
    			</xsl:when>    			
    			<xsl:otherwise>
    				<xsl:value-of select="$cur" />
    			</xsl:otherwise>    			
    		</xsl:choose>
    	</xsl:for-each>
    </xsl:function>

</xsl:stylesheet>

