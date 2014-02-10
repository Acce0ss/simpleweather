import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {

    id: root

    contentHeight: Theme.itemSizeMedium

    ListView.onRemove: animateRemoval(listItem)

    property bool selected: false

    property QtObject forecast

    property string name

    property string iconSource: forecast ? forecast.icon : ""

    property string preTemp: forecast ?
                                 (currentSettings.roundingOn ?
                                  Math.round(forecast.temperature)
                                : forecast.temperature) + " " + currentSettings.tempUnit
                               : ""
    property string temperature: forecast ? qsTr("Temperature: %1").arg(preTemp)
                                    : ""

    menu: CityEditMenu {}

    Row {
        width: parent.width
        height: parent.height
        WeatherLabel {
            width: parent.width * 3 / 5
            height: parent.height
            text: root.name
            color: Theme.primaryColor
        }
        WeatherLabel {
            height: parent.height
            width: parent.width / 5
            text: root.preTemp
        }
        Image {
            height: parent.height
            width: parent.width /5
            scale: 1

            source: root.iconSource
            fillMode: Image.PreserveAspectFit
        }
    }

    Rectangle {
        anchors.fill: parent
        opacity: selected ? 0.5 : 1
        color: selected ? Theme.highlightColor : "transparent"
        radius: Theme.paddingLarge
    }

    function remove(idx){
        remorse.execute(root, qsTr("Removing"), function (){
            currentSettings.permRemoveCity(idx);
        });
    }

}
