#!/bin/zsh
#Converts White.txt & Black.txt to CAH XML Format (cards.vanilla.txt)
#blacks will all be given pick="1" this will need to be fixed.
{
	echo '<?xml version="1.0" encoding="utf-8"?>';
	echo '<!-- Vanilla Cards Against Humanity -->';
	echo '<cardset>';
	< White.txt | xml2asc | sed 's/.*/\t<whitecard>&<\/whitecard>/';
	< Black.txt | xml2asc | sed 's/_\+/________/g;s/.*/\t<blackcard pick="1">&<\/blackcard>/';
	echo '</cardset>';
} > cards.vanilla.xml
