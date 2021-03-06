/*
    Copyright (C) 2012 Dickson Leong
    This file is part of Tweetian.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 1.1
import com.nokia.symbian 1.1

Item {
    id: root

    property url headerIcon: ""
    property string headerText: ""

    property bool busy: false
    property int countBubbleValue: 0
    property bool countBubbleVisible: false

    signal clicked

    anchors { top: parent.top; left: parent.left; right: parent.right }
    implicitHeight: constant.headerHeight

    Image {
        id: background
        anchors.fill: parent
        source: "../Image/header.png"
    }

    Image {
        id: icon
        anchors { verticalCenter: parent.verticalCenter; left: parent.left; margins: constant.paddingMedium }
        height: sourceSize.height; width: sourceSize.width
        sourceSize { height: constant.graphicSizeSmall; width: constant.graphicSizeSmall }
        source: headerIcon
    }

    Text {
        anchors {
            left: icon.right
            right: busyIndicatorLoader.status == Loader.Ready ? busyIndicatorLoader.left : parent.right
            verticalCenter: parent.verticalCenter
            margins: constant.paddingMedium
        }
        elide: Text.ElideRight
        font.pixelSize: constant.fontSizeLarge
        color: "white"
        text: headerText
    }

    Row{
        anchors { verticalCenter: parent.verticalCenter; right: parent.right; margins: constant.paddingSmall }
        spacing: 2
        Rectangle {
            color: (platformInverted)? "#00a8df" : "white"
            height: root.height - 4
            width: 2
        }
        ToolButton {
            //iconSource: platformInverted ? "../Image/ic_fr_search.png" : "../Images/ic_fr_search_inverse.png"
            iconSource: "image://theme/toolbar-search"
            onClicked: pageStack.push(Qt.resolvedUrl("../TrendsPage.qml"))
            platformInverted: settings.invertedTheme
        }
        Rectangle {
            color: (platformInverted)? "#00a8df" : "white"
            height: root.height - 4
            width: 2
        }
        ToolButton {
            iconSource: "../Image/edit.svg"
            onClicked: root.clicked()
            platformInverted: settings.invertedTheme
        }
    }



    Loader {
        id: busyIndicatorLoader
        anchors { right: parent.right; rightMargin: constant.paddingMedium; verticalCenter: parent.verticalCenter }
        sourceComponent: busy ? busyIndicatorComponent : (countBubbleVisible ? countBubbleComponent : undefined)
    }

    Component {
        id: busyIndicatorComponent

        BusyIndicator {
            anchors.centerIn: parent
            height: constant.graphicSizeSmall + constant.paddingSmall
            width: constant.graphicSizeSmall + constant.paddingSmall
            running: true
        }
    }

    Component {
        id: countBubbleComponent

        CountBubble {
            value: root.countBubbleValue
        }
    }

    /*
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
        //onPressed: basicHapticEffect.play() 
        //onReleased: basicHapticEffect.play()  
    } */
}
