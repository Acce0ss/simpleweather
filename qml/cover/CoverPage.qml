
import QtQuick 2.0
import Sailfish.Silica 1.0
import "../modules"


CoverBackground {


    id: root

    Connections {
        target: minutesTimer
        onTriggered: {
            coverWeather.updateTime()
        }
    }

    property QtObject currentCityObject: weather.getCityByIndex(settings.currentIndex)

    CoverWeatherDisplay {
        id: coverWeather
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter

        width: parent.width-Theme.paddingSmall
        height: parent.height*4/5

        forecast: root.currentCityObject ? root.currentCityObject.currentWeather : null
        currentSettings: settings

        name: root.currentCityObject ? root.currentCityObject.name : ""
        isCover: true
        visible: !weather.downloading && settings.allCities.length !== 0 && settings.coverType !== "BrowseForecast"
        z:1


    }

//    CoverForecastDisplay {
//        id: forecastWeather
//        anchors.top: parent.top
//        anchors.horizontalCenter: parent.horizontalCenter

//        width: parent.width-Theme.paddingSmall
//        height: parent.height*4/5

//        forecast: settings.currentCity === "" ? null :
//                                                settings.coverType === "BrowseForecast" ?
//                                                    weather.getCityByName(settings.currentCity).forecastModel[coverIndex]
//                                                        : null
//        currentSettings: settings

//        name: settings.currentCity === "" ? "" : weather.getCityByName(settings.currentCity).name
//        isCover: true
//        visible: !weather.downloading && settings.allCities.length !== 0 && settings.coverType === "BrowseForecast"
//        z:1


//    }



    CoverPlaceholder {
        text: qsTr("Add a city")
        anchors.fill: parent
        icon.source: "/usr/share/icons/hicolor/86x86/apps/harbour-simpleweather.png"
        visible: settings.allCities.length === 0
        enabled: visible
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: visible
        enabled: visible
        visible: weather.downloading && (parent.status === Cover.Active)
        size: BusyIndicatorSize.Medium
        z:10
    }

    property int coverIndex: settings.currentIndex


    function moveLeft(){
        if(coverIndex > 0)
        {
            settings.currentIndex = coverIndex-1;
        }
    }


    function moveRight() {

        if(coverIndex < settings.allCities.length)
        {

            settings.currentIndex = coverIndex+1;
        }
    }

    property bool browseMode: settings.coverType === "BrowseCities"

    property bool noPrevious: coverIndex <= 0
    property bool noNext: coverIndex >= settings.allCities.length-1

    CoverActionList {
        id: refreshAction

        enabled: settings.coverType === "LastCity"

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: {
                weather.refresh();
            }
        }
    }

    CoverActionList {
        id: addAction

        enabled: settings.coverType === "AddCity"

        CoverAction {
            iconSource: "image://theme/icon-cover-search"
            onTriggered: {
                app.openSearchFromCover();
            }
        }
    }

    CoverActionList {
        id: nextRefresh

        enabled: browseMode && noPrevious && !noNext

        CoverAction {
            iconSource: "image://theme/icon-cover-search"
            onTriggered: {
                app.openSearchFromCover();
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
                moveRight();
            }

        }

    }

    CoverActionList {
        id: previousRefresh

        enabled: browseMode && !noPrevious && noNext

        CoverAction {
            iconSource: "image://theme/icon-cover-previous"
            onTriggered: {
                moveLeft();
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-search"
            onTriggered: {
                app.openSearchFromCover();
            }
        }
    }
    CoverActionList {
        id: previousAndNext

        enabled: browseMode && !noPrevious && !noNext

        CoverAction {
            iconSource: "image://theme/icon-cover-previous"
            onTriggered: {
                moveLeft();
            }
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-next"
            onTriggered: {
                moveRight();
            }

        }
    }

}



