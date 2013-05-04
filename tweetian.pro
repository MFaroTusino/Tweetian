# Add more folders to ship with the application, here
folder_01.source = qml/imports
folder_01.target = qml
folder_02.source = qml/lib
folder_02.target = lib

DEPLOYMENTFOLDERS = folder_01 folder_02

# Application version
VERSION = 1.0.4
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += QMLJSDEBUGGER


# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
#CONFIG += mobility
CONFIG += qt-components

QT += network
QT += xml


HEADERS += \
    src/qmlutils.h \
    src/thumbnailcacher.h \
    src/userstream.h \
    src/networkmonitor.h \
    src/imageuploader.h \
    src/socialinvocation.h \



# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += \
    main.cpp \
    src/qmlutils.cpp \
    src/thumbnailcacher.cpp \
    src/userstream.cpp \
    src/networkmonitor.cpp \
    src/imageuploader.cpp \
    src/socialinvocation.cpp \


LIBS += -lQtLocationSubset
LIBS += -lbbcascadespickers
LIBS += -lbbsystem

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qmlapplicationviewer/qmlapplicationviewer.pri)
qtcAddDeployment()

OTHER_FILES += i18n/tweetian_*.ts \
    bar-descriptor.xml


INCLUDEPATH += $$PWD/qml
DEPENDPATH += $$PWD/qml

#include(qtblackberryaudio/qtblackberryaudio.pri)
