import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.simpleweather.WeatherInfo 1.0
import "../modules"

Page {

    id: page

    property SimpleWeatherSettings currentSettings
    property CityWeather city

        Column {

            width: parent.width
            height: parent.height-footer.height

            PageHeader {
                title: "Forecast"
            }
        }

        Label {
            id: footer

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: Theme.paddingLarge

            color: Theme.highlightColor
            text: qsTr("Weather data by openweathermap.org")

        }

        BusyIndicator {
            anchors.centerIn: parent
            running: weather.downloading && Qt.application.active
        }
}
