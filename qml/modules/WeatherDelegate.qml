import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.simpleweather.WeatherInfo 1.0

ListItem {

    id: root

    ListView.onRemove: animateRemoval(listItem)

    property bool selected: false



    Rectangle {
        anchors.fill: parent
        opacity: selected ? 0.5 : 1
        color: selected ? Theme.highlightColor : "transparent"
        radius: Theme.paddingLarge
    }

    menu: Component {
        id: contextMenu
        ContextMenu {
            MenuItem {
                text: qsTr("Remove")
                onClicked: remove(index);
            }
            MenuItem {
                text: qsTr("Swap places with a city")
                enabled: settings.allCities.length > 1

                Label {
                    visible: !parent.enabled
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("Add more cities to use")
                    font.pixelSize: Theme.fontSizeTiny
                    color: Theme.secondaryColor
                }

                onClicked: {

                    page.swapModeOn = !page.swapModeOn;
                    page.swapIndex = index;
                    page.targetIndex = -1;

                    selected = true;
                }
            }
        }
    }

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
        remorseAction(qsTr("Removing"), function (){
            settings.permRemoveCity(idx);
        });
    }

    property QtObject cityData

    function updateTime()
    {
        coverther.updateTime();
    }

    Column {

        anchors.fill: parent

        spacing: Theme.paddingSmall

        WeatherDisplay {
            id: coverther

            width: parent.width-2*Theme.paddingMedium
            height: parent.height-detailsButton.height

            anchors.horizontalCenter: parent.horizontalCenter



            forecast: root.cityData.currentWeather

            name: root.cityData.name

            currentSettings: settings

            visible: !weather.downloading
            z:1
        }

        Button {

            id: detailsButton
            height: parent.height/6

            visible: root.menuOpen

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
