<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bflc/"
                xmlns:madsrdf="http://www.loc.gov/mads/rdf/v1#"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!-- Conversion specs for 490, and 510 - Other linking entries -->

  <xsl:template match="marc:datafield[@tag='490']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vCurrentPos">
      <xsl:choose>
        <xsl:when test="@ind1 = '1'">
          <xsl:value-of select="count(preceding-sibling::marc:datafield[@tag='490' and @ind1='1']) + 1"/>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:apply-templates select="." mode="work490">
      <xsl:with-param name="serialization" select="$serialization"/>
      <xsl:with-param name="pCurrentPos" select="$vCurrentPos"/>
    </xsl:apply-templates>
  </xsl:template>
    
  <xsl:template match="marc:datafield[@tag='490' or @tag='880']" mode="work490">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:param name="pCurrentPos"/>
    <xsl:if test="@ind1=0 or @tag='880' or
                  (@ind1='1' and count(../marc:datafield[@tag='800' or @tag='810' or @tag='811' or @tag='830']) &lt; $pCurrentPos)">
      <xsl:for-each select="marc:subfield[@code='x']">
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <bf:hasSeries>
              <bf:Work>
                <bf:identifiedBy>
                  <bf:Issn>
                    <rdf:value>
                      <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                      </xsl:call-template>
                    </rdf:value>
                  </bf:Issn>
                </bf:identifiedBy>
              </bf:Work>
            </bf:hasSeries>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="marc:datafield[@tag='510']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="work510">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='510' or @tag='880']" mode="work510">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:variable name="vProperty">
      <xsl:choose>
        <xsl:when test="@ind1='0' or @ind1='1' or @ind1='2'">bflc:indexedIn</xsl:when>
        <xsl:otherwise>bf:references</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$serialization = 'rdfxml'">
        <xsl:element name="{$vProperty}">
          <bf:Work>
            <xsl:for-each select="marc:subfield[@code='a']">
              <bf:title>
                <bf:Title>
                  <bf:mainTitle>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </bf:mainTitle>
                </bf:Title>
              </bf:title>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='b' or @code='c']">
              <bf:note>
                <bf:Note>
                  <bf:noteType>
                    <xsl:choose>
                      <xsl:when test="@code='b'">Coverage</xsl:when>
                      <xsl:when test="@code='c'">Location</xsl:when>
                    </xsl:choose>
                  </bf:noteType>
                  <rdfs:label>
                    <xsl:if test="$vXmlLang != ''">
                      <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdfs:label>
                </bf:Note>
              </bf:note>
            </xsl:for-each>
            <xsl:for-each select="marc:subfield[@code='x']">
              <bf:identifiedBy>
                <bf:Issn>
                  <rdf:value>
                    <xsl:call-template name="chopPunctuation">
                      <xsl:with-param name="chopString" select="."/>
                      <xsl:with-param name="punctuation"><xsl:text>:,;/ </xsl:text></xsl:with-param>
                    </xsl:call-template>
                  </rdf:value>
                </bf:Issn>
              </bf:identifiedBy>
            </xsl:for-each>
          </bf:Work>
        </xsl:element>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:datafield[@tag='490']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:apply-templates select="." mode="instance490">
      <xsl:with-param name="serialization" select="$serialization"/>
    </xsl:apply-templates>
  </xsl:template>
    
  <xsl:template match="marc:datafield[@tag='490' or @tag='880']" mode="instance490">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="vXmlLang"><xsl:apply-templates select="." mode="xmllang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="count(marc:subfield[@code='a']) &gt; 1 and
        (substring(marc:subfield[@code='a'][1],string-length(marc:subfield[@code='a'][1])) = '=' or
        substring(marc:subfield[@code='v'][1],string-length(marc:subfield[@code='v'][1])) = '=')">
        <!-- parallel titles -->
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
          <xsl:variable name="vStatement">
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="."/>
              <xsl:with-param name="punctuation"><xsl:text>= </xsl:text></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:variable name="vIssn">
            <xsl:apply-templates mode="concat-nodes-space" select="../marc:subfield[@code='x']"/>
          </xsl:variable>
          <xsl:variable name="vVolume">
            <xsl:call-template name="chopPunctuation">
              <xsl:with-param name="chopString" select="following-sibling::marc:subfield[@code='v' and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode]"/>
              <xsl:with-param name="punctuation"><xsl:text>= </xsl:text></xsl:with-param>
            </xsl:call-template>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization = 'rdfxml'">
              <bf:seriesStatement>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="normalize-space(concat($vStatement,' ',$vIssn,' ',$vVolume))"/>
                  <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </bf:seriesStatement>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="marc:subfield[@code='a']">
          <xsl:variable name="vCurrentNode" select="generate-id(.)"/>
          <xsl:variable name="vStatement">
            <xsl:apply-templates mode="concat-nodes-space" select=".|following-sibling::marc:subfield[(@code='x' or @code='v') and generate-id(preceding-sibling::marc:subfield[@code='a'][1])=$vCurrentNode]"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="$serialization = 'rdfxml'">
              <bf:seriesStatement>
                <xsl:if test="$vXmlLang != ''">
                  <xsl:attribute name="xml:lang"><xsl:value-of select="$vXmlLang"/></xsl:attribute>
                </xsl:if>
                <xsl:call-template name="chopPunctuation">
                  <xsl:with-param name="chopString" select="$vStatement"/>
                  <xsl:with-param name="punctuation"><xsl:text>=:,;/ </xsl:text></xsl:with-param>
                </xsl:call-template>
              </bf:seriesStatement>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
