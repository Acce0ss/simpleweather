import QtQuick 2.0
import Sailfish.Silica 1.0
import "../modules"

Column {
    id: root

    property QtObject currentSettings
    property QtObject forecast

    property bool isCover: false

    property string name
    property string condition: forecast ? forecast.condition : ""
    property string iconSource: forecast ? forecast.icon : ""
    property string humidity: forecast ?qsTr("H: %1%").arg(forecast.humidity) : ""
    property string preTemp: forecast ?
                                 (currentSettings.roundingOn ?
                                  Math.round(forecast.temperature)
                                : forecast.temperature) + " " + currentSettings.tempUnit
                               : ""
    property string temperature: forecast ? preTemp : ""
    property string wind: forecast ? qsTr("W: %1 %2, %3").arg(forecast.wind).arg( "m/s").arg(direction)
                            : ""
    property string gust: forecast && forecast.gust !== "" ? qsTr("G: ")  + forecast.gust + qsTr(" m/s, ") + direction
                                                    : ""
    property string direction: forecast ? forecast.windDirection : ""

    property date time: forecast ? new Date((new Date().getTime() - forecast.dateTime.getTime())) : undefined

    property string timePassed: forecast ?
                                    qsTr("%1%2%3").arg(time.getUTCHours() > 0 ? time.getUTCHours() + " h " : "")
                                        .arg(time.getUTCMinutes() > 0 ? time.getUTCMinutes() + " min" : "")
                                           .arg("")
                                         : ""

    // add the count of selected items later here
    property int itemCount: forecast ? 6
                                    : 20

    function updateTime() {

        time = new Date((new Date().getTime() - forecast.dateTime.getTime()));
    }

    SectionHeader {
        id: cityHeader
        text: root.name
        wrapMode: Text.WordWrap
        //font.pixelSize: weatherModel.fontSize

        visible: forecast
    }

    SilicaListView {
        id: labels

        spacing: Theme.paddingSmall

        interactive: false
        width: parent.width
        height: parent.height-cityHeader.height

        model: weatherModel

    }

    VisualItemModel {
        id: weatherModel

        property int fontSize: Theme.fontSizeSmall

        Item {
            width: labels.width
            height: labels.height*2/root.itemCount

            Image {
                height: parent.height
                scale: 3
                anchors.centerIn: parent

                source: root.iconSource
                fillMode: Image.PreserveAspectFit
            }
        }

        Row {
            width: labels.width
            height: labels.height/root.itemCount
            WeatherLabel {
                width: parent.width / 2
                height: parent.height
                text: root.temperature
            }

            WeatherLabel {
                width: parent.width / 2
                height: parent.height
                text: root.humidity
            }
        }

        WeatherLabel {
            width: labels.width
            height: labels.height/root.itemCount
            text: root.wind
        }

        WeatherLabel {
            width: labels.width
            height: labels.height/root.itemCount
            text: root.gust
        }
    }
}
