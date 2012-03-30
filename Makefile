all: acm-expn patch


acm-expn:
	sh cards.sh cards.acm-expn.xml cards-2x3.xsl cards.acm-expn.pdf acm-expn.rst

patch:
	sh cards.sh cards.patch.xml cards-2x3.xsl cards.patch.pdf patch.rst

upload:
	scp cards.acm-expn.pdf harvimt@chandra:public_html/cards.pdf
	scp cards.patch.pdf harvimt@chandra:public_html/cards.patch.pdf
