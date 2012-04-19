#!/bin/sh

export CLASSPATH='/usr/share/java/batik/xml-apis-ext.jar' #Arch bug

optipdf(){
	unoptimized=$1
	optimized=$2
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$optimized $unoptimized &>/dev/null
	return $?
}

# Convert 
#
xml=$1
xsl=$2
pdf=$3
cover=$4

tmppdf=`mktemp --suffix=.pdf`
tmppdf2=`mktemp --suffix=.pdf`
coverpdf=`mktemp --suffix=.pdf`
coverpdf2=`mktemp --suffix=.pdf`
tmpfo=`mktemp --suffix=.fo`

#echo "tmppdf=$tmppdf"
#echo "tmppdf2=$tmppdf2"
#echo "coverpdf=$coverpdf"
#echo "coverpdf2=$coverpdf2"

echo 'Running XSLTProc'
xsltproc --xinclude -o $tmpfo $xsl $xml &>/dev/null || { echo 'xsltproc failed'; exit 1; }

echo 'Running FOP'
fop -fo $tmpfo -pdf $tmppdf &>/dev/null || { echo 'fop failed'; exit 1; }

echo 'Running RST2PDF'
rst2pdf -o $coverpdf $cover &>/dev/null || { echo 'rst2pdf'; exit 1; }

#echo 'Running optipdf (1)'
#optipdf $coverpdf $coverpdf2 || { echo 'optipdf (1) failed'; exit 1; }

echo 'Running pdftk/stapler'
#rm $tmppdf2 #stapler doesn't like its files to exist
rm $tmppdf2 #stapler doesn't like its files to exist
stapler cat $coverpdf $tmppdf $tmppdf2 &>/dev/null || { echo 'stapler failed'; exit 1; }
#pdftk $coverpdf $tmppdf cat output $tmppdf2

echo 'Running optipdf (2)'
optipdf $tmppdf2 $pdf || { echo 'optipdf (2) failed'; exit 1; }

rm $tmppdf
rm $tmppdf2
rm $coverpdf
rm $tmpfo
