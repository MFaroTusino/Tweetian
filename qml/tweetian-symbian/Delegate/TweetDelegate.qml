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

AbstractDelegate {
    id: root
    sideRectColor: {
        switch (settings.userScreenName) {
        case model.inReplyToScreenName: return platformInverted ? constant.colorTextSelection : "#3f3f3f"
        case model.screenName: return constant.colorLight
        default:
            return platformInverted ? "white" : "#161616"
        }
    }

    Item {
        id: titleContainer
        anchors { left: parent.left; right: parent.right }
        anchors.topMargin: 0
        height: userNameText.height

        Text {
            id: userNameText
            anchors.left: parent.left
            width: Math.min(parent.width, implicitWidth)
            font.pixelSize: settings.largeFontSize ? constant.fontSizeMedium : constant.fontSizeSmall
            font.bold: true
            color: highlighted ? constant.colorHighlighted : constant.colorLight
            elide: Text.ElideRight
            text: model.name
        }

        Text {
            anchors { left: userNameText.right; right: favouriteIconLoader.left;
                margins: constant.paddingXSmall }
            font.pixelSize: settings.largeFontSize ? constant.fontSizeMedium : constant.fontSizeSmall
            color: highlighted ? constant.colorHighlighted : constant.colorMid
            elide: Text.ElideRight
            text: "@" + model.screenName
        }

        Loader {
            id: favouriteIconLoader
            anchors.right: parent.right
            width: sourceComponent ? item.sourceSize.height : 0
            sourceComponent: model.isFavourited ? favouriteIcon : undefined

            Component {
                id: favouriteIcon

                Image {
                    sourceSize { height: titleContainer.height; width: titleContainer.height }
                    source: platformInverted ? "../Image/favourite_inverse.svg" : "../Image/favourite.svg"
                }
            }
        }
    }

    Text {
        anchors { left: parent.left; right: parent.right }
        //font.pixelSize: settings.largeFontSize ? constant.fontSizeMedium : constant.fontSizeSmall
        font.pixelSize: settings.largeFontSize ? constant.fontSizeMedium : constant.fontSizeSmall
        wrapMode: Text.Wrap
        color: highlighted ? constant.colorHighlighted : constant.colorLight
        textFormat: Text.RichText
        text: model.richText
    }

    Item{
        height: model.isRetweet ? 46: 0
        anchors { left: parent.left; right: parent.right }
        Loader{
        id: retweetImg
            anchors { left: parent.left; }
            sourceComponent: model.isRetweet ? retweetImgComponent : undefined
        Component{
            id: retweetImgComponent
            Image {

                    sourceSize { height: 46; width: 46}
                    source: platformInverted ? "../Image/retweet_inverse.png": "../Image/retweet.png"
                }}
    }


        Loader {
            id: retweetLoader
            anchors { left: retweetImg.right; leftMargin: 10}
            sourceComponent: model.isRetweet ? retweetText : undefined
            Component {
                id: retweetText
                    Text {
                    font.pixelSize: settings.largeFontSize ? constant.fontSizeMedium : constant.fontSizeSmall
                    wrapMode: Text.Wrap
                    color: highlighted ? constant.colorHighlighted : constant.colorMid
                    text: qsTr("Retweeted by %1").arg("@" + model.retweetScreenName)
                    }

            }
        }


    }

    Text {
        anchors { left: parent.left; right: parent.right }
        horizontalAlignment: Text.AlignRight
        font.pixelSize: settings.largeFontSize ? constant.fontSizeXSmall : constant.fontSizeXXSmall
        color: highlighted ? constant.colorHighlighted : constant.colorMid
        elide: Text.ElideRight
        text: model.source + " | " + model.timeDiff
    }

    onClicked: {
        console.debug("click!!")
        pageStack.push(Qt.resolvedUrl("../TweetPage.qml"), { tweet: model })
    }
    onPressAndHold: dialog.createTweetLongPressMenu(model)
}
