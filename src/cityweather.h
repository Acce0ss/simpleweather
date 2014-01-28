#ifndef CITYWEATHER_H
#define CITYWEATHER_H


#include <QObject>
#include <QList>
#include <QDateTime>

class Forecast;

class CityWeather : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString name READ city NOTIFY nameChanged)
    Q_PROPERTY(QString detailsUrl READ details NOTIFY detailsUrlChanged)
    Q_PROPERTY(int cityId READ cityId NOTIFY cityIdChanged)
    Q_PROPERTY(QObject* currentWeather READ currentWeather NOTIFY currentWeatherChanged)
    Q_PROPERTY(QList<QObject*> forecastModel READ forecastModel NOTIFY forecastModelChanged)

     Q_PROPERTY(QDateTime forecastLoadtime READ forecastLoadtime NOTIFY forecastLoadtimeChanged)
public:
    explicit CityWeather(QObject *parent = 0);

    QString city() const;
    QString details() const;
    int cityId() const;
    QObject* currentWeather();
    QList<QObject *> forecastModel();
    QDateTime forecastLoadtime() const;

    void pushForecastDay(Forecast* forecast);
    void clearForecastData();

    void setCity(QString name);
    void setDetailsUrl(int id);
    void setCityId(int id);
    void setForecastLoadtime(QDateTime date);

signals:
    void nameChanged();
    void detailsUrlChanged();
    void cityIdChanged();
    void currentWeatherChanged();
    void forecastModelChanged();

    void forecastLoadtimeChanged();

public slots:
    QObject *getForecastForDay(int day);

private:

    Forecast* _current;

    QList<QObject*> _days_objects;

    QString _city;
    int _id;
    QString _detailsUrl;

    QDateTime _forecast_loadtime;

};

#endif // CITYWEATHER_H
