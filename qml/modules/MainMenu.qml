import QtQuick 2.0
import Sailfish.Silica 1.0

PullDownMenu {
    id: mainMenu

    MenuItem {
        text: qsTr("Settings")
        onClicked: {7
            settings.depthOnSettingsEntered = pageStack.depth;
            pageStack.push(Qt.resolvedUrl("../pages/SettingPage.qml"), {currentSettings: settings}, PageStackAction.Animated);

        }
    }

    //            MenuItem {
    //                text: qsTr("Search by GPS")
    //                onClicked: {
    //                    weather.searchByGPS();
    //                }
    //            }

    MenuItem {
        text: qsTr("Add a city")
        onClicked: {
            pageStack.push(searchPageComponent);
        }
    }
    MenuItem {
        text: qsTr("Refresh")
        onClicked: {
            weather.refresh();
        }
    }
}

