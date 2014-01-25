import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.simpleweather.WeatherInfo 1.0

Dialog {
    id: page

    property Settings currentSettings
    property bool previousLoaded: false

    onStatusChanged: {
        if(status === PageStatus.Active && !previousLoaded)
        {
            rate.currentIndex = secsToIndex(currentSettings.refreshRate/1000);
            forecastDays.currentIndex = daysToIndex(currentSettings.forecastDays);

            coverAction.currentIndex = coverTypeToIndex(currentSettings.coverType);

            refreshOn.checked = currentSettings.autoRefreshOn;
            hourlyOn.checked = currentSettings.hourlyForecast;
            forecastOn.checked = currentSettings.forecastOn;
            summaryOn.checked = currentSettings.summaryOn;
            roundingOn.checked = currentSettings.roundingOn;

            previousLoaded = true;
        }
    }

    onAccepted: {
        currentSettings.coverType = coverAction.coverType;

        currentSettings.refreshRate = rate.seconds*1000;
        currentSettings.forecastDays = forecastDays.days;

        currentSettings.autoRefreshOn = refreshOn.checked;
        currentSettings.hourlyForecast = hourlyOn.checked;
        currentSettings.forecastOn = forecastOn.checked;
        currentSettings.summaryOn = summaryOn.checked;
        currentSettings.roundingOn = roundingOn.checked;

        currentSettings.storeSettings();

        previousLoaded = false;
    }

    onCanceled: previousLoaded = false;

    SilicaFlickable {
        id: settingsFlick

        anchors.fill: parent
        contentHeight: content.height
        contentWidth: width
        clip: true

        ScrollDecorator {}

        Column {
            id: content
            width: parent.width

            spacing: Theme.paddingMedium

            DialogHeader {

                acceptText: qsTr("Save")
                cancelText: qsTr("Cancel")
                title: qsTr("Settings")
            }

            SectionHeader {
                text: qsTr("General")
            }

            TextSwitch {
                id: summaryOn
                width: parent.width

                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Enable summarizing")
                description: qsTr("Show summary of all cities with temperature and icon only")

            }

            TextSwitch {
                id: roundingOn
                width: parent.width

                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Temperature rounding")
                description: qsTr("Round temperatures to nearest integer")

            }

            ValueButton {
                label: qsTr("Weatherinfomartion shown")
                value: qsTr("Not implemented yet")
                enabled: false
                visible: enabled
                    onClicked: {
//                        var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog")

//                        dialog.accepted.connect(function() {
//                            value = dialog.dateText
//                        })
                    }
                }


            SectionHeader {
                text: qsTr("Automatic updating")
            }

            TextSwitch {
                id: refreshOn
                width: parent.width

                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Refresh automatically")

            }

            ComboBox {
                id: rate

                visible: refreshOn.checked
                width: parent.width

                property int seconds: currentItem.seconds

                label: qsTr("Refresh every")

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("15 minutes")
                        property int seconds: 60*15
                    }
                    MenuItem {
                        text: qsTr("30 minutes")
                        property int seconds: 60*30
                    }
                    MenuItem {
                        text: qsTr("hour")
                        property int seconds: 60*60
                    }
                    MenuItem {
                        text: qsTr("2 hours")
                        property int seconds: 60*60*2
                    }
                    MenuItem {
                        text: qsTr("3 hours")
                        property int seconds: 60*60*3
                    }
                    MenuItem {
                        text: qsTr("4 hours")
                        property int seconds: 60*60*4
                    }
                }

            }

            SectionHeader {
                text: qsTr("Forecasts")
            }

            TextSwitch {
                id: forecastOn
                width: parent.width

                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Enable forecasts")

                description: qsTr("Adds a forecast page accessible from main page")

            }

            TextSwitch {
                id: hourlyOn
                width: parent.width

                visible: forecastOn.checked
                enabled: false

                anchors.horizontalCenter: parent.horizontalCenter

                text: qsTr("Hourly forecasts")

                description: false ? qsTr("Hourly forecast for today on forecast page") : qsTr("Not implemented yet")

            }

            ComboBox {
                id: forecastDays

                width: parent.width

                visible: forecastOn.checked

                property int days: currentItem.days

                label: qsTr("Get forecast for")

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("tomorrow")
                        property int days: 1
                    }
                    MenuItem {
                        text: qsTr("3 days")
                        property int days: 3
                    }
                    MenuItem {
                        text: qsTr("5 days")
                        property int days: 5
                    }
                    MenuItem {
                        text: qsTr("7 days")
                        property int days: 7
                    }
                    MenuItem {
                        text: qsTr("10 days")
                        property int days: 10
                    }
                }

            }

            SectionHeader {
                text: qsTr("App cover")
            }

            ComboBox {
                id: coverAction

                width: parent.width

                label: qsTr("Cover")

                property string coverType: currentItem.coverType

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("shows last observed city")
                        property string coverType: "LastCity"

                    }
                    MenuItem {
                        text: qsTr("actions browse cities")
                        property string coverType: "BrowseCities"
                        enabled: currentSettings.allCities.length > 1
                        Label {
                            visible: !parent.enabled
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Add more cities to use")
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.secondaryColor
                        }
                    }
                    MenuItem {
                        enabled: forecastOn.checked
                        text: qsTr("actions browse forecast")
                        property string coverType: "BrowseForecast"
                        Label {
                            visible: !parent.enabled
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: qsTr("Enable forecasts to use")
                            font.pixelSize: Theme.fontSizeTiny
                            color: Theme.secondaryColor
                        }
                    }

                }

            }

        }
    }

    function secsToIndex(secs)
    {
        var val = 0;
        switch(secs)
        {
        case 60*15:
            val = 0;
            break;
        case 60*30:
            val = 1;
            break;
        case 60*60:
            val = 2;
            break;
        case 60*60*2:
            val = 3;
            break;
        case 60*60*3:
            val = 4;
            break;
        case 60*60*4:
            val = 5;
            break;
        default:
            break;
        }
        return val;
    }

    function coverTypeToIndex(type)
    {
        var val = 0;
        switch(type)
        {
        case "LastCity":
            val = 0;
            break;
        case "BrowseCities":
            val = 1;
            break;
        case "BrowseForecast":
            val = 2;
            break;
        default:
            break;
        }
        return val;
    }

    function daysToIndex(days)
    {
        var val = 0;
        switch(days)
        {
        case 1:
            val = 0;
            break;
        case 3:
            val = 1;
            break;
        case 5:
            val = 2;
            break;
        case 7:
            val = 3;
            break;
        case 10:
            val = 4;
            break;
        default:
            break;
        }
        return val;
    }
}
