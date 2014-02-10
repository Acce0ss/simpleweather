
import QtQuick 2.0

import Sailfish.Silica 1.0
import harbour.simpleweather.WeatherInfo 1.0

import "pages"
import "cover"
import "modules"

// NOTE! Loading of initialpage is done in SimpleWeatherSettings,
// because it depends on the settings what page will be loaded.

ApplicationWindow
{

    id: app

    property Page weatherPage

    property Page summaryPage

    SimpleWeatherSettings {
        id: settings

        weather: weather
    }

    SimpleWeatherInfo {
        id: weather
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



    property bool returnedFromSettings: false

    property string pageWhereStarted
    property int depthWhenStarted
    property bool operationWasPop

    property bool useSummaryMode

    pageStack.onBusyChanged: {

        if(pageStack.busy)
        {
//            console.log("busy: " + pageStack.currentPage.objectName + "depth: " + pageStack.depth);
            app.pageWhereStarted = pageStack.currentPage.objectName;
            app.depthWhenStarted = pageStack.depth;
        }
        else
        {
          //  console.log("not busy: " + pageStack.currentPage.objectName + "depth: " + pageStack.depth);
            app.operationWasPop = app.depthWhenStarted > pageStack.depth;

            if(app.pageWhereStarted === "SettingPage" && app.operationWasPop)
            {
                if(settings.summaryChangedRecently)
                {
                    settings.summaryChangedRecently = false;
                    app.useSummaryMode = settings.summaryOn;
                }
            }
        }

    }

    onUseSummaryModeChanged: {

        app.resetPageStack();
    }

    Component {
        id: weatherPageComponent
        WeatherPage {
            id: weatherPage

            Component.onCompleted: app.weatherPage = weatherPage;
        }
    }

    Component {
        id: summaryPageComponent
        SummaryPage {
            id: summaryPage

            Component.onCompleted: app.summaryPage = summaryPage;

            currentSettings: settings
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

                    settings.currentIndex = tmp.length-1;
                    var idTmp = settings.cityIds;
                    idTmp.push(weather.getCityByIndex(tmp.length-1).cityId);
                    settings.cityIds = idTmp;

                    settings.storeSettings();

                    weather.clearSearchlist();

                }
            }
        }
    }



    onApplicationActiveChanged: {
        if(Qt.application.active && app.weatherPage)
        {
            app.weatherPage.updateCityPagerFromCover();
        }
    }

    Component.onDestruction: {
        settings.storeSettings();
    }

    function showError(message, showTryAgain) {

        if(pageStack.currentPage ? pageStack.currentPage.objectName !== "MessagePage" : false)
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

    function resetPageStack()
    {
        pageStack.clear();

        if(app.useSummaryMode)
        {
            pageStack.push(summaryPageComponent, {}, PageStackAction.Immediate);
            pageStack.pushAttached(weatherPageComponent);

        }
        else
        {
            pageStack.push(weatherPageComponent, {}, PageStackAction.Immediate);
        }
    }
}


