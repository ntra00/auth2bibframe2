<?xml version='1.0'?>
<xsl:stylesheet version="1.0"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:bf="http://id.loc.gov/ontologies/bibframe/"
                xmlns:bflc="http://id.loc.gov/ontologies/bibframe/lc-extensions/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="xsl marc">

  <!--
      Conversion specs for 001-007
  -->

  <xsl:template match="marc:controlfield[@tag='001']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization= 'rdfxml'">
        <bf:identifiedBy>
          <bf:Local>
            <rdf:value><xsl:value-of select="."/></rdf:value>
          </bf:Local>
        </bf:identifiedBy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='003']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <xsl:when test="$serialization= 'rdfxml'">
        <bf:source>
          <bf:Source>
            <bf:code><xsl:value-of select="."/></bf:code>
          </bf:Source>
        </bf:source>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='005']" mode="adminmetadata">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="changeDate" select="concat(substring(.,1,4),'-',substring(.,5,2),'-',substring(.,7,2),'T',substring(.,9,2),':',substring(.,11,2),':',substring(.,13,2))"/>
    <xsl:choose>
      <xsl:when test="$serialization= 'rdfxml'">
        <bf:changeDate>
          <xsl:attribute name="rdf:datatype"><xsl:value-of select="$xs"/>dateTime</xsl:attribute>
          <xsl:value-of select="$changeDate"/>
        </bf:changeDate>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='007']" mode="work">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:variable name="workType">
      <xsl:choose>
        <xsl:when test="substring(.,1,1) = 'a'">Cartography</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <!-- map -->
      <xsl:when test="substring(.,1,1) = 'a'">
        <xsl:variable name="genreForm">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'">atlas</xsl:when>
            <xsl:when test="substring(.,2,1) = 'g'">diagram</xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'">map</xsl:when>
            <xsl:when test="substring(.,2,1) = 'k'">profile</xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'">model</xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'">remote-sensing image</xsl:when>
            <xsl:when test="substring(.,2,1) = 's'">map section</xsl:when>
            <xsl:when test="substring(.,2,1) = 'y'">map view</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="genreUri">
          <xsl:choose>
            <xsl:when test="substring(.,2,1) = 'd'"><xsl:value-of select="concat($marcgt,'atl')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'j'"><xsl:value-of select="concat($marcgt,'map')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'q'"><xsl:value-of select="concat($marcgt,'mod')"/></xsl:when>
            <xsl:when test="substring(.,2,1) = 'r'"><xsl:value-of select="concat($marcgt,'rem')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContent">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'">one color</xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'">multicolored</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colorContentUri">
          <xsl:choose>
            <xsl:when test="substring(.,4,1) = 'a'"><xsl:value-of select="concat($mcolor,'one')"/></xsl:when>
            <xsl:when test="substring(.,4,1) = 'c'"><xsl:value-of select="concat($mcolor,'mul')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterial">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'">paper</xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'">wood</xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'">stone</xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'">metal</xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'">synthetic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'">skin</xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'">textile</xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'">plastic</xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'">glass</xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'">vinyl</xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'">vellum</xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'">plaster</xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'">leather</xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'">parchment</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="baseMaterialUri">
          <xsl:choose>
            <xsl:when test="substring(.,5,1) = 'a'"><xsl:value-of select="concat($mmatrial,'pap')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'b'"><xsl:value-of select="concat($mmatrial,'wod')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'c'"><xsl:value-of select="concat($mmatrial,'sto')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'd'"><xsl:value-of select="concat($mmatrial,'mtl')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'e'"><xsl:value-of select="concat($mmatrial,'syn')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'f'"><xsl:value-of select="concat($mmatrial,'ski')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'g'"><xsl:value-of select="concat($mmatrial,'tex')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'i'"><xsl:value-of select="concat($mmatrial,'pla')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'j'"><xsl:value-of select="concat($mmatrial,'gls')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'l'"><xsl:value-of select="concat($mmatrial,'vny')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'n'"><xsl:value-of select="concat($mmatrial,'vel')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'p'"><xsl:value-of select="concat($mmatrial,'plt')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'v'"><xsl:value-of select="concat($mmatrial,'lea')"/></xsl:when>
            <xsl:when test="substring(.,5,1) = 'w'"><xsl:value-of select="concat($mmatrial,'par')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="substring(../marc:leader,7,1) != 'e' and substring(../marc:leader,7,1) != 'f'">
              <rdf:type>
                <xsl:attribute name="rdf:resource"><xsl:value-of select="concat($bf,$workType)"/></xsl:attribute>
              </rdf:type>
            </xsl:if>
            <xsl:if test="$genreForm != ''">
              <bf:genreForm>
                <bf:GenreForm>
                  <xsl:if test="$genreUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$genreUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$genreForm"/></rdfs:label>
                </bf:GenreForm>
                </bf:genreForm>
            </xsl:if>
            <xsl:if test="$colorContent != ''">
              <bf:colorContent>
                <bf:ColorContent>
                  <xsl:if test="$colorContentUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$colorContentUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$colorContent"/></rdfs:label>
                </bf:ColorContent>
              </bf:colorContent>
            </xsl:if>
            <xsl:if test="$baseMaterial != ''">
              <bf:baseMaterial>
                <bf:BaseMaterial>
                  <xsl:if test="$baseMaterialUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$baseMaterialUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$baseMaterial"/></rdfs:label>
                </bf:BaseMaterial>
              </bf:baseMaterial>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="marc:controlfield[@tag='007']" mode="instance">
    <xsl:param name="serialization" select="'rdfxml'"/>
    <xsl:choose>
      <!-- map -->
      <xsl:when test="substring(.,1,1) = 'a'">
        <xsl:variable name="generation">
          <xsl:choose>
            <xsl:when test="substring(.,6,1) = 'f'">facsimile</xsl:when>
            <xsl:when test="substring(.,6,1) = 'z'">other type of reproduction</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="generation2">
          <xsl:choose>
            <xsl:when test="substring(.,7,1) = 'a'">photocopy, blueline print</xsl:when>
            <xsl:when test="substring(.,7,1) = 'b'">photocopy</xsl:when>
            <xsl:when test="substring(.,7,1) = 'c'">pre-production</xsl:when>
            <xsl:when test="substring(.,7,1) = 'd'">film</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarity">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'a'">positive</xsl:when>
            <xsl:when test="substring(.,8,1) = 'b'">negative</xsl:when>
            <xsl:when test="substring(.,8,1) = 'm'">mixed polarity</xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="polarityUri">
          <xsl:choose>
            <xsl:when test="substring(.,8,1) = 'a'"><xsl:value-of select="concat($mpolarity,'pos')"/></xsl:when>
            <xsl:when test="substring(.,8,1) = 'b'"><xsl:value-of select="concat($mpolarity,'neg')"/></xsl:when>
            <xsl:when test="substring(.,8,1) = 'm'"><xsl:value-of select="concat($mpolarity,'mix')"/></xsl:when>
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="$serialization = 'rdfxml'">
            <xsl:if test="$generation != ''">
              <bf:generation>
                <bf:Generation>
                  <rdfs:label><xsl:value-of select="$generation"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
            </xsl:if>
            <xsl:if test="$generation2 != ''">
              <bf:generation>
                <bf:Generation>
                  <rdfs:label><xsl:value-of select="$generation2"/></rdfs:label>
                </bf:Generation>
              </bf:generation>
            </xsl:if>
            <xsl:if test="$polarity != ''">
              <bf:polarity>
                <bf:Polarity>
                  <xsl:if test="$polarityUri != ''">
                    <xsl:attribute name="rdf:about"><xsl:value-of select="$polarityUri"/></xsl:attribute>
                  </xsl:if>
                  <rdfs:label><xsl:value-of select="$polarity"/></rdfs:label>
                </bf:Polarity>
              </bf:polarity>
            </xsl:if>
          </xsl:when>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
