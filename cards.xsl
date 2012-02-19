<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	>

	<xsl:template match="/cardset">

		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

			<fo:layout-master-set>
				<fo:simple-page-master master-name="all-pages" page-width="8.5in" page-height="11in">
					<fo:region-body margin=".5in .25in" column-count="4" column-gap="0in"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="my-sequence">
					<fo:repeatable-page-master-reference master-reference="all-pages"/>
				</fo:page-sequence-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="my-sequence">
				<fo:flow flow-name="xsl-region-body">
						<xsl:apply-templates/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="whitecard">
		<fo:block-container width="2in" height="2in" float="before">
			<fo:block-container width="100%" height="100%" padding=".1in">
				<fo:block><xsl:value-of select="text()"/></fo:block>
				<fo:block-container absolute-position="absolute" top="1.6in">
					<fo:block><fo:external-graphic src="url('footer.svg')"/></fo:block>
				</fo:block-container>
			</fo:block-container>
		</fo:block-container>
	</xsl:template>

</xsl:stylesheet>
<!--ts=2-->
