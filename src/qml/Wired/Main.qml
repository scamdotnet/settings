/*
 * Copyright (C) 2021 CutefishOS Team.
 *
 * Author:     rekols <aj@cutefishos.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

import FishUI 1.0 as FishUI
import Cutefish.NetworkManagement 1.0 as NM

import "../"

ItemPage {
    id: control
    headerTitle: qsTr("Wired")

    property var itemHeight: 45
    property var settingsMap: ({})

    NM.Handler {
        id: handler
    }

    NM.WifiSettings {
        id: wifiSettings
    }

    NM.NetworkModel {
        id: networkModel
    }

    NM.EnabledConnections {
        id: enabledConnections
    }

    NM.IdentityModel {
        id: connectionModel
    }

    NM.Configuration {
        id: configuration
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: mainLayout.implicitHeight

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent
            anchors.bottomMargin: FishUI.Units.largeSpacing
            spacing: FishUI.Units.largeSpacing * 2

            // Wired connection
            RoundedItem {
                visible: enabledConnections.wwanHwEnabled
                spacing: FishUI.Units.largeSpacing

                RowLayout {
                    spacing: FishUI.Units.largeSpacing

                    Label {
                        text: qsTr("Wired")
                        color: FishUI.Theme.disabledTextColor
                        Layout.fillWidth: true
                    }

                    Switch {
                        Layout.fillHeight: true
                        rightPadding: 0
                        checked: enabledConnections.wwanEnabled
                        onCheckedChanged: {
                            if (checked) {
                                if (!enabledConnections.wwanEnabled) {
                                    handler.enableWwan(checked)
                                }
                            } else {
                                if (enabledConnections.wwanEnabled) {
                                    handler.enableWwan(checked)
                                }
                            }
                        }
                    }
                }

                ListView {
                    id: wiredView

                    visible: enabledConnections.wwanEnabled && wiredView.count > 0

                    Layout.fillWidth: true
                    Layout.preferredHeight: wiredView.count * control.itemHeight
                    interactive: false
                    clip: true

                    model: NM.AppletProxyModel {
                        type: NM.AppletProxyModel.WiredType
                        sourceModel: connectionModel
                    }

                    ScrollBar.vertical: ScrollBar {}

                    delegate: WiredItem {
                        height: control.itemHeight
                        width: wiredView.width
                    }
                }
            }

            Item {
                height: FishUI.Units.largeSpacing
            }
        }
    }
}
