#include <QDateTime>

#include "cityweather.h"
#include "forecast.h"

CityWeather::CityWeather(QObject *parent) :
    QObject(parent), _current(new Forecast(this)),
    _days_objects(), _city(""),
    _id(0), _detailsUrl(""), _forecast_loadtime(QDateTime::fromTime_t(0))
{
}

QString CityWeather::city() const
{
    return this->_city;
}

QString CityWeather::details() const
{
    return this->_detailsUrl;
}

int CityWeather::cityId() const
{
    return this->_id;
}

QObject *CityWeather::currentWeather()
{
    return dynamic_cast<QObject*>(_current);
}

QList<QObject *> CityWeather::forecastModel()
{
    return _days_objects;
}

QDateTime CityWeather::forecastLoadtime() const
{
    return _forecast_loadtime;
}

QObject *CityWeather::getForecastForDay(int day)
{
    if(!_days_objects.empty() && (_days_objects.size() > day) && (day >= 0))
    {
        return this->_days_objects[day];
    }
}

void CityWeather::pushForecastDay(Forecast *forecast)
{
    this->_days_objects.push_back(dynamic_cast<QObject*>(forecast));
    emit forecastModelChanged();
}

void CityWeather::clearForecastData()
{
    int last_index = this->_days_objects.size()-1;
    for(int i = last_index; i >= 0; i--)
    {
        dynamic_cast<Forecast*>(this->_days_objects[i])->deleteLater();
        this->_days_objects.pop_back();
    }
    emit forecastModelChanged();
}

void CityWeather::setCity(QString name)
{
    if(this->_city != name)
    {
        this->_city = name;
        emit nameChanged();
    }
}

void CityWeather::setDetailsUrl(int id)
{
    QString new_url = QString("http://openweathermap.org/city/").append(QString::number(id));
    if(this->_detailsUrl != new_url)
    {
        this->_detailsUrl = new_url;
        emit detailsUrlChanged();
    }
}

void CityWeather::setCityId(int id)
{
    if(this->_id != id)
    {
        this->_id = id;
        emit cityIdChanged();
    }
}

void CityWeather::setForecastLoadtime(QDateTime date)
{
    if(this->_forecast_loadtime != date)
    {
        this->_forecast_loadtime = date;
        emit forecastLoadtimeChanged();
    }
}

