import QtQuick 1.0
import com.nokia.symbian 1.1
import Qt.labs.folderlistmodel 1.0
import "Component"


Page {
    id: selectImagePage

    property Item newTweetPage: null

    property string source1
    property string source2

    tools: ToolBarLayout {
        ToolButtonWithTip {
            toolTipText: qsTr("Back")
            iconSource: "toolbar-back"
            onClicked: pageStack.pop()
        }
        ToolButton {
            text: qsTr("Service")
            platformInverted: settings.invertedTheme
            onClicked: chooseServiceDialogComponent.createObject(selectImagePage)
        }
        ToolButton {
            text: qsTr("Open")
            platformInverted: settings.invertedTheme
            onClicked: {
          console.log("show file browser1")
          console.log(imagePath)
            fileBrowser1.folder = imagePath
                fileBrowser1.show()
            }
        }
        ToolButton { visible: false }
    }


    ContextMenu {
        id: imageMenu

        property string selectedImageUrl: ""
        property string selectedImagePath: ""

        platformInverted: settings.invertedTheme
        content: MenuLayout {
            MenuItem {
                text: qsTr("Select image")
                platformInverted: imageMenu.platformInverted
                onClicked: {
                    newTweetPage.imageUrl = imageMenu.selectedImageUrl
                    newTweetPage.imagePath = imageMenu.selectedImagePath
                    pageStack.pop()
                }
            }
            MenuItem {
                text: qsTr("Preview")
                platformInverted: imageMenu.platformInverted
                onClicked: Qt.openUrlExternally(imageMenu.selectedImageUrl)
            }
        }
    }

    ScrollDecorator {
        platformInverted: settings.invertedTheme
        flickableItem: galleryModel.ready ? galleryGridView : null
    }

    PageHeader {
        id: header
        headerText: qsTr("Select Image")
        headerIcon: "Image/photos.svg"
        onClicked: galleryGridView.positionViewAtBeginning()
    }


    FileBrowser {
          id: fileBrowser1
          anchors.fill: selectImagePage
          //anchors.fill: root
          //onFolderChanged: fileBrowser2.folder = folder
          onFolderChanged: fileBrowser2.folder = imagePath
          Component.onCompleted: fileSelected.connect(selectImagePage.openFile1)
      }

      FileBrowser {
          id: fileBrowser2
          //anchors.fill: root
          anchors.fill: selectImagePage
          //onFolderChanged: fileBrowser1.folder = folder
          onFolderChanged: fileBrowser1.folder = imagePath
          Component.onCompleted: fileSelected.connect(selectImagePage.openFile2)
      }

      function openFile1(path) {
          console.log("openFile1")
          console.log(path)
          //selectImagePage.source1 = path
          newTweetPage.imageUrl = path
          newTweetPage.imagePath = path
          pageStack.pop()
      }

      function openFile2(path) {
          console.log("openFile2")
          console.log(path)
          //selectImagePage.source2 = path
          newTweetPage.imageUrl = path
          newTweetPage.imagePath = path
          pageStack.pop()
      }
      // Called from main() once root properties have been set
         function init() {
             //performanceLoader.init()
             //fileBrowser1.folder = imagePath
             //fileBrowser2.folder = imagePath
         }
         Component {
             id: chooseServiceDialogComponent

             SelectionDialog {
                 id: chooseServiceDialog
                 property bool __isClosing: false
                 platformInverted: settings.invertedTheme
                 titleText: qsTr("Image Upload Service")
                 model: ListModel {
                     ListElement { name: "Twitter"}
                     ListElement { name: "TwitPic"}
                     ListElement { name: "MobyPicture"}
                     ListElement { name: "img.ly"}
                 }
                 selectedIndex: settings.imageUploadService
                 onAccepted: settings.imageUploadService = selectedIndex

                 Component.onCompleted: open()
                 onStatusChanged: {
                     if (status === DialogStatus.Closing) __isClosing = true
                     else if (status === DialogStatus.Closed && __isClosing) chooseServiceDialog.destroy()
                 }
             }
         }
 }
