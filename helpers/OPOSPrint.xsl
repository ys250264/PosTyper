<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:OAO="http://www.OAO.co.il" xmlns:v="http://www.OAO.co.il">
	<xsl:output method="xml"/>
	<xsl:variable name="size" select="'100'"/>
	<xsl:variable name="output-options" select="'EJ'"/>
	<xsl:variable name="font-percent">
		<xsl:choose>
			<xsl:when test="OPOSPrint/Documents/@Device='HTML'">
				<xsl:value-of select="'40'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'20'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="dir">
		<xsl:choose>
			<xsl:when test="OPOSPrint/Documents/@OutputEncoding='ISO-8859-8'">
				<xsl:value-of select="'rtl'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'ltr'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template match="OPOSPrint/Documents">
		<xsl:element name="html">
			<xsl:attribute name="encoding">utf-8</xsl:attribute>
			<xsl:attribute name="DIR"><xsl:value-of select="$dir"/></xsl:attribute>
			<table cellpadding="0" cellspacing="0" align="center" frame="vsides">
				<xsl:apply-templates select="Document"/>
			</table>
		</xsl:element>
	 </xsl:template>
	<xsl:template match="Document">
		<xsl:for-each select="PrintSection">
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="name(.)='TextObject'">
						<xsl:call-template name="TextObject"/>
					</xsl:when>
					<xsl:when test="name(.)='ImageObject'">
						<xsl:call-template name="ImageObject"/>
					</xsl:when>
					<xsl:when test="name(.)='PrintCommand'">
						<xsl:call-template name="PrintCommand"/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="TextObject" name="TextObject">
		<xsl:apply-templates select="TextLine"/>
	</xsl:template>
	<xsl:template match="TextLine">
		<div>
			<xsl:attribute name="style">text-align:<xsl:value-of select="LinePrintAttributes/@Align"/></xsl:attribute>
		</div>
		<tr>
			<xsl:element name="td">
				<xsl:attribute name="align"><xsl:value-of select="LinePrintAttributes/@Align"/></xsl:attribute>
				<xsl:apply-templates select="Text"/>
			</xsl:element>
		</tr>
	</xsl:template>
	<xsl:template match="Text">
		<xsl:element name="span">
			<xsl:attribute name="style"><xsl:choose><xsl:when test="count(PrintAttributes) > 0"><xsl:apply-templates select="./PrintAttributes " mode="textStyleGenerator"/></xsl:when><xsl:otherwise><xsl:apply-templates select="../LinePrintAttributes" mode="textStyleGenerator"/></xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:choose>
				<xsl:when test="@Text=''">
					<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="replace-to-nbsp">
						<xsl:with-param name="text">
							<xsl:call-template name="replace-string">
								<xsl:with-param name="text" select="@Text"/>
								<xsl:with-param name="from" select="'תתתתששש'"/>
							</xsl:call-template>
						</xsl:with-param>
						<xsl:with-param name="from" select="' '"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:element>
	</xsl:template>
	<xsl:template match="ImageObject" name="ImageObject" xmlns:file="java.io.File">
		<tr>
			<td>
				<xsl:attribute name="align"><xsl:value-of select="@Align"/></xsl:attribute>
				<!--  <span style="position:relative; left:56%; z-index:85; width:30%; height:40%">-->
				<xsl:element name="img">
					<xsl:attribute name="alt"><xsl:value-of select="'Image'"/></xsl:attribute>
					<xsl:attribute name="src"><xsl:value-of select="@FileName"/></xsl:attribute>
					<xsl:if test="@Width">
						<xsl:variable name="pc_width">
							<xsl:value-of select="round((number(@Width) div number($size)) * 100)"/>
						</xsl:variable>
						<!--<xsl:attribute name="width"><xsl:value-of select="number(@Width)  - number($size)"/></xsl:attribute>-->
						<xsl:attribute name="width"><xsl:value-of select="@Width"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="@Height">
						<xsl:attribute name="height"><xsl:value-of select="@Height"/></xsl:attribute>
					</xsl:if>
				</xsl:element>
				<!--</span>-->
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="PrintCommand" name="PrintCommand">
			<xsl:choose>
				<xsl:when test="@Command='FeedPaper'">
					<tr><td align="center">------ Printer FEED command -------</td></tr>
				</xsl:when>
				<xsl:when test="@Command='CutPaper'">
					<tr><td align="center">------- Printer CUT command ---------</td></tr>
				</xsl:when>
			</xsl:choose>
	</xsl:template>
	<xsl:template match="*" mode="textStyleGenerator">
		font-family:Courier New;white-space:per;
		<!--text-align:<xsl:value-of select="@Align"/>;-->
		<xsl:if test="@Bold">font-weight:bold;</xsl:if>
		<xsl:if test="@Italic">font-style:italic;</xsl:if>
		<xsl:if test="@Underline">text-decoration: underline;</xsl:if>
		<xsl:choose>
			<xsl:when test="@Invert='1'">color:FFFFFF;background-color:000000;</xsl:when>
			<xsl:otherwise>color:000000;background-color:FFFFFF;</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@CPL">
			font-size:<xsl:call-template name="get-percent">
				<xsl:with-param name="cpl" select="@CPL"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="replace-to-nbsp">
		<xsl:param name="text"/>
		<xsl:param name="from"/>
		<xsl:choose>
			<xsl:when test="contains($text, $from)">
				<xsl:variable name="before">
					<xsl:choose>
						<xsl:when test="starts-with($text,$from)">
							<xsl:value-of select="''"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before($text,$from)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="after" select="substring-after($text, $from)"/>
				<xsl:value-of select="$before"/>
				<xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
				<xsl:call-template name="replace-to-nbsp">
					<xsl:with-param name="text" select="$after"/>
					<xsl:with-param name="from" select="$from"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="from"/>
		<xsl:choose>
			<xsl:when test="contains($text, $from)">
				<xsl:variable name="before">
					<xsl:choose>
						<xsl:when test="starts-with($text,$from)">
							<xsl:value-of select="''"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="substring-before($text,$from)"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="after" select="substring-after($text, $from)"/>
				<xsl:value-of select="$before"/>
				<xsl:text disable-output-escaping="yes"></xsl:text>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="$after"/>
					<xsl:with-param name="from" select="$from"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="get-percent">
		<xsl:param name="cpl"/>
		<xsl:variable name="a">
			<xsl:value-of select="number($cpl) div number(22)"/>
		</xsl:variable>
		<xsl:variable name="number">
			<xsl:value-of select="round(number($font-percent) div number($a))"/>
		</xsl:variable>
		<xsl:value-of select="concat($number,'pt')"/>
	</xsl:template>
</xsl:stylesheet>
