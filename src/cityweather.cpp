#include "cityweather.h"
#include "forecast.h"

CityWeather::CityWeather(QObject *parent) :
    QObject(parent), _current(new Forecast(this)),_days(),
    _days_objects(), _city(""),
    _id(0), _detailsUrl("")
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

QObject *CityWeather::getForecastForDay(int day)
{
    if(!_days.empty() && (_days.size() > day) && (day >= 0))
    {
        return dynamic_cast<QObject*>(this->_days[day]);
    }
}

void CityWeather::pushForecastDay(Forecast *forecast)
{
    this->_days.push_back(forecast);
    this->_days_objects.push_back(dynamic_cast<QObject*>(forecast));
}

void CityWeather::clearForecastData()
{
    int last_index = this->_days.size()-1;
    for(int i = last_index; i >= 0; i--)
    {
        this->_days[i]->deleteLater();
        this->_days.pop_back();
    }
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

