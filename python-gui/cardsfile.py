from lxml import etree

class CardsFile(object):
	def __init__(self, filename=None):
		self.filename = filename
		self.whitecards = []
		self.blackcards = []
		if filename is not None:
			self.importXML(filename)

	def exportToFo(self, fo_file):
		"""
		export the card file to XSL-FO format
		fo_file -- a filename or file-like object to write to.
		"""
		self.save()

		result = lxml
		if type(fo_file) is str:
			fo_file = open(fo_file, 'w')
		try:
			
		finally:
			fo_file.close()

	def importFromXML(self, xml_file):
		self.whitecards = []
		self.blackcards = []
		tree = etree.parse(xml_file)
		for tag in tree.findall('/cardset/whitecard'):
			self.whitecards.append(tag.text)

		for tag in tree.findall('/cardset/blackcard'):
			pick = tag.get('pick') or 'auto'
			self.blackcards.append( {'pick':pick, 'text':tag.text})

	def makeTree(self):
		self.tree = etree.Element('cardset')
		for whitecard in self.whitecards:
			tag = etree.Element('whitecard')
			tag.text = whitecard
			self.tree.append(tag)

		for blackcard in self.blackcards:
			tag = etree.Element('blackcard')
			tag.text = blackcard['text']
			if blackcard['pick'] != 'auto':
				tag.set('pick', blackcard['pick'])
			self.tree.append(tag)

	def save(self):
		self.exportToXML(self.filename)

	def exportToXML(self, xml_file):
		self.makeTree()
		if type(xml_file) is str:
			xml_file = open(xml_file,'w')
		try:
			xml_file.write( etree.tostring(self.tree))
		finally:
			xml_file.close()
