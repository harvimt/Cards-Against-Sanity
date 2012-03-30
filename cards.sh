#!/bin/sh

export CLASSPATH='/usr/share/java/batik/xml-apis-ext.jar' #Arch bug

optipdf(){
	unoptimized=$1
	optimized=$2
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$optimized $unoptimized
}

# Convert 
#
xml=$1
xsl=$2
pdf=$3

tmppdf=`mktemp`
tmpfo=`mktemp`

xsltproc --xinclude -o $tmpfo $xsl $xml
fop -fo $tmpfo -pdf $tmppdf
optipdf $tmppdf $pdf

rm $tmppdf
rm $tmpfo
