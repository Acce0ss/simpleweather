import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {

    id: root

    property QtObject options

    Column {
        anchors.fill: parent
        PageHeader {

            title: qsTr("Choose information to be shown...")
        }

        SilicaListView {

            model: options
            contentHeight: Theme.itemSizeMedium
            delegate: Component {
                TextSwitch {
                    text: ""
                }
            }
        }
    }
}
