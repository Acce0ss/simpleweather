#include <QStringList>
#include "forecast.h"

Forecast::Forecast(QObject *parent) :
    QObject(parent), _icon(""),_temperature(""),
    _max_temperature(""), _min_temperature(""),
    _humidity(""), _condition(""),_wind(""),
    _wind_direction(""), _gust(""), _date()
{
}

QString Forecast::temperature() const
{
    return this->_temperature;
}

QString Forecast::minimumTemperature() const
{
    return this->_min_temperature;
}

QString Forecast::maximumTemperature() const
{
    return this->_max_temperature;
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
    double temp = temperature.toDouble();
    if(temp > 200)
    {
        temp = temp - 273.15;
        temperature = QString::number(temp);
    }


    if(this->_temperature != temperature)
    {
        this->_temperature = temperature;
        emit temperatureChanged();
    }
}

void Forecast::setMinimumTemperature(QString temperature)
{
    double temp = temperature.toDouble();
    if(temp > 200)
    {
        temp = temp - 273.15;
        temperature = QString::number(temp);
    }


    if(this->_min_temperature != temperature)
    {
        this->_min_temperature = temperature;
        emit minimumTemperatureChanged();
    }
}

void Forecast::setMaximumTemperature(QString temperature)
{
    double temp = temperature.toDouble();
    if(temp > 200)
    {
        temp = temp - 273.15;
        temperature = QString::number(temp);
    }


    if(this->_max_temperature != temperature)
    {
        this->_max_temperature = temperature;
        emit maximumTemperatureChanged();
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

