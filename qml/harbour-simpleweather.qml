
import QtQuick 2.0

import Sailfish.Silica 1.0
import harbour.simpleweather.WeatherInfo 1.0

import "pages"
import "cover"
import "modules"

ApplicationWindow
{

    id: app

    property Page weatherPage

    ForecastPage {
        id: forecastPage
    }

    SimpleWeatherSettings {
        id: settings

        weather: weather
    }

    Timer {
        id: minutesTimer
        interval: 60000
        repeat: true
        running: weather.locationSet && !weather.isSearch && settings.allCities.length
    }

    Timer {
        id: refreshTimer
        interval: 30000
        repeat: true
        running: settings.autoRefreshOn && weather.locationSet && !weather.isSearch
                    && settings.allCities.length

        //property int counted: 0
        onTriggered:
        {

            if(weather.lastLoadTime*1000 + settings.refreshRate <= new Date().getTime()
                    || (!weather.lastLoadSuccess && (weather.lastLoadFailCount < 5)))
            {
                weather.refresh();
                //                    counted = counted + 1;
                //                    console.log(counted);
            }
            //console.log("Time checked");

        }

    }

    WeatherInfo {

        id: weather
        property bool downloading: false
        property bool locationSet: settings.currentCity !== ""
        property bool lastLoadSuccess: false
        property int lastLoadFailCount: 0
        property int lastLoadTime: new Date().getTime() / 1000 - 10*60
        property bool initialized: false

        onDataReady: {
            weather.downloading = false;
            weather.lastLoadSuccess = isSuccess;
            if(!isSuccess)
            {
                weather.lastLoadFailCount = weather.lastLoadFailCount + 1;
                if(weather.lastLoadFailCount >= 5 || weather.isSearch)
                {
                    if(!isServiceError)
                    {
                        showError(qsTr("Network error"), true);
                    }
                    else
                    {
                        showError(qsTr("Openweathermap.org temporarily unavailable"), true);
                    }

                }

            }else
            {

                weather.lastLoadFailCount = 0;

                weather.lastLoadTime = new Date().getTime() /1000;

                if(settings.newCityAdded)
                {
                    var tmp = [];
                    tmp = settings.allCities;
                    var idTmp = [];
                    idTmp = settings.cityIds;

                    idTmp.push(weather.getCity(tmp[tmp.length-1]).cityId);

                    settings.cityIds = idTmp;

                    settings.newCityAdded = false;
                    var city = settings.currentCity;
                    settings.currentCity = "placehold";
                    settings.currentCity = city;
                }

            }



        }

        function refresh() {

            if(((weather.lastLoadTime + 10*60)*1000 <= new Date().getTime() && !weather.downloading)
                    || !weather.lastLoadSuccess){
                if(weather.locationSet)
                {
                    weather.downloading = weather.refreshCurrentWeather();
                }
                else
                {
                    showError(qsTr("Set location first by searching!"), false);
                }

            }
            else
            {
                showError(qsTr("Already refreshed within 10 minutes or still downloading"), true);
            }
        }

        onCitiesModelChanged: {
            if(app.weatherPage)
            {
                app.weatherPage.updateCityPagerFromCover();
            }
        }

    }

    initialPage: Component {

        WeatherPage {
            id: weatherPage

            Component.onCompleted: app.weatherPage = weatherPage;
        }
    }

    cover: Component {

        id: coverPage

        CoverPage {

        }
    }

    Component {
        id: searchPageComponent
        SearchPage{
            onSelectionChanged: {

                if(selection !== "")
                {

                    weather.setLocationFromSearchList(selection);

                    weather.locationSet = true;

                    settings.currentCity = selection;

                    var tmp = settings.allCities;
                    tmp.push(selection);
                    settings.allCities = tmp;
                    var idTmp = settings.cityIds;
                    idTmp.push(weather.getCity(selection).cityId);
                    settings.cityIds = idTmp;

                    settings.storeSettings();

                }
            }
        }
    }

    onApplicationActiveChanged: {
        if(Qt.application.active)
        {
            app.weatherPage.updateCityPagerFromCover();
        }
    }


    Component.onDestruction: {
        settings.storeSettings();
    }

    function showError(message, showTryAgain) {

        if(pageStack.currentPage.objectName !== "MessagePage")
        {
            pageStack.push(Qt.resolvedUrl("pages/MessagePage.qml"));
            pageStack.currentPage.message = message;
            pageStack.currentPage.showTryAgain = showTryAgain;
        }
    }

    function openSearchFromCover()
    {
        pageStack.push(searchPageComponent);
        app.activate();
    }
}


