import QtQuick 2.0
import Sailfish.Silica 1.0


Row{
    id: root

    property Pager pager

    property int count: pager.count
    property int index: pager.indexNow
    property int indicatorRadius: 15

 //   width: count*indicatorRadius*2

    Repeater {

        id: indicators

        anchors.centerIn: parent
        // spacing: Theme.spacingSmall

        model: root.count
        delegate: GlassItem {
            height: root.indicatorRadius
            width: root.indicatorRadius
            property bool active: root.index === index
            dimmed: !(active)
            falloffRadius:  active ? 0.25 : 0.15
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
