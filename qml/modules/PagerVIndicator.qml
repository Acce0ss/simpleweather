import QtQuick 2.0
import Sailfish.Silica 1.0


Column{
    id: root

    property Pager pager

    property int count: pager.count
    property int index: pager.indexNow
    property int indicatorRadius: 15

    width: count*indicatorRadius*2

    Repeater {

        id: indicators

        anchors.centerIn: parent
        // spacing: Theme.spacingSmall

        model: root.count
        delegate: GlassItem {
            height: root.indicatorRadius*2
            width: root.indicatorRadius*2
            property bool active: root.index === index
            dimmed: !(active)
            falloffRadius:  active ? undefined : 0.075
            cache: false

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    pager.moveToPage(index);
                }
            }
        }

    }
}
