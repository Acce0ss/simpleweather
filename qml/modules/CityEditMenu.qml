import QtQuick 2.0
import Sailfish.Silica 1.0

Component {
        id: contextMenu
        ContextMenu {

            MenuItem {
                text: qsTr("Remove")
                onClicked: remove(index);
            }
            MenuItem {
                text: qsTr("Swap places with a city")
                enabled: settings.allCities.length > 1

                Label {
                    visible: !parent.enabled
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Add more cities to use")
                    font.pixelSize: Theme.fontSizeTiny
                    color: Theme.secondaryColor
                }

                onClicked: {

                    page.swapModeOn = !page.swapModeOn;
                    page.swapIndex = index;
                    page.targetIndex = -1;

                    selected = true;
                }
            }
        }
    }
