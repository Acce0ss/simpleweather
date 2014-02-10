import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.simpleweather.WeatherInfo 1.0

ListItem {

    id: root

    property QtObject cityData

    ListView.onRemove: animateRemoval(listItem)

    property bool selected: false

    Rectangle {
        anchors.fill: parent
        opacity: selected ? 0.5 : 1
        color: selected ? Theme.highlightColor : "transparent"
        radius: Theme.paddingLarge
    }

    menu: CityEditMenu {}

    hoverEnabled: false

    _showPress: false

    onClicked: {
        if(page.swapModeOn)
        {
            if(selected)
            {
                selected = false;
                if(page.swapIndex === index)
                {
                    page.swapIndex = -1;
                    page.swapModeOn = false;
                }
            }
            else
            {
                selected = true;
                if(page.swapIndex === -1)
                {
                    page.swapIndex = index;
                }
                else
                {
                    page.targetIndex = index;
                    page.initiateSwap();
                }
            }

        }
    }


    function remove(idx){
        remorse.execute(root, qsTr("Removing"), function (){
            settings.permRemoveCity(idx);
        });
    }

    function updateTime()
    {
        coverther.updateTime();
    }

    Column {
        id: content

        anchors.fill: parent

        spacing: Theme.paddingSmall


        WeatherDisplay {
            id: coverther

            width: parent.width-2*Theme.paddingMedium
            height:  parent.height-detailsButton.height-forecastButton.height

            anchors.horizontalCenter: parent.horizontalCenter

            forecast: root.cityData.currentWeather

            name: root.cityData.name

            currentSettings: settings

            visible: !weather.downloading
            z:1
        }

        Button {

            id: forecastButton
            height: parent.height/6

            visible: !root.menuOpen && settings.forecastOn

            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Forecast")
            onClicked:
            {

                weather.loadForecast(index);

                pageStack.push(Qt.resolvedUrl("../pages/ForecastPage.qml"),
                                       {city: root.cityData, currentSettings: settings,
                               minuter: minutesTimer});
            }

        }

        Button {

            id: detailsButton
            height: parent.height/6

            visible: !root.menuOpen

            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Weather details")
            onClicked:
            {

                pageStack.push(Qt.resolvedUrl("../pages/DetailsWebPage.qml"));
                pageStack.currentPage.detailsUrl = root.cityData.detailsUrl;
            }

        }


    }

}
