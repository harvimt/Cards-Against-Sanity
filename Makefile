all: acm-expn

acm-expn: cards.acm-expn.final.pdf
patch: cards.patch.final.pdf

XSL=cards-2x2.xsl
CARD_WIDTH=2
CARD_HEIGHT=2
COLUMNS=4
%.fo: %.xml
	xsltproc --param card_height $(CARD_HEIGHT) --param card_width $(CARD_WIDTH) --param columns $(COLUMNS) --xinclude -o $@ $(XSL) $<
	#java -jar /usr/share/java/xalan.jar -IN $< -OUT $@ -XSL $(XSL)

%.fo.pdf: %.fo
	fop -c fop.cfg.xml -fo $< -pdf $@

%.rst.pdf: %.rst
	rst2pdf -o $@ $<

%.joined.pdf: %.fo.pdf %.rst.pdf
	pdftk $< cat output $@
#	stapler cat %< $@

%.final.pdf: %.joined.pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $<

clean:
	rm -f *.pdf *.fo
