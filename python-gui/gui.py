import sys

from PySide.QtCore import *
from PySide.QtGui import *
from PySide.QtDeclarative import QDeclarativeView
from main import Ui_MainWindow

# Create a Qt application
app = QApplication(sys.argv)
# Create a Label and show it
#label = QLabel("Hello World")
#label.show()

class MainWindow(QMainWindow, Ui_MainWindow):
	def __init__(self, parent=None):
		super(type(self),self).__init__(parent)

		self.setupUi(self)

# Set the QML file and show
win = MainWindow()
win.show()
win.raise_()

# Enter Qt main loop
sys.exit(app.exec_())

# Enter Qt application main loop
app.exec_()
sys.exit()
