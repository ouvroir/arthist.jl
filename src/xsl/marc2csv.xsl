<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:marc="http://www.loc.gov/MARC21/slim"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:csv="http://example.com/csv"
  xpath-default-namespace="http://www.loc.gov/MARC21/slim"
  version="3.0" >
  <!-- 
    This xslt use intitial template and package
    
    Avec le processeur Saxon, passer le paramètre `-it` avec la valeur `{http://www.w3.org/1999/XSL/Transform}initial-template`
    Dans les paramètres de transformation d’Oxygen renseigner la variable `-it` avec `{http://www.w3.org/1999/XSL/Transform}initial-template`
    Ou bien de remplacer la déclaration `xsl:initial-template` par le QName directement dans la XSLT.
    
    En ligne de commande avec Saxon, il faut passer les options `-it -xsl:marc2csv.xsl -lib:csvPackage.xsl` ou fournir un fichier de configuration avec `-config:config.xml`.
    Sur Oxygen, on peut configurer un fichier de configuration dans les options de la transformation.
  -->
  
  <!-- 
  001 : no OCLC de la notice, permet de construire un lien vers la notice Sofia, en ajoutant « https://umontreal.on.worldcat.org/oclc/ » devant le numéro
100 : Autrice ou auteur de la thèse (surtout $a pour le nom)
245 : Titre (surtout $a $b)
260$c ou 264$c : Date du document
300 : Description matérielle (information sur le format, en plus de la zone 533 pour les informations sur les microformes)
500 : Notes (dont la note indiquant le département et le fait que ça soit une thèse ou un mémoire).
                Les notes en 599 sont souvent des doublons locaux pour les notes en 500 ou autre zone de notes variées
502 : Note de thèse (grade, Université, année)
520 : Résumé
6XX : Sujets ; Mots-clés (653) ou vedettes-matière (notamment 600, 610, 650, 651)
700 : Direction de recherche (surtout $a pour le nom)
852 : Emplacement sur les rayons (succursale, emplacement, cote) - avec les sigles des bibliothèques, notamment MUQA pour BLSH et SCON pour le centre de conservation Lionel-Groulx
856 : URL (en $u) – pour Papyrus ou BAC pour la copie conservée par Thèses Canada
 
  -->
  <xsl:use-package name="http://example.com/csv-parser" package-version="*"/>
  
  <xsl:output indent="yes"/>
  
  <xsl:variable name="doc" select="doc('../data/udem-bib2025-03.xml')"/>
  
  <!-- entry point -->
  <xsl:template name="xsl:initial-template">
    <csv>
      <xsl:apply-templates select="$doc/collection/record"/>
    </csv>
  </xsl:template>
  
  <xsl:template match="record">
    <row>
      <xsl:apply-templates select="controlfield[@tag='001']"/>
      <xsl:apply-templates select="datafield[@tag='100']/subfield[@code='a']"/>
      <xsl:apply-templates select="datafield[@tag='100']/subfield[@code='1']"/>
      <xsl:apply-templates select="datafield[@tag='245']"/>
      <xsl:apply-templates select="datafield[@tag='502']/subfield[@code='c']"/>
      <xsl:apply-templates select="datafield[@tag='502']/subfield[@code='b']"/>
      <xsl:apply-templates select="datafield[@tag='502']/subfield[@code='d']"/>
      <supervisor>
        <xsl:call-template name="getSupervisor">
          <xsl:with-param name="data" select="datafield[@tag='700']"/>
        </xsl:call-template>
      </supervisor>
      <url>
        <xsl:call-template name="getLinks">
          <xsl:with-param name="data" select="datafield[@tag='856']"/>
        </xsl:call-template>
      </url>
    </row>
  </xsl:template>
  
  <xsl:template name="getLinks">
    <xsl:param name="data"/>
    <xsl:value-of select="string-join($data/subfield[@code='a'],' ; ')"/>
  </xsl:template>
  <xsl:template name="getSupervisor">
    <xsl:param name="data"/>
    <xsl:value-of select="string-join($data/subfield[@code='u'],'; ')"/>
  </xsl:template>
  
  <xsl:template match="controlfield[@tag='001']">
    <oclc><xsl:apply-templates/></oclc>
  </xsl:template>
  
  <xsl:template match="datafield[@tag='100']/subfield[@code='a']">
    <author><xsl:apply-templates/></author>
  </xsl:template>
  
  <xsl:template match="datafield[@tag='100']/subfield[@code='1']">
    <orcid><xsl:apply-templates/></orcid>
  </xsl:template>
  
  <xsl:template match="datafield[@tag='245']">
    <title>
      <xsl:apply-templates select="subfield[@code='a']"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="subfield[@code='b']"/>
    </title>
  </xsl:template>
  
  <xsl:template match="datafield[@tag='502']/subfield[@code='c']">
    <university><xsl:apply-templates/></university>
  </xsl:template>
  
  <xsl:template match="datafield[@tag='502']/subfield[@code='b']">
    <type><xsl:apply-templates/></type>
  </xsl:template>
  
  <xsl:template match="datafield[@tag='502']/subfield[@code='d']">
    <date><xsl:apply-templates/></date>
  </xsl:template>
  
</xsl:stylesheet>