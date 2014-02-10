import QtQuick 2.0
import harbour.simpleweather.WeatherInfo 1.0

WeatherInfo {

    id: weather

    numberOfDays: settings.forecastDays + 1

    property bool downloading: false
    property bool locationSet: settings.currentCity !== ""
    property bool lastLoadSuccess: false
    property int lastLoadFailCount: 0
    property int lastLoadTime: 0
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

                weather.lastLoadSuccess = true;
                weather.lastLoadTime = 0;
                weather.lastLoadFailCount = 0;

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

                idTmp.push(weather.getCityByIndex(tmp.length-1).cityId);

                settings.cityIds = idTmp;

                settings.newCityAdded = false;

                var ind = tmp.length-1;
                settings.currentIndex = -1;
                settings.currentIndex = ind;

                var city = settings.currentCity;
                settings.currentCity = "placehold";
                settings.currentCity = tmp[ind];
            }

//            if(settings.loadForecastOnStart)
//            {
//                loadForecast();

//                settings.loadForecastOnStart = false;
//            }

        }



    }

    function refresh() {

        if(lastLoadSuccess || !weather.initialized)
        {
            if(((weather.lastLoadTime + 10*60)*1000 <= new Date().getTime() && !weather.downloading)
                    ){
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
        else
        {
            weather.repeatLastQuery();
        }
    }

    onCitiesModelChanged: {
        if(app.weatherPage)
        {
            app.weatherPage.updateCityPagerFromCover();
        }
    }


    function loadForecast(index) {

        var cityData = weather.getCityByIndex(index);

        if(((cityData.forecastLoadtime.getTime() + settings.refreshRate) <= new Date().getTime()
            && !weather.downloading)
                || !weather.lastLoadSuccess)
        {
            if(weather.locationSet)
            {
                console.log(settings.currentCity);
                weather.downloading = weather.queryWith(settings.cityIds[index], WeatherInfo.CurrentForecast);
            }


        }

    }

}
