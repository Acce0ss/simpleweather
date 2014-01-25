import QtQuick 2.0
import Sailfish.Silica 1.0
import "../modules"

Page {
    id: page

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

    Column {

        anchors.fill: parent

        PageHeader {
            id: header
            title: qsTr("Manage cities")
        }

        SilicaListView {

            id: cityFlick
            VerticalScrollDecorator {flickable: cityFlick}

            PullDownMenu {
                enabled: currentSettings.allCities.length > 1
                MenuItem {
                    text: page.swapModeOn ? qsTr("Cancel swapping"): qsTr("Swap two cities")
                    onClicked: {

                        page.swapModeOn = !page.swapModeOn;
                        page.swapIndex = -1;
                        page.targetIndex = -1;
                    }
                }
            }

            clip: true

            width: parent.width
            height: parent.height-header.height

            model: currentSettings.allCities

            delegate: CityDelegate {
                id: cityDelegate

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
                }

            }


        }

    }

    function initiateSwap()
    {
        currentSettings.swapCities(swapIndex, targetIndex);
        swapModeOn = false;
        swapIndex = -1;
        targetIndex = -1;
    }
}

