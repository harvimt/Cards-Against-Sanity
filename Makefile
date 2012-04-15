all: acm-expn

acm-expn: cards.acm-expn.final.pdf
patch: cards.patch.final.pdf

XSL=cards-2x2.xsl
%.fo: %.xml
	xsltproc --xinclude -o $@ $(XSL) $<
	#java -jar /usr/share/java/xalan.jar -IN $< -OUT $@ -XSL $(XSL)


%.fo.pdf: %.fo
	fop -fo $< -pdf $@

%.rst.pdf: %.rst
	rst2pdf -o $@ $<

%.joined.pdf: %.fo.pdf %.rst.pdf
	pdftk $< cat output $@
#	stapler cat %< $@

%.final.pdf: %.joined.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $<

clean:
	rm -f *.pdf *.fo
