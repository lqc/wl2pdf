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
<xsl:stylesheet
    version="1.0"

    xmlns:wlml="http://nowoczesnapolska.org.pl/ML/Lektury/1.1"

    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:wl="http://wolnelektury.pl/functions" >

    <xsl:template name="layout-masters">

        <fo:layout-master-set>
    <!-- layout information -->
            <fo:simple-page-master
                    master-name="title-page"
                  page-height="29.7cm"
                  page-width="21cm"
                  margin-top="2.5cm"
                  margin-bottom="2.5cm"
                  margin-left="2.5cm"
                  margin-right="2.5cm">
                <fo:region-body />
            </fo:simple-page-master>

            <fo:simple-page-master
                    master-name="blank-page"
                    page-height="29.7cm"
                    page-width="21cm"

                    margin-top="2.5cm"
                    margin-bottom="2.5cm"
                    margin-left="2.5cm"
                    margin-right="2.5cm">
                <fo:region-body />
            </fo:simple-page-master>

            <fo:simple-page-master
        master-name="first-main"
                  page-height="29.7cm"
                  page-width="21cm"
                  margin-top="2cm"
                  margin-bottom="2cm"
                  margin-left="3cm"
                  margin-right="2cm">
                <fo:region-body
                margin-top="2cm"
                margin-bottom="2cm" />
                <fo:region-after
                region-name="odd-after"
                display-align="after"
                extent="2cm" />
            </fo:simple-page-master>

            <fo:simple-page-master
        master-name="odd"
                  page-height="29.7cm"
                  page-width="21cm"
                  margin-top="2cm"
                  margin-bottom="2cm"
                  margin-left="3cm"
                  margin-right="2cm">
                <fo:region-body
                margin-top="2cm"
                margin-bottom="2cm" />

                <fo:region-before
                region-name="odd-before"
                extent="2cm" />

                <fo:region-after
                region-name="odd-after"
                display-align="after"
                extent="2cm" />
            </fo:simple-page-master>

            <fo:simple-page-master
        master-name="even"
                  page-height="29.7cm"
                  page-width="21cm"
                  margin-top="2cm"
                  margin-bottom="2cm"
                  margin-left="2cm"
                  margin-right="3cm">
                <fo:region-body
                margin-top="2cm"
                margin-bottom="2cm" />

                <fo:region-before
                region-name="even-before"
                extent="2cm" />

                <fo:region-after
                region-name="even-after"
                display-align="after"
                extent="2cm" />
            </fo:simple-page-master>


            <fo:page-sequence-master master-name="book-titles">
                <fo:single-page-master-reference master-reference="title-page" />
                <fo:repeatable-page-master-reference master-reference="blank-page" />
            </fo:page-sequence-master>

            <fo:page-sequence-master master-name="main">
                <fo:repeatable-page-master-alternatives>
                    <fo:conditional-page-master-reference
                master-reference="first-main"
                page-position="first"
                odd-or-even="odd" />

                    <fo:conditional-page-master-reference
                master-reference="odd"
                page-position="rest"
                odd-or-even="odd" />

                    <fo:conditional-page-master-reference
                master-reference="even"
                page-position="any"
                odd-or-even="even" />
                </fo:repeatable-page-master-alternatives>

            </fo:page-sequence-master>

        </fo:layout-master-set>
    </xsl:template>
    <!-- end: defines page layout -->


    <xsl:template name="title-page">       

            <fo:flow flow-name="xsl-region-body"
                font-family="DejaVu Serif" text-align="center">

                <fo:block font-size="32pt" display-align="center" >
                    <fo:marker marker-class-name="author">
                        <xsl:value-of select="//wlml:author" />
                    </fo:marker>
                    <xsl:apply-templates select="//wlml:author/node()" mode="title"/>
                </fo:block>

                <fo:block font-size="48pt" display-align="center" >
                    <fo:marker marker-class-name="main-title">
                        <xsl:value-of select="//wlml:title" />
                    </fo:marker>
                    <xsl:apply-templates select="//wlml:title/node()" mode="title"/>
                </fo:block>
            </fo:flow>
        
    </xsl:template>


</xsl:stylesheet>