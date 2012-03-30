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
cover=$3

tmppdf=`mktemp`
tmppdf2=`mktemp`
#covertex=`mktemp`
coverpdf=`mktemp`
tmpfo=`mktemp`

xsltproc --xinclude -o $tmpfo $xsl $xml
fop -fo $tmpfo -pdf $tmppdf
rst2pdf $cover -o $coverpdf
stapler cat $coverpdf $tmpdf $tmppdf2
optipdf $tmppdf2 $pdf

rm $tmppdf
rm $tmppdf2
rm $coverpdf
rm $covertex
rm $tmpfo
