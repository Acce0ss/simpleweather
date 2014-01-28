import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.simpleweather.WeatherInfo 1.0
import "../modules"

Page {

    id: page

    objectName: "ForecastPage"

    property QtObject currentSettings
    property CityWeather city

    property int currentDay: forecastPager.indexNow

    property date time: forecastPager.count > 0 ? new Date((new Date().getTime() - city.forecastModel[0].dateTime.getTime())) : new Date(0)

    property string timePassed: forecastPager.count > 0 ?
                                    qsTr("Forecasted %1%2%3").arg(time.getUTCHours() > 0 ? time.getUTCHours() + " h " : "")
                                    .arg(time.getUTCMinutes() === 0  && time.getUTCHours() === 0
                                         ? qsTr("just now"): time.getUTCMinutes() + " min ago")
                                    .arg("")
                                  : ""

    property Timer minuter

    Connections {
        target: minuter
        onTriggered: {
            page.updateTime();
        }
    }

    Column {

        width: parent.width
        height: parent.height-footer.height

        PageHeader {
            id: header
            title: qsTr("Forecast for \n%1").arg(city ? city.name : "")
        }

        SectionHeader {
            id: timestamp
            text: page.timePassed
            wrapMode: Text.WordWrap
            visible: page.city
        }

        Pager {
            id: forecastPager

            anchors.horizontalCenter: parent.horizontalCenter

            model: page.city ? page.city.forecastModel : null

            delegate: Component {
                ForecastDelegate {
                    height: forecastPager.height
                    width: forecastPager.width

                    forecast: modelData

                }
            }

            isHorizontal: true
            hardEdges: true

            width: parent.width
            height: parent.height-header.height-forecastIndicator.height-timestamp.height

            startIndex: 0

            visible: !weather.downloading

            interactive: (forecastPager.count > 1)

            placeholderText: qsTr("No forecast data available")

        }

        PagerHIndicator {
            id: forecastIndicator
            pager: forecastPager

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: Theme.paddingMedium

            height: Theme.itemSizeMedium

            indicatorRadius: (Theme.itemSizeSmall / pager.count) * (pager.count > 3 ? 4 : 2)

            visible: (count > 1) && !weather.downloading

            z: 10
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

    function nextDay()
    {

    }

    function previousDay()
    {

    }


    function updateTime() {

        time = new Date(forecastPager.count > 0 ?
                            new Date((new Date().getTime() - city.forecastModel[0].dateTime.getTime()))
                          : 0);
    }
}
