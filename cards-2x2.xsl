<?xml version="1.0"?>
<!-- vim: set ts=2:sw=2: -->
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	>

	<xsl:template match="/cardset">

		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">

			<fo:layout-master-set>
				<fo:simple-page-master master-name="all-pages" page-width="8.5in" page-height="11in">
					<fo:region-body margin=".25in .25in" column-gap="0in"/>
				</fo:simple-page-master>
				<fo:page-sequence-master master-name="my-sequence">
					<fo:repeatable-page-master-reference master-reference="all-pages"/>
				</fo:page-sequence-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="my-sequence">
				<fo:flow flow-name="xsl-region-body" font-weight="bold">
						<fo:table>
								<fo:table-body>
								<xsl:for-each select="whitecard|blackcard">
										<xsl:if test="position() mod 4 = 1">
												<fo:table-row>
														<xsl:apply-templates select="."/>
														
														<xsl:if test="count(./following-sibling::*[position()=1]) != 0">
																<xsl:apply-templates select="./following-sibling::*[position()=1]"/>
														</xsl:if>

														<xsl:if test="count(./following-sibling::*[position()=2]) != 0">
																<xsl:apply-templates select="./following-sibling::*[position()=2]"/>
														</xsl:if>

														<xsl:if test="count(./following-sibling::*[position()=3]) != 0">
																<xsl:apply-templates select="./following-sibling::*[position()=3]"/>
														</xsl:if>
												</fo:table-row>
										</xsl:if>
								</xsl:for-each>
								</fo:table-body>
						</fo:table>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template match="whitecard">
			<fo:table-cell border="solid black" padding=".1in" width="2in" height="1.8in">

				<fo:block><xsl:apply-templates/></fo:block>

				<fo:block-container absolute-position="absolute" top="1.6in">
					<fo:block><fo:external-graphic src="url('footer.svg')"/></fo:block>
			</fo:block-container>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="blackcard[@pick=1]">
			<fo:table-cell border="solid white" padding=".1in" width="2in" height="1.8in" background-color="#231f20" color="white">

				<fo:block><xsl:value-of select="text()"/></fo:block>

				<fo:block-container absolute-position="absolute" top="1.6in">
					<fo:block><fo:external-graphic src="url('blackfooter.svg')"/></fo:block>
			</fo:block-container>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="blackcard[@pick=2]">
			<fo:table-cell border="solid white" padding=".1in" width="2in" height="1.8in" background-color="#231f20" color="white">

				<fo:block><xsl:value-of select="text()"/></fo:block>

				<fo:block-container absolute-position="absolute" top="1.6in">
					<fo:block><fo:external-graphic content-width="1.8in" src="url('blackfooterpick2.svg')"/></fo:block>
			</fo:block-container>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="blackcard[@pick=3]">
			<fo:table-cell border="solid white" padding=".1in" width="2in" height="1.8in" background-color="#231f20" color="white">

				<fo:block><xsl:value-of select="text()"/></fo:block>

				<fo:block-container absolute-position="absolute" top="1.35in">
					<fo:block><fo:external-graphic content-width="1.8in" src="url('blackfooterpick3.svg')"/></fo:block>
			</fo:block-container>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>

	<xsl:template match="img">
		<fo:external-graphic content-width="1.8in" content-height="1.6in">
			<xsl:attribute name="src">
				<xsl:text>url('</xsl:text>
				<xsl:value-of select="@src"/> <!--FIXME escape out single quotes -->
				<xsl:text>')</xsl:text>
			</xsl:attribute>
		</fo:external-graphic>
	</xsl:template>

</xsl:stylesheet>
