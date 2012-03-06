Cards Against Sanity
====================

A `Cards Against Humanity <http://cardsagainsthumanity.com>`_ fan made expansion and card generator.

Cards can be generated in either 2in by 3in cards at 12 cards per 8.5x11in sheet or 2x2in cards with 20 cards per sheet.

Required Dependencies
---------------------
* An `XSLT <https://en.wikipedia.org/wiki/XSLT>`_ 1.0 Processor
* An `XSL-FO <https://en.wikipedia.org/wiki/XSL_Formatting_Objects>`_ processor


Recommended Dependencies
------------------------
* `xsltproc <https://xmlgraphics.apache.org/fop/>`_ (xslt processor)
* `Apache FOP <https://xmlgraphics.apache.org/fop/>`_ (for XSL-FO processing)
* bourne compatible shell script (bash, dash, zsh)
* make
* ghostscript to optimize PDF files

.. note:: xsltproc is used instead of fop's builtin xslt processor because I couldn't get xinclude to work with fop.

Usage
-----

1. Download or clone the repository
2. cd into that directory
3. Run `make` to create 2x3 cards in cards-2x3.pdf or `make 2x2` to output 2x2 in cards to cards-2x2.pdf

Advanced Usage
--------------

You can run cards.sh manually instead of through make to change the output pdf and input cards xml file and which transformation (2x2 or 2x3) to use.

To add new cards create a new cards-*name of set*.xml, optionally add that file name to cards.xml in an xinclude (similar to the others in that file. run cards.sh or make to produce a new PDF.

Vanilla Text Extractor
----------------------
vanilla.sh contains code to extract the text from the CardsAgainstHumanity.pdf with OCR. This file segments the cards into seperate bitmaps (1 per file) then runs OCR on each file. This file will remain undocumented except internally unless there is demand.

Todo
----
* Create XML schema to validate cards
* Createa GUI or maybe a web front-end to add new cards
