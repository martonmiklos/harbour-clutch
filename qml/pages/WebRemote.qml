/*

Clutch

Copyright (C) 2015 Sam Hobbs

This file is part of Clutch, a Silica frontend for the Transmission torrent client.

Clutch is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or
(at your option) any later version.

Clutch is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Clutch.  If not, see <http://www.gnu.org/licenses/>

*/

import QtQuick 2.0
import QtWebKit 3.0
import Sailfish.Silica 1.0

Page {
    id: webRemote
    PageHeader {
        id: header
        title: qsTr("Transmission Web UI")
    }

    // easy to hit back by accident when trying to open torrent files. Insert padding to move web view down
    Item {
        id:padding
        width: 1
        height: Theme.paddingLarge * 5
    }

    SilicaWebView {
        id: webView

        anchors {
            top: padding.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        // fixes for content width, thanks to Dax for helping me figure this out!

        // this works, but the content is offset to the left when the "open" button is pressed - clunky
        //property variant devicePixelRatio: {//1.5
        //    if (Screen.width <= 540) return 1.5;
        //    else if (Screen.width > 540 && Screen.width <= 768) return 2.0;
        //    else if (Screen.width > 768) return 3.0;
        //}
        //experimental.customLayoutWidth: webRemote.width / devicePixelRatio

        // this works much better
        experimental.preferences.javascriptEnabled: true
        experimental.preferredMinimumContentsWidth: 980
        experimental.userScripts: [Qt.resolvedUrl("../js/PixelRatioHandler.js")];



        // used to decide whether to show busy overlay (if loading, busy=1)
        onLoadingChanged: {
            busy = loading
        }

        url: "http://localhost:9091/"

        PullDownMenu {
            MenuItem {
                text: "Refresh"
                onClicked: webView.reload()
            }
            MenuItem {
                text: "Back"
                visible: webView.canGoBack
                onClicked: webView.goBack()
            }
            MenuItem {
                text: "Forward"
                visible: webView.canGoForward
                onClicked: webView.goForward()
            }
        }

        // enable file picker, from WebPirate
        experimental.filePicker: Item {
            Component.onCompleted: {
                if(pageStack.busy)
                    pageStack.completeAnimation();

                var page = pageStack.push(Qt.resolvedUrl("FilePicker.qml"));

                page.actionCompleted.connect(function(action, data) {
                    model.accept(data.toString().substring(7)); // Strip "file://"
                });

                page.rejected.connect(function() {
                    model.reject();
                });
            }
        }

    }

    // if the page is loading, busy=1 and the overlay is shown
    Rectangle {
        id: overlay
        visible: busy
        anchors.fill: webView
        color: "black"
        opacity: 0.5
    }
    // spinning circle centred in the overlay
    BusyIndicator {
        anchors.centerIn: overlay
        running: overlay.visible
        size: BusyIndicatorSize.Large
    }

}
