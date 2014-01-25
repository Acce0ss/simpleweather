import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    id: page

    property url detailsUrl: ""

    onForwardNavigationChanged: {
            if (forwardNavigation)
                forwardNavigation = false;
        }

    Column {
        anchors.fill: parent
        PageHeader {
            id: header
            title: "Openweathermap.org"
        }

        SilicaWebView {
            width: parent.width
            height: parent.height-header.height
            url: page.detailsUrl
        }
    }
}
