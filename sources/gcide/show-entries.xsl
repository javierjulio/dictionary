<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.w3.org/1999/xhtml" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all">

    <!-- 
        sample template to display in HTML entries from the GCIDE
        when a tag is not defined in the template, it is displayed in red
    -->

    <xsl:output method="xhtml" indent="yes"
        doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
        doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="searchPat">--</xsl:param>
    <xsl:param name="showUnknown" select="false()"/>
    <xsl:param name="nbColsInIndex" select="6"/>
    <xsl:param name="searchProg">search-entries.cgi</xsl:param>
    
    <xsl:key name="ids" match="/entries/entry|/root/entry|/dictionary/body/entries/entry"
        use="@key"/>
    <xsl:variable name="doc" select="/"/>
    <xsl:variable name="charsNotInId"> '</xsl:variable>

    <xsl:template match="/|/dictionary/body">
        <html>
            <head>
                <meta http-equiv="content-type" content="text/html;charset=UTF-8"/>
                <title>Entries of the GCIDE matching <xsl:value-of select="$searchPat"/>
                </title>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>

    <!-- all entries -->
    <xsl:template match="root|entries">
        <xsl:variable name="entries" select="."/>
        <h1><xsl:value-of select="count(entry)"> </xsl:value-of> entries of the GCIDE matching
                    <i><xsl:value-of select="$searchPat"/></i></h1>
        <!-- generate a linked index of all entries at the start and display it as a table -->
        <table>
            <xsl:variable name="values" select="distinct-values(entry/@key)"/>
            <xsl:variable name="nbLines" select="count($values) idiv $nbColsInIndex + 1"/>
            <xsl:for-each-group select="$values"
                group-by="(position()-1) mod $nbLines">
                <tr>
                    <xsl:for-each select="current-group()">
                        <td>
                            <a href="#{generate-id(key('ids',.,$doc)[1])}">
                                <xsl:value-of select="."/>
                                <xsl:variable name="nbEntries" select="count(key('ids',.,$doc))"/>
                                <xsl:if test="$nbEntries>1"> (<xsl:value-of select="$nbEntries"
                                    />)</xsl:if>
                            </a>
                        </td>
                    </xsl:for-each>
                </tr>
            </xsl:for-each-group>
        </table>

        <form id="search" action="{$searchProg}" method="GET">
            <fieldset>
                <legend>Search new entry</legend>
                <input type="text" name="searchPat" size="30"/>
            </fieldset>
        </form>
        <xsl:apply-templates/>
    </xsl:template>

    <!-- one entry -->
    <xsl:template match="entry">
        <span><!-- to get only one root when called separately on each entry -->
            <xsl:variable name="heading-content">
                <xsl:value-of select="@key"/>
                <xsl:if test="pos"> (<i><xsl:value-of select="pos"/></i>) </xsl:if>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test=". is key('ids',@key)[1]">
                    <h2>
                        <a href="#search">
                            <xsl:attribute name="id" select="generate-id(.)"/>
                            <xsl:value-of select="$heading-content"/>
                        </a>
                    </h2>
                </xsl:when>
                <xsl:otherwise>
                    <h3><xsl:value-of select="$heading-content"/></h3>
                </xsl:otherwise>
            </xsl:choose>
            <table cellspacing="0">
                <xsl:for-each select="hw,mhw,wordforms,pluf,vmorph,altsp,ety,pr,fld,syn">
                    <tr>
                        <td valign="top"><b><xsl:value-of select="name(.)"/></b></td>
                        <td valign="top"><xsl:apply-templates/></td>
                    </tr>
                </xsl:for-each>
            </table>
            <xsl:apply-templates select="def"/>
            <xsl:if test="sn">
                <h3>Senses</h3>
                <ol style="list-style-type:decimal">
                    <xsl:apply-templates select="sn"/>
                </ol>
            </xsl:if>
            <xsl:apply-templates select="note"/>
            <xsl:apply-templates select="cs"/>
            <xsl:apply-templates select="usage"/>
        </span>
    </xsl:template>

    <!-- one sense -->
    <xsl:template match="sn">
        <li>
            <xsl:for-each select="node() except sd">
                <xsl:apply-templates select="."/>
            </xsl:for-each>
            <xsl:if test="sd">
                <ol style="list-style-type:lower-alpha">
                    <xsl:apply-templates select="sd"/>
                </ol>
            </xsl:if>
            <xsl:if test="@source">
                <xsl:value-of select="concat(' [',@source,']')"/>
            </xsl:if>
        </li>
    </xsl:template>

    <!-- one subdefinition -->
    <xsl:template match="sd">
        <li>
            <xsl:for-each select="*">
                <xsl:apply-templates select="."/>
                <br/>
            </xsl:for-each>
            <xsl:if test="@source">
                <xsl:value-of select="concat(' [',@source,']')"/>
            </xsl:if>
        </li>
    </xsl:template>

    <!-- collocation table -->
    <xsl:template match="cs">
        <h3>Collocations</h3>
        <dl>
            <xsl:for-each-group select="node()"
                group-starting-with="col|mcol">
                <xsl:variable name="col" select="current-group()[1]"/>
                <dt>
                    <xsl:choose>
                        <xsl:when test="$col[self::mcol]">
                            <xsl:value-of select="$col/col" separator=", "/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$col"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </dt>
                <dd>
                    <xsl:for-each select="current-group()[position()>1]">
                        <xsl:apply-templates select="."/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                </dd>
            </xsl:for-each-group>
        </dl>
    </xsl:template>

    <!-- ignored tags -->
    <xsl:template match="as|cd|conjf|def|person|specif|wf|prod|prodby|part|singf|abbr|see|cp">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- in italics -->
    <xsl:template
        match="qex|qau|au|ets|ex|xex|gen|spn|ant|stype|grk|pluf|ptcl|sig|ecol|tran|
        col|ety|isa|fam|ord|country|city|street|class|phylum|contr|membof|member|uses">
        <xsl:call-template name="wrap">
            <xsl:with-param name="elem">i</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- in bold -->
    <xsl:template match="cref|hw">
        <xsl:call-template name="wrap">
            <xsl:with-param name="elem">b</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    

    <!-- within quotes -->
    <xsl:template match="q">
        <xsl:call-template name="wrap">
            <xsl:with-param name="start-end">«»</xsl:with-param>
        </xsl:call-template>
        <xsl:if test="@au"> [<i><xsl:value-of select="@au"/></i>]</xsl:if>
    </xsl:template>

    <!-- within tt -->
    <xsl:template match="chform|chname|fract|var|exp|mathex">
        <xsl:call-template name="wrap">
            <xsl:with-param name="elem">tt</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- within parentheses -->
    <xsl:template match="rj|wns">
        <xsl:call-template name="wrap">
            <xsl:with-param name="start-end">()</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- italics within brackets -->
    <xsl:template match="fld">
        <xsl:call-template name="wrap">
            <xsl:with-param name="start-end">[]</xsl:with-param>
            <xsl:with-param name="elem">i</xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- italic within parentheses -->
    <xsl:template match="mark|pos">
        <xsl:call-template name="wrap">
            <xsl:with-param name="start-end">()</xsl:with-param>
            <xsl:with-param name="elem">i</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- in italics preceded by a short label -->
    <xsl:template match="pr">
        <xsl:call-template name="wrap">
            <xsl:with-param name="start"> pr: </xsl:with-param>
            <xsl:with-param name="end"/>
            <xsl:with-param name="elem">i</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="altsp">
        <xsl:call-template name="wrap">
            <xsl:with-param name="start"> Alt. spell.: </xsl:with-param>
            <xsl:with-param name="end"/>
            <xsl:with-param name="elem">i</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="syn">
        <xsl:call-template name="wrap">
            <xsl:with-param name="start"> Syn: </xsl:with-param>
            <xsl:with-param name="end"/>
            <xsl:with-param name="elem">i</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <!-- labeled paragraph -->
    <xsl:template match="note">
        <p> <b> <xsl:text> Note: </xsl:text> </b> <xsl:apply-templates/> </p>
    </xsl:template>

    <xsl:template match="usage">
        <p> <b> <xsl:text> Usage: </xsl:text> </b> <xsl:apply-templates/> </p>
    </xsl:template>
    
    <!-- entry reference: link to id in the current file if it exists otherwise make a search -->
    <xsl:template match="er|altname">
        <xsl:call-template name="make-link"/>
        <xsl:if test="name(following-sibling::node()[1])=name(.)">, </xsl:if>
    </xsl:template>

    <!-- ignore the tag by output its contents separated by ; -->
    <xsl:template match="mcol|vmorph">
        <xsl:for-each select="*">
            <xsl:apply-templates select="."/>
            <xsl:if test="position()&lt;last()">; </xsl:if>
        </xsl:for-each>    
    </xsl:template>
    
    <!-- show consecutive alternate spellings or names followed by a , -->
    <xsl:template match="asp">
        <xsl:value-of select="."/>
        <xsl:if test="name(following-sibling::node()[1])=name(.)">, </xsl:if>
    </xsl:template>
    
    <!-- catch all template -->

    <xsl:template match="*">
        <xsl:if test="$showUnknown">
            <xsl:message><xsl:value-of select="name(.)"/></xsl:message>
        </xsl:if>
        <span style="color:red">
            <xsl:call-template name="wrap">
                <xsl:with-param name="start">&lt;<xsl:value-of select="name(.)"/>&gt;</xsl:with-param>
                <xsl:with-param name="end">&lt;/<xsl:value-of select="name(.)"/>&gt;</xsl:with-param>
            </xsl:call-template>
        </span>
    </xsl:template>

    <!-- template to embed a content within text and formatting -->
    <xsl:template name="wrap">
        <xsl:param name="start-end"/>
        <xsl:param name="start" select="substring($start-end,1,1)"/>
        <xsl:param name="end" select="substring($start-end,2,1)"/>
        <xsl:param name="elem"/>
        <xsl:value-of select="$start"/>
        <xsl:choose>
            <xsl:when test="$elem">
                <xsl:element name="{$elem}">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$end"/>
    </xsl:template>
    
    <!--  template to create a link either to this page (if it is defined otherwise call the
    server...) -->
    
    <xsl:template name="make-link">
        <xsl:variable name="newkey" select="."/>
        <xsl:variable name="newId" select="generate-id(key('ids',$newkey,$doc)[1])"/>
        <a href="{if (string-length($newId)>0) then concat('#',$newId)
                     else concat($searchProg,'?searchPat=',encode-for-uri($newkey))}">
            <xsl:value-of select="$newkey"/>
        </a>
    </xsl:template>
</xsl:stylesheet>
