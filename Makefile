all: acm-expn patch

acm-expn:
	sh cards.sh cards.acm-expn.xml cards-2x3.xsl cards.acm-expn.pdf acm-expn.rst

patch:
	sh cards.sh cards.patch.xml cards-2x3.xsl cards-patch.pdf patch.rst
