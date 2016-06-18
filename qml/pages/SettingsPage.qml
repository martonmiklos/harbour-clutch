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

/*
  Use QJsonObject to control settings, which are stored at
  ~/.config/transmission-daemon/settings.json
*/

Page {
    objectName: "SettingsPage"

    PageHeader {
        id: header
        title: qsTr("Settings")
    }

    SilicaFlickable {
        id: flickable

        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        contentHeight: content.height

        Column {
            id: content
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: Theme.paddingMedium
            anchors.rightMargin: Theme.paddingMedium

            SectionHeader { text: "Clutch Settings" }

            TextSwitch {
                text: "Start Transmission Automatically"

                checked: transmission.appSettings.autoStartDaemon;
                onCheckedChanged: {
                    transmission.appSettings.autoStartDaemon = checked;
                }
            }

            TextSwitch {
                text: "Open web remote when daemon starts"

                checked: transmission.appSettings.autoOpenWebUI;
                onCheckedChanged: {
                    transmission.appSettings.autoOpenWebUI = checked;
                }
            }

            SectionHeader { text: "Transmission Daemon Settings" }

            Label {
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeMedium
                color: Theme.primaryColor
                text: qsTr("Not implemented")
            }

        }

        VerticalScrollDecorator {flickable: flickable}
    }
}
