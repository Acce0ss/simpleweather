import QtQuick 2.0
import Sailfish.Silica 1.0
import "../modules"

Page {
    id: page

    objectName: "SummaryPage"

    property QtObject currentSettings

    property bool swapModeOn: false

    property int swapIndex: -1
    property int targetIndex: -1

    onSwapModeOnChanged: {
        if(!swapModeOn)
        {
            swapIndex = -1;
            targetIndex = -1;
        }
    }



    SilicaListView {

        id: cityFlick

        header: PageHeader {
            id: header
            title: qsTr("Summary")
        }


        MainMenu { }

        flickableDirection: Flickable.VerticalFlick

        VerticalScrollDecorator {flickable: cityFlick}

        clip: true

        anchors.top: parent.top

        width: parent.width
        height: parent.height-footer.height

        model: weather.citiesModel

        visible: !weather.downloading

        delegate: SummaryDelegate {
            id: cityDelegate

            width: cityFlick.width


            forecast: modelData.currentWeather

            name: modelData.name

            z: 10

            onClicked: {
                if(page.swapModeOn)
                {
                    if(selected)
                    {
                        selected = false;
                        if(page.swapIndex === index)
                        {
                            page.swapIndex = -1
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
                else
                {
                    pageStack.navigateForward(PageStackAction.Animated);

                    pageStack.currentPage.setCityIndex(index);
                }
            }

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
        size: BusyIndicatorSize.Medium
    }


    function initiateSwap()
    {
        currentSettings.swapCities(swapIndex, targetIndex);
        swapModeOn = false;
        swapIndex = -1;
        targetIndex = -1;
    }

}

