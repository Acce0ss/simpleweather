import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root

    property string temperature

    Column {
        anchors.fill: parent
        spacing: Theme.paddingMedium

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.temperature + settings.tempUnit
        }

    }
}
