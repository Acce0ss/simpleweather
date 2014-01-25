import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
    id: root

    ListView.onRemove: animateRemoval(listItem)

    contentHeight: Theme.itemSizeSmall

    property bool selected: false

    Rectangle {
        anchors.fill: parent
        opacity: selected ? 0.5 : 1
        color: selected ? Theme.highlightColor : "transparent"
    }

    menu: Component {
        id: contextMenu
        ContextMenu {
            MenuItem {
                text: qsTr("Remove")
                onClicked: remove(index);
            }
        }
    }

    Label {
        id: label
        x: Theme.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        text: currentSettings.allCities[index]
        color: root.highlighted ? Theme.highlightColor : Theme.primaryColor
    }




}


