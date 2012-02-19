
all: cards.pdf

%.pdf: %.fo
	CLASSPATH='/usr/share/java/batik/xml-apis-ext.jar' fop $< $@

cards.fo: cards.xml cards.xsl
	saxon -o:$@ -s:cards.xml -xsl:cards.xsl
	#xsltproc -o $@ cards.xsl cards.xml

clean:
	-rm cards.pdf
	-rm cards.fo
