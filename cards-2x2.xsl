<?xml version="1.0"?>
<!-- vim: set ts=2 sw=2: -->
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://www.w3.org/2005/xpath-functions"
	xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:str="http://exslt.org/strings"
	version="1.0">
	<xsl:param name="card_width">2</xsl:param>
	<xsl:param name="card_height">2</xsl:param>

	<xsl:param name="page_width">8.5</xsl:param>
	<xsl:param name="page_height">11</xsl:param>
	<xsl:param name="columns">4</xsl:param>

	<xsl:template match="/cards">
		<fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="all-pages">
					<xsl:attribute name="page-width"><xsl:value-of select="$page_width"/></xsl:attribute>
					<xsl:attribute name="page-height"><xsl:value-of select="$page_height"/></xsl:attribute>

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
								<xsl:if test="($i mod $columns) = 1">
									<fo:table-row>
										<xsl:apply-templates select="."/>

										<xsl:call-template name="loop">
											<xsl:with-param name="col">1</xsl:with-param>
											<xsl:with-param name="c"><xsl:value-of select="$c"/></xsl:with-param>
										</xsl:call-template>

									</fo:table-row>
								</xsl:if>
							</xsl:for-each>
						</fo:table-body>
					</fo:table>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<xsl:template name="loop">
		<xsl:param name="col"/>
		<xsl:param name="c"/>

		<xsl:if test="$col &lt; $columns">

			<xsl:if test="count($c[$col]) != 0">
				<xsl:apply-templates select="$c[$col]"/>
			</xsl:if>

			<xsl:call-template name="loop">
				<xsl:with-param name="col"><xsl:value-of select="$col + 1"/></xsl:with-param>
				<xsl:with-param name="c"><xsl:value-of select="$c"/></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="whitecard">
		<fo:table-cell border="1px solid black" padding=".1in" font-family="DejaVu Sans, Arial, sans-serif">
			<xsl:attribute name="width">
				<xsl:value-of select="$card_width"/>
				<xsl:text>in</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="height">
				<xsl:value-of select="$card_height - .2"/>
				<xsl:text>in</xsl:text>
			</xsl:attribute>
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
			<fo:block-container absolute-position="absolute">
					<xsl:attribute name="top">
						<xsl:value-of select="$card_height - .3"/>
						<xsl:text>in</xsl:text>
					</xsl:attribute>
				<fo:block>
					<fo:external-graphic>
						<xsl:attribute name="content-width">
							<xsl:value-of select="$card_width - .2"/>
							<xsl:text>in</xsl:text>
						</xsl:attribute>

						<xsl:attribute name="src">
							<xsl:text>url('footers/</xsl:text>
							<xsl:value-of select="../@name"/>
							<xsl:text>/footer.svg')</xsl:text>
						</xsl:attribute>
					</fo:external-graphic>
				</fo:block>
			</fo:block-container>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="blackcard">
		<fo:table-cell border="1px solid white" padding=".1in" background-color="#231f20" color="white" font-family="DejaVu Sans, Arial, sans-serif">
			<xsl:attribute name="width"> <xsl:value-of select="$card_width"/> <xsl:text>in</xsl:text> </xsl:attribute>
			<xsl:attribute name="height"> <xsl:value-of select="$card_height - .2"/> <xsl:text>in</xsl:text> </xsl:attribute>

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
					<fo:block-container absolute-position="absolute">
						<xsl:attribute name="top">
							<xsl:value-of select="$card_height - .3"/>
							<xsl:text>in</xsl:text>
						</xsl:attribute>
						<fo:block>
							<fo:external-graphic>
								<xsl:attribute name="content-width"> <xsl:value-of select="$card_width - .2"/> <xsl:text>in</xsl:text> </xsl:attribute>
								<xsl:attribute name="src">
									<xsl:text>url('footers/</xsl:text>
									<xsl:value-of select="../@name"/>
									<xsl:text>/blackfooter.svg')</xsl:text>
								</xsl:attribute>
							</fo:external-graphic>
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:when test="$pick = 2">
					<fo:block-container absolute-position="absolute">
						<xsl:attribute name="top">
							<xsl:value-of select="$card_height - .3"/>
							<xsl:text>in</xsl:text>
						</xsl:attribute>
						<fo:block>
							<fo:external-graphic>
								<xsl:attribute name="content-width"> <xsl:value-of select="$card_width - .2"/> <xsl:text>in</xsl:text> </xsl:attribute>
								<xsl:attribute name="src">
									<xsl:text>url('footers/</xsl:text>
									<xsl:value-of select="../@name"/>
									<xsl:text>/blackfooterpick2.svg')</xsl:text>
								</xsl:attribute>
							</fo:external-graphic>
						</fo:block>
					</fo:block-container>
				</xsl:when>
				<xsl:when test="$pick = 3">
					<fo:block-container absolute-position="absolute">
						<xsl:attribute name="top">
							<xsl:value-of select="$card_height - .3"/>
							<xsl:text>in</xsl:text>
						</xsl:attribute>
						<fo:block>
							<fo:external-graphic>
								<xsl:attribute name="content-width"> <xsl:value-of select="$card_width - .2"/> <xsl:text>in</xsl:text> </xsl:attribute>
								<xsl:attribute name="src">
									<xsl:text>url('footers/</xsl:text>
									<xsl:value-of select="../@name"/>
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
		<fo:external-graphic>
			<xsl:attribute name="content-width"> <xsl:value-of select="$card_width - .2"/> <xsl:text>in</xsl:text> </xsl:attribute>
			<xsl:attribute name="content-height"> <xsl:value-of select="$card_height - .4"/> <xsl:text>in</xsl:text> </xsl:attribute>
			<xsl:attribute name="src">
				<xsl:text>url('</xsl:text>
				<xsl:value-of select="@src"/>
				<xsl:text>')</xsl:text>
			</xsl:attribute>
		</fo:external-graphic>
	</xsl:template>

	<xsl:template match="br">
		<fo:block/>
	</xsl:template>

	<xsl:template match="blank">
		<fo:inline text-decoration="underline">
			<xsl:text>&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;</xsl:text>
		</fo:inline>
	</xsl:template>

</xsl:stylesheet>
