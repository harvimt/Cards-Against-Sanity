#!/usr/bin/python2
# coding=utf-8
# NOTE: THIS PYTHON SOURCE FILE USES TABS DEAL WITH IT
#
# ⓒ 2012, Mark Harviston
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# Neither the name of the <ORGANIZATION> nor the names of its
# contributors may be used to endorse or promote products derived
# from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
# USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
# THE POSSIBILITY OF SUCH DAMAGE.

"""
A CardsFile class, describing a Cards Against Humanity class file

*** I REPEAT THIS PYTHON SOURCE FILE USES TABS, DEAL WITH IT ***
"""
from collections import namedtuple
import re
from lxml import etree

# white cards are just strings, black cards consist of "pick" either 1,2,3 or "auto" and text
# text may contain any number of underscores (preferably 8) to count for blank
BlackCard = namedtuple('BlackCard', ('pick', 'text') )

class CardsFile(object):
	def __init__(self, filename=None):
		"""
		filename (optional) -- the filename to save the file to (can change, unneccessary)
		"""
		self.filename = filename
		self.whitecards = [] # list of strings
		self.blackcards = [] # list of BlackCard
		if filename is not None:
			self.importXML(filename)

	def exportToFO(self, fo_file, xslt_file=None):
		"""
		export the card file to XSL-FO format

		fo_file -- a filename or file-like object to write to.
		xslt_file (optional) -- a filename or file-like object pointing to the XSLT file to use for transformations, by default uses cards-2x2.xsl
		"""
		self.makeTree()

		if xslt_file is None:
			xslt_file = '../cards-2x2.xsl' #FIXME, don't hard-code file paths

		xslt_tree = etree.XSLT(etree.parse(xslt_file))
		trans_tree = xslt_tree(self.tree)

		if type(fo_file) is str:
			fo_file = open(fo_file, 'w')

		try:
			fo_file.write( etree.tostring(trans_tree) )
		finally:
			fo_file.close()

	def importXML(self, xml_file):
		"""
		import an xml file from `xml_file` and parse the results to `self.whitecards` and `self.blackcards`
		the xml tree is not saved in self.tree

		xml_file -- a filename or file-like object to read XML data from
		"""
		self.whitecards = []
		self.blackcards = []
		tree = etree.parse(xml_file)
		for tag in tree.findall('/whitecard'):
			self.whitecards.append(tag.text)

		for tag in tree.findall('/blackcard'):
			pick = tag.get('pick') or 'auto'
			text = tag.text or ''
			for blank_tag in tag.findall('blank'):
				text += 8 * '_'
				text += blank_tag.tail

			self.blackcards.append( BlackCard(pick, text) )

	def makeTree(self):
		"""
		convert `self.whitecards` and `self.blackcards` to an XML tree and store that tree at `self.tree`
		"""
		self.tree = etree.Element('cardset')
		for whitecard in self.whitecards:
			tag = etree.Element('whitecard')
			tag.text = whitecard
			self.tree.append(tag)

		for blackcard in self.blackcards:
			tag = etree.Element('blackcard')
			#tag.text = blackcard.text #TODO turn underscores into <blank/>
			segments = re.split('_+', blackcard.text)

			tag.text = segments[0]

			for segment in segments[1:]:
				blank_tag = etree.Element('blank')
				blank_tag.tail = segment
				tag.append(blank_tag)

			if blackcard.pick != 'auto':
				tag.set('pick', blackcard.pick)

			self.tree.append(tag)

	def save(self):
		""" Save the file to self.filename"""
		self.exportXML(self.filename)

	def exportXML(self, xml_file):
		"""
		use `self.makeTree` to make the tree
		xml_file -- filename or file like object to write xml data to
		"""
		self.makeTree()
		if type(xml_file) is str:
			xml_file = open(xml_file,'w')
		try:
			xml_file.write( etree.tostring(self.tree))
		finally:
			xml_file.close()
