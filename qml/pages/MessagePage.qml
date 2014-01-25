import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    objectName: "MessagePage"

    property string message: ""
    property bool showTryAgain: false

    Label {
        id: upper

        anchors.centerIn: parent

        width: parent.width*2/3

        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter

        text: parent.message


    }
    Label {

        anchors.top: upper.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Theme.paddingLarge

        horizontalAlignment: Text.AlignHCenter

        text: parent.showTryAgain ? qsTr("Please try again later") : ""
    }

}
