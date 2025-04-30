<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  exclude-result-prefixes="xs math"
  version="3.0">
  <xsl:template match="/">
    <oai:OAI-PMH xmlns:oai="http://www.openarchives.org/OAI/2.0/">
      <responseDate xmlns="http://www.openarchives.org/OAI/2.0/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">2025-04-30T02:23:35Z</responseDate>
      <ListRecords>
        <xsl:apply-templates/>
      </ListRecords>
    </oai:OAI-PMH>
  </xsl:template>
  
  <xsl:template match="doc">
    <record>
      <header>
        <identifier><xsl:apply-templates select="uri"/></identifier>
      </header>
      <metadata>
          <thesis xmlns="http://www.ndltd.org/standards/metadata/etdms/1.1/"
            xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:doc="http://www.lyncode.com/xoai"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <title>
              <xsl:apply-templates select="title"/>
            </title>
            <!-- @todo -->
            <creator>
              <xsl:apply-templates select="creators"/>
            </creator>
            <subject>
              <xsl:apply-templates select="keywords"/>
            </subject>
            
            <dc:description role="abstract">
              <xsl:apply-templates select="abstract"/>
            </dc:description>
            <publisher country="Canada">
              <xsl:apply-templates select="institution"/>
            </publisher>
            <!-- @todo -->
            <contributor role="directeur(trice) de recherche/advisor"
              >
              <xsl:apply-templates select="contributors"/>
            </contributor>
            <date>
              <xsl:apply-templates select="date"/>
            </date>
            <type xml:lang="fr">Thèse ou mémoire numérique</type>
            <type xml:lang="en">Electronic Thesis or Dissertation</type>
            <identifier><xsl:apply-templates select="institution"/></identifier>
            <format>application/pdf</format>
            <language xsi:type="dcterms:ISO639-3">eng</language>
            <degree>
              <name>Ph. D.</name>
              <level xml:lang="fr">Doctorat</level>
              <level xml:lang="en">Doctoral</level>
              <discipline xml:lang="fr">
                <xsl:apply-templates select="department"/>
              </discipline>
              <grantor xml:lang="fr">
                <xsl:apply-templates select="institution"/>
              </grantor>
            </degree>
          </thesis>
      </metadata>
    </record>
  </xsl:template>
  
  <xsl:template match="creators">
    <xsl:apply-templates select="_/name/family"></xsl:apply-templates>
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="_/name/given"></xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="contributors">
    <xsl:apply-templates select="_/name/family"></xsl:apply-templates>
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="_/name/given"></xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>