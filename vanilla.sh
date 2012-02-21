#CardsAgainstHumanity has the text encoded as a vector instead of as text.
#Need to convert extract text for cards.vanilla.xml
#just a recording of what I did in term, not what I ran to do the actual conversion

croppdf (){
	#http://stackoverflow.com/questions/6183479/cropping-a-pdf-using-ghostscript-9-01
	#72 pts / in, gs does everthing in points

	local in=$1
	local out=$2
	local l=`printf %d $(($3 * 72))`
	local b=`printf %d $(($4 * 72))`
	local r=`printf %d $(($5 * 72))`
	local t=`printf %d $(($6 * 72))`
	local width=`printf %d $(($7 * 72))`
	local height=`printf %d $(($7 * 72))`

	#gs \
	  #-o $out \
	  #-sDEVICE=pdfwrite \
	  #-dDEVICEWIDTHPOINTS=$width \
	  #-dDEVICEHEIGHTPOINTS=$height \
	  #-dFIXEDMEDIA \
	  #-c "$l $b translate 0 0 $(($width)) $(($height)) rectclip" \
	  #-f $in

	#echo gs \
	  #-o $out \
	  #-sDEVICE=pdfwrite \
	  #-c "[/CropBox [$l $b $r $t] /PAGES pdfmark" \
	  #-f $in

	pdfmanipulate crop -o $out -y $b -x $l -v $r -w $t $in
}

#Split White Cards From Black Cards
rm -f BlackCards{,-nocrop}.p{df,bm} WhiteCards{,-nocrop}.p{df,bm} AllCards.pbm
rm -f card-images/*.pbm
stapler sel CardsAgainstHumanity.pdf 2-24 WhiteCards-nocrop.pdf
stapler sel CardsAgainstHumanity.pdf 25-29 BlackCards-nocrop.pdf

#crop out margins

croppdf WhiteCards-nocrop.pdf WhiteCards.pdf .25 .5 .25 .5 8 10
croppdf BlackCards-nocrop.pdf BlackCards.pdf .25 .5 .25 .5 8 10

#convert to b/w bitmap (pbm format since that's what ocrad supports and they're pretty small since b/w only)
convert -append -density 300x300 WhiteCards.pdf WhiteCards.pbm
convert -append -density 300x300 -negate BlackCards.pdf BlackCards.pbm

#Step 2: run ocr in parts
# pages are 2550x4125 px and 4x5 cards (20 cards per page)
# cards are h=825 w=637
mkdir -p card-images
rm -f White-tess.txt Black-tess.txt
rm -f White-ocrad.txt Black-ocrad.txt

extractpage(){
	local shade=$1
	local page=$2
	local row=$3
	local col=$4

	img="card-images/$shade-$page-$row-$col.pbm"
	echo $img


	local y=$((3000 * $page + 600 * $row + 10))
	local x=$((600 * $col + 10))
	#echo "x=$x,y=$y"

	#page width = 2400
	#page height = 3000
	#card width = 600
	#card height = 600
	#local geo=600x600+${x}+${y}

	local geo=590x480+${x}+${y}
	echo "geo=$geo"
	convert -crop $geo ${shade}Cards.pbm $img
	tesseract $img $img:r-tess
	ocrad $img > $img:r-ocrad.txt

	cat $img:r-tess.txt | tr '\n' ' ' >> $shade-tess.txt
	cat $img:r-ocrad.txt | tr '\n' ' ' >> $shade-ocrad.txt
	echo >> $shade-tess.txt
	echo >> $shade-ocrad.txt
}

for shade in White Black; do
	if [ $shade = 'White' ]; then
		maxpages=22
	elif [ $shade = 'Black' ]; then
		maxpages=4
	else
		echo 'WTF!'
		exit
	fi
	for page in {0..$maxpages}; do
		for row in {0..4}; do
			for col in {0..3}; do
				extractpage $shade $page $row $col
			done
		done
	done
done
