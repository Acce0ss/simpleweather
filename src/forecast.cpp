#include <QStringList>
#include "forecast.h"

Forecast::Forecast(QObject *parent) :
    QObject(parent), _icon(""),_temperature(""),
    _humidity(""), _condition(""),_wind(""),
    _wind_direction(""), _gust(""), _date()
{
}

QString Forecast::temperature() const
{
    return this->_temperature;
}

QString Forecast::condition() const
{
    return this->_condition;
}

QString Forecast::humidity() const
{
    return this->_humidity;
}

QString Forecast::icon() const
{
    return this->_icon;
}

QString Forecast::wind() const
{
    return this->_wind;
}

QString Forecast::gust() const
{
    return this->_gust;
}

QDateTime Forecast::date() const
{
    return this->_date;
}

QStringList Forecast::weatherModel()
{
    return QStringList() << _date.toString() << _temperature
                            << _icon << _condition
                               << _humidity << _wind
                                  << _wind_direction
                                     << _gust;
}

QString Forecast::windDirection() const
{
    return this->_wind_direction;
}

void Forecast::setTemperature(QString temperature)
{
    if(this->_temperature != temperature)
    {
        this->_temperature = temperature;
        emit temperatureChanged();
    }
}

void Forecast::setCondition(QString condition)
{
    if(this->_condition != condition)
    {
        this->_condition = condition;
        emit conditionChanged();
    }
}

void Forecast::setHumidity(QString humidity)
{

    if(this->_humidity != humidity)
    {
        this->_humidity = humidity;
        emit humidityChanged();
    }
}

void Forecast::setWind(QString wind)
{
    if(this->_wind != wind)
    {
        this->_wind = wind;
        emit windChanged();
    }
}

void Forecast::setGust(QString gust)
{
    if(this->_gust != gust)
    {
        this->_gust = gust;
        emit gustChanged();
    }

}

void Forecast::setWindDirection(QString direction)
{
    if(this->_wind_direction != direction)
    {
        this->_wind_direction = direction;
        emit windDirectionChanged();
    }

}

void Forecast::setIcon(QString icon)
{
    if(this->_icon != icon)
    {
        this->_icon = icon;
        emit iconChanged();
    }
}

void Forecast::setDate(QDateTime date)
{
    if(this->_date != date)
    {
        this->_date = date;
        emit dateTimeChanged();
    }
}

