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
import Sailfish.Silica 1.0
import "pages"
import harbour.clutch.transmissioncontrol 0.1
import harbour.clutch.settings 0.1

ApplicationWindow
{
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All

    // class defined in transmissioncontrol.h for interacting with transmission process
    TransmissionControl {
        id: transmission
        leverOn: transmission.isTransmissionOn()

        // app settings is stored as a member object of transmission control
        // http://developer.ubuntu.com/api/qml/sdk-14.10/QtQml.qtqml-cppintegration-exposecppattributes/
        appSettings: AppSettings {

        }
    }

    // when transmission is turned on, push Web UI page
    // doesn't work when the app is started, because transmission is started in the constructor, before the signals & slots are connected
    Connections {
        target: transmission
        onTransmissionStateChanged: {
            if ( transmission.appSettings.autoOpenWebUI ) {
                if ( transmission.leverOn) {
                    if (pageStack.currentPage.id === "webRemote") {
                        pageStack.currentPage.refresh();
                    } else {
                        pageStack.push(Qt.resolvedUrl("pages/WebRemote.qml"));
                    }
                }
            }
        }
    }

}
