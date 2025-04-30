<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  version="3.0" >
  <xsl:output method="text"/>
  <xsl:template match="/thesis">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="doc">
    <xsl:apply-templates select="department"/>
  </xsl:template>
  
</xsl:stylesheet>