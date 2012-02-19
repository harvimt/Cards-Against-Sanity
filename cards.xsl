<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" omit-xml-declaration="yes"/>

	<xsl:template match="/cardset">
		<xsl:for-each select="whitecard">
			<xsl:value-of select="text()"/><xsl:text>&#x0A;</xsl:text>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
