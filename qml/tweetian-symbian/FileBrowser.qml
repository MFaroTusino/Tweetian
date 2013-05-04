import QtQuick 1.1
import Qt.labs.folderlistmodel 1.0


Rectangle {
    id: fileBrowser
    color: "transparent"

    property string folder
    property bool shown: (loader.sourceComponent != undefined)

    signal fileSelected(string file)

    function selectFile(file) {
        if (file != "")
            folder = loader.item.folders.folder
        loader.sourceComponent = undefined
        fileBrowser.fileSelected(file)
    }

    Loader {
        id: loader
    }

    function show() {
        loader.sourceComponent = fileBrowserComponent
        loader.item.parent = fileBrowser
        loader.item.anchors.fill = fileBrowser
        loader.item.folder = fileBrowser.folder
    }

    Component {
        id: fileBrowserComponent

        Rectangle {
            id: root
            color: "white"
            property bool showFocusHighlight: false
            property variant folders: folders1
            property variant view: view1
            property alias folder: folders1.folder
            property color textColor: "black"

            FolderListModel {
                id: folders1
                folder: folder
                nameFilters: ["*.jpg", "*.png", "*.gif"]
            }

            FolderListModel {
                id: folders2
                folder: folder
                nameFilters: ["*.jpg", "*.png", "*.gif"]
            }

            SystemPalette {
                id: palette
            }

            Component {
                id: folderDelegate

                Rectangle {
                    id: wrapper
                    function launch() {
                        if (folders.isFolder(index))
                            down(filePath);
                        else{
                            console.log("Cuando se selecciona un File");
                            fileBrowser.selectFile(filePath)

                        }
                    }
                    //width: root.width
                    //height: 90
                    width: 240
                    height: 240
                    color: "transparent"

                    Rectangle {
                        id: highlight; visible: false
                        anchors.fill: parent
                        color: palette.highlight
                        gradient: Gradient {
                            GradientStop { id: t1; position: 0.0; color: palette.highlight }
                            GradientStop { id: t2; position: 1.0; color: Qt.lighter(palette.highlight) }
                        }
                    }

                    Column {
                        //anchors.fill: parent;

                        Image {
                            height: 180
                            width: 180
                            id: folderIcon
                            source: "qrc:/images/folder.png"
                            anchors.horizontalCenter: parent.horizontalCenter
                            //anchors.centerIn: parent
                        }
                        Text {
                                                id: nameText
                                                //anchors.fill: parent;
                                                anchors.horizontalCenter: parent.horizontalCenter
                                                //anchors.left: folderIcon.right; anchors.leftMargin: 10;
                                                verticalAlignment: Text.AlignVCenter
                                                text: fileName
                                                //anchors.leftMargin: 100
                                                font.pixelSize: 36
                                                color: (wrapper.GridView.isCurrentItem && root.showFocusHighlight) ? palette.highlightedText : textColor
                                                elide: Text.ElideRight
                        }

                        visible: folders.isFolder(index)
                    }

                    Image{
                        width: 230
                        height: 230
                        fillMode: Image.PreserveAspectCrop
                        source: filePath
                        clip: true
                        visible: !folders.isFolder(index)
                    }

                    /*Text {
                        id: nameText
                        anchors.fill: parent; verticalAlignment: Text.AlignVCenter
                        text: fileName
                        anchors.leftMargin: 100
                        font.pixelSize: 48
                        color: (wrapper.ListView.isCurrentItem && root.showFocusHighlight) ? palette.highlightedText : textColor
                        elide: Text.ElideRight
                    }*/

                    MouseArea {
                        id: mouseRegion
                        anchors.fill: parent
                        onPressed: {
                            root.showFocusHighlight = false;
                            wrapper.GridView.view.currentIndex = index;
                        }
                        onClicked: { if (folders == wrapper.GridView.view.model) launch() }
                    }

                    states: [
                        State {
                            name: "pressed"
                            when: mouseRegion.pressed
                            PropertyChanges { target: highlight; visible: true }
                            PropertyChanges { target: nameText; color: palette.highlightedText }
                        }
                    ]
                }
            }

            Rectangle {
                id: cancelButton
                width: 100
                height: titleBar.height - 7
                color: "black"
                anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }

                Text {
                    anchors { fill: parent; margins: 4 }
                    text: "Cancel"
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 20
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: fileBrowser.selectFile("")
                }
            }

            GridView {
                id: view1;
                model: folders1;
                width: parent.width;
                height: mainWindow.height - 21
                delegate: folderDelegate
                x: 0;
                cellWidth: 240; cellHeight: 240; interactive: false

                anchors.top: titleBar.bottom
                anchors.bottom: cancelButton.top
                highlight: Rectangle {
                    color: palette.highlight
                    visible: root.showFocusHighlight && view1.count != 0
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: palette.highlight }
                        GradientStop { position: 1.0; color: Qt.lighter(palette.highlight) }
                    }
                    width: view1.currentItem == null ? 0 : view1.currentItem.width
                }
                focus: true
                state: "current"
                states: [
                    State {
                        name: "current"
                        PropertyChanges { target: view1; x: 0 }
                    },
                    State {
                        name: "exitLeft"
                        PropertyChanges { target: view1; x: -root.width }
                    },
                    State {
                        name: "exitRight"
                        PropertyChanges { target: view1; x: root.width }
                    }
                ]
                transitions: [
                    Transition {
                        to: "current"
                        SequentialAnimation {
                            NumberAnimation { properties: "x"; duration: 250 }
                        }
                    },
                    Transition {
                        NumberAnimation { properties: "x"; duration: 250 }
                        NumberAnimation { properties: "x"; duration: 250 }
                    }
                ]
                Keys.onPressed: root.keyPressed(event.key)
            }

            GridView {
                id: view2
                anchors.top: titleBar.bottom
                anchors.bottom: parent.bottom
                cellWidth: 240; cellHeight: 240; interactive: false
                x: parent.width
                width: parent.width
                model: folders2
                delegate: folderDelegate
                highlight: Rectangle {
                    color: palette.highlight
                    visible: root.showFocusHighlight && view2.count != 0
                    gradient: Gradient {
                        GradientStop { id: t1; position: 0.0; color: palette.highlight }
                        GradientStop { id: t2; position: 1.0; color: Qt.lighter(palette.highlight) }
                    }
                    width: view1.currentItem == null ? 0 : view1.currentItem.width
                }

                pressDelay: 100
                states: [
                    State {
                        name: "current"
                        PropertyChanges { target: view2; x: 0 }
                    },
                    State {
                        name: "exitLeft"
                        PropertyChanges { target: view2; x: -root.width }
                    },
                    State {
                        name: "exitRight"
                        PropertyChanges { target: view2; x: root.width }
                    }
                ]
                transitions: [
                    Transition {
                        to: "current"
                        SequentialAnimation {
                            NumberAnimation { properties: "x"; duration: 250 }
                        }
                    },
                    Transition {
                        NumberAnimation { properties: "x"; duration: 250 }
                    }
                ]
                Keys.onPressed: root.keyPressed(event.key)
            }
            /*
            ListView {
                id: view3
                anchors.top: titleBar.bottom
                anchors.bottom: cancelButton.top
                x: 0
                width: parent.width
                model: folders1
                delegate: folderDelegate
                highlight: Rectangle {
                    color: palette.highlight
                    visible: root.showFocusHighlight && view1.count != 0
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: palette.highlight }
                        GradientStop { position: 1.0; color: Qt.lighter(palette.highlight) }
                    }
                    width: view1.currentItem == null ? 0 : view1.currentItem.width
                }
                highlightMoveSpeed: 1000
                pressDelay: 100
                focus: true
                state: "current"
                states: [
                    State {
                        name: "current"
                        PropertyChanges { target: view1; x: 0 }
                    },
                    State {
                        name: "exitLeft"
                        PropertyChanges { target: view1; x: -root.width }
                    },
                    State {
                        name: "exitRight"
                        PropertyChanges { target: view1; x: root.width }
                    }
                ]
                transitions: [
                    Transition {
                        to: "current"
                        SequentialAnimation {
                            NumberAnimation { properties: "x"; duration: 250 }
                        }
                    },
                    Transition {
                        NumberAnimation { properties: "x"; duration: 250 }
                        NumberAnimation { properties: "x"; duration: 250 }
                    }
                ]
                Keys.onPressed: root.keyPressed(event.key)
            } */



            Keys.onPressed: {
                root.keyPressed(event.key);
                if (event.key == Qt.Key_Return || event.key == Qt.Key_Select || event.key == Qt.Key_Right) {
                    view.currentItem.launch();
                    event.accepted = true;
                } else if (event.key == Qt.Key_Left) {
                    up();
                }
            }

            BorderImage {
                source: "qrc:/images/titlebar.sci";
                width: parent.width;
                height: 128
                y: -7
                id: titleBar

                Rectangle {
                    id: upButton
                    width: 120
                    height: titleBar.height - 7
                    color: "transparent"
                    Image { anchors.centerIn: parent; source: "qrc:/images/up.png" }
                    MouseArea { id: upRegion; anchors.centerIn: parent
                        width: 120
                        height: 120
                        onClicked: if (folders.parentFolder != "") up()
                    }
                    states: [
                        State {
                            name: "pressed"
                            when: upRegion.pressed
                            PropertyChanges { target: upButton; color: palette.highlight }
                        }
                    ]
                }

                Rectangle {
                    color: "gray"
                    x: 48
                    width: 1
                    height: 44
                }

                Text {
                    anchors.left: upButton.right; anchors.right: parent.right; height: parent.height
                    anchors.leftMargin: 4; anchors.rightMargin: 4
                    text: folders.folder
                    color: "white"
                    elide: Text.ElideLeft; horizontalAlignment: Text.AlignRight; verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 42
                }
            }

            function down(path) {
                if (folders == folders1) {
                    view = view2
                    folders = folders2;
                    view1.state = "exitLeft";
                } else {
                    view = view1
                    folders = folders1;
                    view2.state = "exitLeft";
                }
                view.x = root.width;
                view.state = "current";
                view.focus = true;
                folders.folder = path;
            }

            function up() {
                var path = folders.parentFolder;
                if (folders == folders1) {
                    view = view2
                    folders = folders2;
                    view1.state = "exitRight";
                } else {
                    view = view1
                    folders = folders1;
                    view2.state = "exitRight";
                }
                view.x = -root.width;
                view.state = "current";
                view.focus = true;
                folders.folder = path;
            }

            function keyPressed(key) {
                switch (key) {
                    case Qt.Key_Up:
                    case Qt.Key_Down:
                    case Qt.Key_Left:
                    case Qt.Key_Right:
                        root.showFocusHighlight = true;
                    break;
                    default:
                        // do nothing
                    break;
                }
            }
        }
    }
}
