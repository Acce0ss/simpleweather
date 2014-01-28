import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    id: root

    property QtObject currentSettings

    property string name

    SectionHeader {
        id: cityHeader
        text: root.name
        wrapMode: Text.WordWrap

        visible: currentSettings.allCities.length > 1
    }

    SilicaListView {
        id: labels

        clip: true
        spacing: Theme.paddingSmall

        width: parent.width
        height: parent.height-cityHeader.height

        model: weather.cityModel

        delegate: SummaryDelegate {

            visible: modelData.name !== "Summary"

            forecast: modelData.currentWeather

            onClicked: {
                cityPager.moveToPage(index);
            }
        }

    }
}
