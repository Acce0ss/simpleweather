
import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.simpleweather.WeatherInfo 1.0

Page {

    id: page

    property bool tooManyResults: false
    property bool noResults: false
    property bool dataAcquired: false

    property string selection: qsTr("None")
    signal selectionClicked()

    onStatusChanged: {
        if(status === PageStatus.Deactivating)
        {
            weather.stopSearch();
        }
        else if(status === PageStatus.Activating)
        {
            weather.startSearch();
        }
    }

    Timer {
        id: lastChange
        repeat: false
        running: false
        interval: 2000
        onTriggered: {
            if(!page.dataAcquired)
            {
                weather.downloading = weather.queryWith(root.searchString, WeatherInfo.Search);
            }

        }

    }

    SilicaListView {

        id: root

        anchors.fill: parent
        anchors.topMargin: 2*Theme.paddingLarge

        property string searchString: ""
        property int searchLeftMargin: 0

        onSearchStringChanged: {
            if(searchString.length >= 3)
            {
                listModel.update();
            }
        }

        header: SearchField {


            width: parent.width
            placeholderText: qsTr("Type atleast 3 first letters...")


            onTextChanged: {

                root.searchString = text;

                if(text.length >= 3)
                {

                    lastChange.restart();

                }else if(text.length <= 2)
                {

                    lastChange.running = false;
                    page.dataAcquired = false;
                    weather.clearSearchlist();
                }
            }

            Component.onCompleted: {
                root.searchLeftMargin = textLeftMargin;
            }
        }

        // prevent newly added list delegates from stealing focus away from the search field
        currentIndex: -1

        model: ListModel {
            id: listModel
            property var cities: weather.searchResultCities

            onCitiesChanged: {

                update();
            }

            function update() {
                clear()
                page.noResults = false;
                page.tooManyResults = false;

                if(cities.length === 0)
                {
                    page.noResults = true;
                    page.tooManyResults = false;
                    page.dataAcquired = false;
                }
                else if(cities.length >= 10)
                {
                    page.noResults = false;
                    page.tooManyResults = true;
                    page.dataAcquired = false;

                }
                else
                {
                    page.noResults = false;
                    page.tooManyResults = false;
                    page.dataAcquired = true;

                    for (var i=0; i<cities.length; i++) {

                            append({"name": cities[i]});

                    }
                }

            //    console.log(page.tooManyResults + " " + page.noResults + " " + page.dataAcquired);
            }

            Component.onCompleted: update()
        }

        delegate: ListItem {
            Label {
                anchors {
                    left: parent.left
                    leftMargin: root.searchLeftMargin
                    verticalCenter: parent.verticalCenter
                }
                text: name

            }
            onClicked: {
                page.selection = name;
                pageStack.navigateBack(PageStackAction.Animated);
            }
        }

        Label {
            anchors.centerIn: parent

            horizontalAlignment: Text.AlignHCenter

            wrapMode: Text.WordWrap
            width: parent.width*2/3
            text: !lastChange.running && !weather.downloading
                  && page.tooManyResults ? qsTr("Too many results, please write more letters or add comma and country (eg. \"Rome, Italy\")") : ""
        }

        Label {
            anchors.centerIn: parent

            horizontalAlignment: Text.AlignHCenter

            wrapMode: Text.WordWrap
            width: parent.width*2/3
            text: !lastChange.running && !weather.downloading
                  && page.noResults ? qsTr("No results, try to replace umlaut and accented characters (ä to ae or a etc.) or add comma and country (eg. \"Rome, Italy\")") : ""
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: (weather.downloading || lastChange.running ) && Qt.application.active
        }
    }
}

