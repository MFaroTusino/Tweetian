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

QtObject {
    id: constant

    // color
    property color colorHighlighted: settings.invertedTheme ? platformStyle.colorHighlightedInverted
                                                            : platformStyle.colorHighlighted
    property color colorLight: settings.invertedTheme ? platformStyle.colorNormalLightInverted
                                                      : platformStyle.colorNormalLight
    property color colorMid: settings.invertedTheme ? platformStyle.colorNormalMidInverted
                                                    : platformStyle.colorNormalMid
    property color colorTextSelection: settings.invertedTheme ? platformStyle.colorTextSelection
                                                              : platformStyle.colorTextSelectionInverted
    property color colorMarginLine: settings.invertedTheme ? platformStyle.colorDisabledLightInverted
                                                           : platformStyle.colorDisabledMid

    property color colorBackground: settings.invertedTheme ? platformStyle.colorBackgroundInverted : platformStyle.colorBackground
    // padding size

    property int paddingXSmall: platformStyle.paddingSmall - 4
    property int paddingSmall: platformStyle.paddingSmall
    property int paddingMedium: platformStyle.paddingMedium
    property int paddingLarge: platformStyle.paddingLarge
    property int paddingXLarge: platformStyle.paddingLarge + platformStyle.paddingSmall

    // font size
    property int fontSizeXXSmall: platformStyle.fontSizeSmall - 4
    property int fontSizeXSmall: platformStyle.fontSizeSmall - 2
    property int fontSizeSmall: platformStyle.fontSizeSmall + 2
    property int fontSizeMedium: platformStyle.fontSizeMedium + 6

    //property int fontSizeXLarge: platformStyle.fontSizeLarge + 2
    //property int fontSizeXXLarge: platformStyle.fontSizeLarge + 6

    property int fontSizeLarge: platformStyle.fontSizeLarge + 2
    property int fontSizeXLarge: platformStyle.fontSizeLarge + 4
    property int fontSizeXXLarge: platformStyle.fontSizeLarge + 8


    // graphic size
    property int graphicSizeTiny: platformStyle.graphicSizeTiny
    property int graphicSizeSmall: platformStyle.graphicSizeSmall
    property int graphicSizeMedium: platformStyle.graphicSizeMedium
    property int graphicSizeLarge: platformStyle.graphicSizeLarge

    property int thumbnailSize: platformStyle.graphicSizeLarge * 1.5
    property int avatarSize: platformStyle.graphicSizeLarge * 2.5

    // other
    //property int headerHeight: inPortrait ? 50 : 45
    property int headerHeight: inPortrait ? 90 : 85
    property int footerHeight: inPortrait ? 120 : 100
    property int toolbarHeight: inPortrait ? 180 : 160

    property int charReservedPerMedia: 23
    property url twitterBirdIcon: platformInverted ? "Image/twitter-bird-light.png" : "Image/twitter-bird-dark.png"

    property string userAgent: QMLUtils.userAgent()

    // -------- API Key/Secret ---------- //

    // Fill in the API key/secret below for respective service for certain feature to function
    // The provided Twitter OAuth cousumer key pair below are only for testing
    // The release version in Nokia Store have a different key pair

    property string twitterConsumerKey: "YOUR_CONSUMER_KEY"
    property string twitterConsumerSecret: "YOUR_CONSUMER_SECRET"

    // Needed for uploading image to TwitPic
    property string twitpicAPIKey: "eee0c8a184f3330352ed1dd9398e4189"

    // Needed for uploading image to Moby.ly
    property string mobypictureAPIKey: ""

    // Needed for sign in/add page to Pocket
    property string pocketAPIKey: ""

    // Needed for sign in/add page to Instapaper
    property string instapaperConsumerKey: ""
    property string instapaperConsumerSecret: ""

    // Needed for post to TwitLonger
    property string twitlongerApp: ""
    property string twitlongerAPIKey: ""

    // Needed for tweet translation
    property string msTranslationCliendId: ""
    property string msTranslationCliendSecret: ""

    // Needed for loading maps for geotagged tweet
    property string nokiaMapsAppId: ""
    property string nokiaMapsAppToken: ""

    // Needed for fetching Flickr image preview in tweet
    property string flickrAPIKey: ""

    // Needed for fetching YouTube thumbnail & streaming link in tweet
    property string youtubeDevKey: ""

    // TODO: move the following function to a more suitable place
    function encodeParameters(parameters) {
        var encoded = ""
        for (var p in parameters) {
            if (encoded) encoded += "&"
            encoded += p + "=" + encodeURIComponent(parameters[p])
        }
        return encoded
    }
}
