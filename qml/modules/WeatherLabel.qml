import QtQuick 2.0
import Sailfish.Silica 1.0

Item {

    id: root

    property alias text: label.text
    property int fontSize: Theme.fontSizeMedium
    property alias color: label.color

    Label {
        id: label

        wrapMode: Text.WordWrap

        anchors.centerIn: parent

        font.pixelSize: root.fontSize
    }
}
