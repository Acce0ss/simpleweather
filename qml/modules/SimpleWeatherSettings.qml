import QtQuick 2.0
import harbour.simpleweather.WeatherInfo 1.0

Settings {
    id: settings

    property WeatherInfo weather

    //    this->setCurrentCity( this->_setup.value("currentCity", "").toString());
    //    this->setTempUnit( this->_setup.value("tempUnit", QString::fromUtf8("°C")).toString());
    //    this->setRefreshRate( this->_setup.value("refreshRate", 1000*60*30).toInt());
    //    this->setAutoRefreshOn( this->_setup.value("autoRefreshOn", true).toBool());
    Component.onCompleted: {
        setupConfig("harbour-simpleweather", "conf");

        settings.currentCity = readSetting("currentCity", "", Settings.String);
        settings.tempUnit = readSetting("tempUnit", "°C", Settings.String);
        settings.coverType = readSetting("coverType", "AddCity", Settings.String);

        settings.autoRefreshOn = readSetting("autoRefreshOn", true, Settings.Bool);
        settings.hourlyForecast = readSetting("hourlyForecast", false, Settings.Bool);
        settings.forecastOn = readSetting("forecastOn", false, Settings.Bool);
        settings.summaryOn = readSetting("summaryOn", false, Settings.Bool);
        settings.roundingOn = readSetting("roundingOn", true, Settings.Bool);

        settings.refreshRate = readSetting("refreshRate", 1000*60*30, Settings.Int);
        settings.forecastDays = readSetting("forecastDays", 1, Settings.Int);

        var temparray = [];
        temparray = readSettingsArray("allCities", Settings.String);
        settings.allCities = temparray;
        var idTmp = [];
        idTmp = readSettingsArray("cityIds", Settings.String);
        settings.cityIds = idTmp;

        if((settings.allCities.length === 0 || settings.cityIds.length === 0)&& settings.currentCity !== "")
        {
            var temp = [];
            temp.push(settings.currentCity)
            settings.allCities = temp;
            weather.downloading = weather.queryWith(settings.currentCity, WeatherInfo.Search);
            settings.newCityAdded = true;
        }
        else if(settings.currentCity != "")
        {

            settings.allCities.forEach(function (el, i, array){
                console.log(el + " " + i);
                weather.addCity(el, settings.cityIds[i]);
            });


            if(settings.currentCity === "")
            {
                settings.currentCity = settings.allCities[0];
            }

            weather.locationSet = true;
            weather.refresh();
            weather.initialized = true;
        }
        else
        {
            settings.coverType = "AddCity";
        }

        settings.initialized = true;
    }

    property string coverType
    property string currentCity
    property string tempUnit

    property int refreshRate
    property int forecastDays

    property bool autoRefreshOn
    property bool hourlyForecast
    property bool forecastOn
    property bool summaryOn
    property bool roundingOn


    onCoverTypeChanged: writeSetting("coverType", settings.coverType)
    onCurrentCityChanged: writeSetting("currentCity", settings.currentCity)
    onTempUnitChanged: writeSetting("tempUnit", settings.tempUnit)

    onRefreshRateChanged: writeSetting("refreshRate", settings.refreshRate)
    onForecastDaysChanged: writeSetting("forecastDays", settings.forecastDays)

    onAutoRefreshOnChanged: writeSetting("autoRefreshOn", settings.autoRefreshOn)
    onHourlyForecastChanged: writeSetting("hourlyForecast", settings.hourlyForecast)
    onForecastOnChanged: writeSetting("forecastOn", settings.forecastOn);
    onSummaryOnChanged:  writeSetting("summaryOn", settings.forecastOn)
    onRoundingOnChanged:  writeSetting("roundingOn", settings.roundingOn)

    property var allCities
    property var cityIds

    onAllCitiesChanged: {
        writeSettingsArray("allCities", settings.allCities);
     //   console.log(allCities);
    }
    onCityIdsChanged: {
        writeSettingsArray("cityIds", settings.cityIds);
       // console.log(cityIds);
    }

    property bool newCityAdded: false
    property bool initialized: false

    function permRemoveCity(index)
    {
        var temp = [];
        var idTemp = [];
        temp = settings.allCities;
        idTemp = settings.cityIds;
        var toRemove = temp.splice(index, 1);
        idTemp.splice(index, 1);
        settings.allCities = temp;
        settings.cityIds = idTemp;

        var name = toRemove.length === 1 ? toRemove[0] : "Error";
        if(name !== "Error")
        {

            if(settings.currentCity === name && settings.allCities.length > 1)
            {
                if(settings.allCities.length - 1 === index)
                {
                    settings.currentCity = settings.allCities[index-1];
                }
                else if(settings.allCities.length - 1 > index)
                {
                    settings.currentCity = settings.allCities[index+1];
                }
            }
            else if(settings.allCities.length === 1 && settings.coverType === "BrowseCities")
            {
                settings.coverType = "LastCity";
            }
            else if(settings.allCities.length === 0)
            {
                settings.currentCity = "";
                settings.coverType = "AddCity";
            }

            weather.removeCity(name);
        }
    }

    function swapCities(swapIndex, targetIndex)
    {

        var temp = [];
        var idTemp = [];
        temp = settings.allCities;
        idTemp = settings.cityIds;

        var toSwap = temp[swapIndex];
        var toSwapId = idTemp[swapIndex];
        var target = temp[targetIndex];
        var targetId = idTemp[targetIndex];

        temp[swapIndex] = target;
        temp[targetIndex] = toSwap;
        idTemp[swapIndex] = targetId;
        idTemp[targetIndex] = toSwapId;

        settings.allCities = temp;
        settings.cityIds = idTemp;

        weather.swapCities(toSwap, target);

    }
}