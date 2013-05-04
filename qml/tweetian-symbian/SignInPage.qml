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
import "Services/Twitter.js" as Twitter
import "Component"

Page {
    id: signInPage

    property string tokenTempo: ""
    property string tokenSecretTempo: ""

    Flickable {
        id: flickable
        anchors { top: header.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        contentHeight: mainColumn.height + 2 * mainColumn.anchors.topMargin

        Column {
            id: mainColumn
            anchors { left: parent.left; right: parent.right; top: parent.top; topMargin: constant.paddingMedium }
            height: childrenRect.height
            spacing: constant.paddingSmall

            Text {
                anchors { left: parent.left; right: parent.right }
                font.pixelSize: constant.fontSizeXLarge
                color: constant.colorLight
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Welcome to Tweetian")
            }

            Item {
                id: pinCodeTextFieldWrapper
                anchors { left: parent.left; right: parent.right }
                height: pinCodeTextFieldRow1.height + 2 * constant.paddingXLarge

                Column {
                    id: pinCodeTextFieldRow1
                    anchors.centerIn: parent
                    width: childrenRect.width; height: loginTextField.height
                    spacing: constant.paddingLarge

                    Text {
                        font.pixelSize: constant.fontSizeMedium
                        color: constant.colorLight
                        text: "User:"
                    }

                    TextField {
                        id: loginTextField
                        platformInverted: settings.invertedTheme
                        width: pinCodeTextFieldWrapper.width * 0.7
                        enabled: !header.busy
                    }
                }
            }
            Item {
                id: pinCodeTextFieldWrapper2
                anchors { left: parent.left; right: parent.right }
                height: pinCodeTextFieldRow1.height + 2 * constant.paddingXLarge

                Column {
                    id: pinCodeTextFieldRow2
                    anchors.centerIn: parent
                    width: childrenRect.width; height: loginTextField.height
                    spacing: constant.paddingLarge

                    Text {
                        font.pixelSize: constant.fontSizeMedium
                        color: constant.colorLight
                        text: "Password:"
                    }

                    TextField {
                        id: passwordTextField
                        platformInverted: settings.invertedTheme
                        width: pinCodeTextFieldWrapper.width * 0.7
                        enabled: !header.busy
                        echoMode: TextInput.Password
                    }
                }
            }

            Item{
                id: spacer
                width: parent.width
                height: 60
            }

            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                width: signInButton.width
                height: signInButton.height + 2 * constant.paddingXLarge

                Button {
                    id: signInButton
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(implicitWidth, mainColumn.width * 0.7)
                    platformInverted: settings.invertedTheme
                    text: qsTr("Sign In")
                    font.pixelSize: {constant.fontSizeMedium}
                    enabled: !header.busy
                    onClicked: internal.signIn2ButtonClicked();
                }
            }
        }
    }

    ScrollDecorator { platformInverted: settings.invertedTheme; flickableItem: flickable }

    PageHeader {
        id: header
        headerText: qsTr("Sign In to Twitter")
        headerIcon: "Image/sign_in.svg"
    }

    WorkerScript {
           id: loginParser
           source: "WorkerScript/LoginParser.js"
           onMessage: internal.onParseComplete(messageObject);
       }



    QtObject {
        id: internal


        function onParseComplete(msg) {

                  switch (msg.type) {
                  case "login":
                      login(msg.usr, msg.pwd);
                  }
              }


             function login(usr, pwd) {
                 console.log("login() ");

             }

        function signInButtonClicked() {
            Twitter.postRequestToken(function(token, tokenSecret) {
                tokenTempo = token;
                tokenSecretTempo = tokenSecret;
                var signInUrl = "https://api.twitter.com/oauth/authorize?oauth_token=" + tokenTempo;
                Qt.openUrlExternally(signInUrl);
                infoBanner.showText("Launching external web browser...");
                header.busy = false;
                console.log("Launching web browser with url:", signInUrl);
             }, function(status, statusText) {
                 if (status === 401)
                     infoBanner.showText(qsTr("Error: Unable to authorize with Twitter. \
Make sure the time/date of your phone is set correctly."))
                 else
                     infoBanner.showHttpError(status, statusText);
                 header.busy = false;
             });
            header.busy = true;
        }

        function signIn2ButtonClicked() {
            Twitter.postRequestToken(function(token, tokenSecret) {
                tokenTempo = token;
                tokenSecretTempo = tokenSecret;

                console.log("token: " + token);
                console.log("secret: " + tokenSecret);

                internal.authorize(tokenTempo);

                header.busy = false;
             }, function(status, statusText) {
                 if (status === 401)
                     infoBanner.showText(qsTr("Error: Unable to authorize with Twitter. \
Make sure the time/date of your phone is set correctly."))
                 else
                     infoBanner.showHttpError(status, statusText);
                 header.busy = false;
             });
            header.busy = true;
        }

        function authorize(token){
            console.log("auth 1");
            Twitter.postAuthorizeToken(token,
                function (authToken){
                    console.log("token: " + token);
                    console.log("authorization token: " + authToken);

                    internal.handlePIN(token, authToken);
                },

                function(status2, statusText2){
                    if (status2 === 401)
                        infoBanner.showText(qsTr("Error: Unable to authorize with Twitter."));
                    else
                        infoBanner.showHttpError(status2, statusText2);
                });

        }

        function handlePIN(token, authenticityToken){
            Twitter.postHandlePIN(token,authenticityToken, loginTextField.text, passwordTextField.text,
                function (PIN){
                    console.log("token: " + token);
                    console.log("authenticityToken : " + authenticityToken);

                    console.log("PIN: " + PIN);

                    internal.getAccessToken(PIN)
                },

                function(status2, statusText2){
                    if (status2 === 401)
                        infoBanner.showText(qsTr("Error: Unable to authorize with Twitter."));
                    else
                        infoBanner.showHttpError(status2, statusText2);
                });
        }

        function getAccessToken(PIN) {
            Twitter.postAccessToken(tokenTempo, tokenSecretTempo, PIN,
            function (token, tokenSecret, screenName) {
                settings.oauthToken = token
                settings.oauthTokenSecret = tokenSecret
                settings.userScreenName = screenName
                infoBanner.showText(qsTr("Signed in successfully"))
                settings.settingsLoaded()
                pageStack.pop(null)
            }, function(status, statusText) {
                if (status === 401) {
                    pinCodeTextField.text = "";
                    infoBanner.showText(qsTr("Error: Unable to authorize with Twitter. \
Please sign in again and enter the correct PIN code."))
                }
                else infoBanner.showHttpError(status, statusText);
                header.busy = false;
            });
            header.busy = true;
        }
    }
}
