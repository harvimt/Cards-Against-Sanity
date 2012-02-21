<?xml version="1.0"?>
<!-- vim: set ts=2: -->
<!--
		 identify stylesheet, outputs the input
		 useful because xslt processors will exec xinclude statements before processing the XML
		 (xsltproc needs to be called with xinclude>
-->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
			<xsl:copy-of select="."/> 
	</xsl:template>
</xsl:stylesheet>
