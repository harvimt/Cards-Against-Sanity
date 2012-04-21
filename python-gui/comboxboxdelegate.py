from PySide.QtCore import *
from PySide.QtGui import *

class ComboBoxDelegate(QStyledItemDelegate):

	def __init__(self, model, parent=None):
		super(type(self), self).__init__(parent)
		self.parent= parent
		self.model= model

	def createEditor(self, parent, option, index):

		if not index.isValid():
			return False

		self.currentIndex=index

		self.comboBox = QComboBox(parent)
		self.comboBox.setModel(self.model)
		value = index.data(Qt.DisplayRole)
		self.comboBox.setCurrentIndex(value)

		return self.comboBox

	def setEditorData(self, editor, index):
		value = index.data(Qt.DisplayRole)
		editor.setCurrentIndex(value)

	def setModelData(self, editor, model, index):

		if not index.isValid():
			return False

		index.model().setData(index, editor.currentIndex(), Qt.EditRole)

	def paint(self, painter, option, index):
		currentIndex= index.data(Qt.DisplayRole)

		opt = QStyleOptionComboBox()
		opt.rect = option.rect
		currentComboIndex = self.model.createIndex(currentIndex,0)
		opt.currentText = self.model.data(currentComboIndex, Qt.DisplayRole)

		QApplication.style().drawComplexControl(QStyle.CC_ComboBox, opt, painter)

		super(type(self),self).paint(painter, option, index)
