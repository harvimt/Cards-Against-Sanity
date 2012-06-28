<?xml version="1.0"?>
<!-- vim: set ts=2 sw=2: -->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:functx="http://www.functx.com"

	version="1.0">

	<xsl:template match="/cards">
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
							<xsl:for-each select="cardset/whitecard|cardset/blackcard">
								<xsl:variable name="i" select="position() + count(../preceding-sibling::cardset/*)"/>
								<xsl:variable name="c" select="./following-sibling::* | ../following-sibling::cardset/*"/>
								<!--<xsl:message><xsl:value-of select="$i"/></xsl:message>-->
								<xsl:if test="($i mod 4) = 1">
									<fo:table-row>

										<xsl:apply-templates select="."/>

										<xsl:if test="count($c[1]) != 0">
											<xsl:apply-templates select="$c[1]"/>
										</xsl:if>

										<xsl:if test="count($c[2]) != 0">
											<xsl:apply-templates select="$c[2]"/>
										</xsl:if>

										<xsl:if test="count($c[3]) != 0">
											<xsl:apply-templates select="$c[3]"/>
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
			<fo:table-cell border="1px solid black" padding=".1in" width="2in" height="1.8in" font-family="DejaVu Sans, Arial, sans-serif">
			<xsl:attribute name="font-size">
				<xsl:choose>
					<xsl:when test="@font-size">
						<xsl:value-of select="@font-size"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>14pt</xsl:text>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:attribute>

			<fo:block>
				<xsl:apply-templates/>
			</fo:block>

			<fo:block-container absolute-position="absolute" top="1.7in">
				<fo:block>
					<fo:external-graphic content-width="1.8in">
						<xsl:attribute name="src">
							<xsl:text>url('footers/</xsl:text>
							<xsl:value-of select="../@name"/> <!--FIXME escape out single quotes -->
							<xsl:text>/footer.svg')</xsl:text>
					</xsl:attribute>
					</fo:external-graphic>
				</fo:block>
			</fo:block-container>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="blackcard">
			<fo:table-cell border="1px solid white" padding=".1in" width="2in" height="1.8in" background-color="#231f20" color="white"
					font-family="DejaVu Sans, Arial, sans-serif">

			<xsl:attribute name="font-size">
				<xsl:choose>
					<xsl:when test="@font-size">
						<xsl:value-of select="@font-size"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>14pt</xsl:text>
					</xsl:otherwise>
				</xsl:choose>

			</xsl:attribute>

			<fo:block>
				<xsl:apply-templates/>
			</fo:block>

			<xsl:variable name="pick">
				<xsl:choose>
					<xsl:when test="./@pick">
						<xsl:value-of select="./@pick"/>
					</xsl:when>
					<xsl:when test="count(.//blank) &gt; 0">
						<xsl:value-of select="count(.//blank)"/>
					</xsl:when>
					<xsl:otherwise>1</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$pick = 1">
					<fo:block-container absolute-position="absolute" top="1.7in">
						<fo:block>
							<fo:external-graphic content-width="1.8in">
								<xsl:attribute name="src">
									<xsl:text>url('footers/</xsl:text>
									<xsl:value-of select="../@name"/> <!--FIXME escape out single quotes -->
									<xsl:text>/blackfooter.svg')</xsl:text>
							</xsl:attribute>
							</fo:external-graphic>
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:when test="$pick = 2">
					<fo:block-container absolute-position="absolute" top="1.7in">
						<fo:block>
							<fo:external-graphic content-width="1.8in">
								<xsl:attribute name="src">
									<xsl:text>url('footers/</xsl:text>
									<xsl:value-of select="../@name"/> <!--FIXME escape out single quotes -->
									<xsl:text>/blackfooterpick2.svg')</xsl:text>
							</xsl:attribute>
							</fo:external-graphic>
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:when test="$pick = 3">
					<fo:block-container absolute-position="absolute" top="1.40in">
						<fo:block>
							<fo:external-graphic content-width="1.8in">
								<xsl:attribute name="src">
									<xsl:text>url('footers/</xsl:text>
									<xsl:value-of select="../@name"/> <!--FIXME escape out single quotes -->
									<xsl:text>/blackfooterpick3.svg')</xsl:text>
							</xsl:attribute>
							</fo:external-graphic>
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:otherwise>
						<xsl:message>Problem!</xsl:message>
				</xsl:otherwise>
			</xsl:choose>
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

	<xsl:template match="br">
		<fo:block/>
	</xsl:template>

	<xsl:template match="blank">
		<fo:inline text-decoration="underline">
			<xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
		</fo:inline>
	</xsl:template>

</xsl:stylesheet>
