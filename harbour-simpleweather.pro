# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = harbour-simpleweather

CONFIG += sailfishapp quick

SOURCES += src/harbour-simpleweather.cpp \
    src/weatherinfo.cpp \
    src/settings.cpp \
    src/forecast.cpp \
    src/cityweather.cpp

OTHER_FILES += qml/harbour-simpleweather.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-simpleweather.yaml \
    harbour-simpleweather.desktop \
    qml/pages/SearchPage.qml \
    qml/pages/WeatherPage.qml \
    qml/modules/WeatherDisplay.qml \
    qml/pages/MessagePage.qml \
    qml/pages/DetailsWebPage.qml \
    qml/pages/SettingPage.qml \
    qml/modules/PagerVIndicator.qml \
    qml/modules/PagerHIndicator.qml \
    qml/modules/Pager.qml \
    qml/modules/WeatherDelegate.qml \
    qml/modules/ForecastDelegate.qml \
    qml/pages/ForecastPage.qml \
    qml/modules/WeatherLabel.qml \
    qml/pages/ManagementPage.qml \
    qml/modules/CityDelegate.qml \
    qml/pages/ChooseDialog.qml \
    qml/modules/SimpleWeatherSettings.qml \
    qml/cover/CoverWeatherDisplay.qml

HEADERS += \
    src/weatherinfo.h \
    src/settings.h \
    src/forecast.h \
    src/cityweather.h

