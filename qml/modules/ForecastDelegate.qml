import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: root

    property QtObject forecast

    property string condition: forecast ? forecast.condition : ""
    property string iconSource: forecast ? forecast.icon : ""
    property string humidity: forecast ? qsTr("Humidity: %1%").arg(forecast.humidity) : ""
    property string minTemp: forecast ?
                                 (currentSettings.roundingOn ?
                                  Math.round(forecast.minimumTemperature)
                                : forecast.minimumTemperature) + " " + currentSettings.tempUnit
                               : ""
    property string maxTemp: forecast ?
                                 (currentSettings.roundingOn ?
                                  Math.round(forecast.maximumTemperature)
                                : forecast.maximumTemperature) + " " + currentSettings.tempUnit
                               : ""
    property string temperature: forecast ? qsTr("Temperature from %1 to %2").arg(minTemp).arg(maxTemp)
                                    : ""
    property string wind: forecast ? qsTr("Wind: %1 %2, %3").arg(forecast.wind).arg( "m/s").arg(direction)
                            : ""
    property string gust: forecast && forecast.gust !== ""  ?
                                                     qsTr("Gust: ") + forecast.gust + qsTr(" m/s, ") + direction : ""
    property string direction: forecast ? forecast.windDirection : ""

    // add the count of selected items later here
    property int itemCount: forecast ? 8
                                    : 20

    property date preDate

    property int day: index

    Component.onCompleted: {
        var temp = new Date();
        temp.setDate(temp.getDate() + day);
        preDate = temp;
    }

    property string forecastDate: forecast ? qsTr("%1%2").arg(index === 0 ? "Today, " : index === 1 ? "Tomorrow, " : "")
                                             .arg(preDate.toLocaleDateString())
                                 : ""

    SectionHeader {
        id: dayHeader
        text: root.forecastDate
        wrapMode: Text.WordWrap
        font.pixelSize: weatherModel.fontSize

        visible: forecast
    }

    SilicaListView {
        id: labels

        spacing: Theme.paddingSmall

        interactive: false
        width: parent.width
        height: parent.height-dayHeader.height

        model: weatherModel

    }

    VisualItemModel {
        id: weatherModel

        property int fontSize: Theme.fontSizeMedium

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

        WeatherLabel {
            width: labels.width
            height: labels.height/root.itemCount
            text: root.condition
        }

        WeatherLabel {
            width: labels.width
            height: labels.height/root.itemCount
            text: root.temperature
        }

        WeatherLabel {
            width: labels.width
            height: labels.height/root.itemCount
            text: root.humidity
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
