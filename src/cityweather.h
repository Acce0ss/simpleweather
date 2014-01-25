#ifndef CITYWEATHER_H
#define CITYWEATHER_H


#include <QObject>
#include <QList>

class Forecast;

class CityWeather : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ city NOTIFY nameChanged)
    Q_PROPERTY(QString detailsUrl READ details NOTIFY detailsUrlChanged)
    Q_PROPERTY(int cityId READ cityId NOTIFY cityIdChanged)
    Q_PROPERTY(QObject* currentWeather READ currentWeather NOTIFY currentWeatherChanged)
    Q_PROPERTY(QList<QObject*> forecastModel READ forecastModel NOTIFY forecastModelChanged)
public:
    explicit CityWeather(QObject *parent = 0);

    QString city() const;
    QString details() const;
    int cityId() const;
    QObject* currentWeather();
    QList<QObject *> forecastModel();

    void pushForecastDay(Forecast* forecast);
    void clearForecastData();

    void setCity(QString name);
    void setDetailsUrl(int id);
    void setCityId(int id);

signals:
    void nameChanged();
    void detailsUrlChanged();
    void cityIdChanged();
    void currentWeatherChanged();
    void forecastModelChanged();

public slots:
    QObject *getForecastForDay(int day);

private:

    Forecast* _current;

    QList<Forecast*> _days;
    QList<QObject*> _days_objects;

    QString _city;
    int _id;
    QString _detailsUrl;

};

#endif // CITYWEATHER_H
