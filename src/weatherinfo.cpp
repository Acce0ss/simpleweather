#include "weatherinfo.h"
#include "cityweather.h"
#include "forecast.h"

#include <QtNetwork>
#include <QGuiApplication>
#include <QtCore>

WeatherInfo::WeatherInfo(QObject *parent, QUrl url) : QObject(parent),
    m_url(url), m_query(""),
    qnam(), reply(NULL),
     _city_indexes(), _cities(), _searchlist(),
     downloading(false), searching(false), m_latestData(""),
     _type(WeatherInfo::CurrentWeather), _numberOfDays(1)
{
    buildUrl();

}

void WeatherInfo::setUrl(QUrl url)
{

    if (url != m_url) {
        this->m_url = url;

    }
}

void WeatherInfo::setQuery(QString query)
{

    if (query != this->m_query) {
        this->m_query = query;
        emit queryChanged();
    }
}

void WeatherInfo::setNumberOfDays(int nod)
{
    if(this->_numberOfDays != nod)
    {
        this->_numberOfDays = nod;
        emit numberOfDaysChanged();
    }
}


QString WeatherInfo::query() const
{
    return this->m_query;
}

int WeatherInfo::numberOfDays() const
{
    return this->_numberOfDays;
}

QList<QObject *> WeatherInfo::citiesModel()
{
    return this->_cities;
}


bool WeatherInfo::isSearch() const
{
    return this->searching;
}

void WeatherInfo::startSearch()
{
    this->searching = true;
    emit isSearchChanged();
}

void WeatherInfo::stopSearch()
{
    this->searching = false;
    emit isSearchChanged();
}

QVariantList WeatherInfo::searchList() const
{
    return this->_searchlist;
}

bool WeatherInfo::downloadData()
{
    if(this->m_url.toString() != "")
    {
        if(searching)
        {
            if( !_searchlist.empty() && _searchlist.size() < 11)
            {
                //cities starting with that letter already loaded.
                return false;
            }
        }

        if(reply != NULL && reply->isRunning())
        {
            //abort the current operation to start new one
            reply->abort();
            reply->deleteLater();
            reply = NULL;
        }

        reply = qnam.get(QNetworkRequest(m_url));
        connect(reply, SIGNAL(finished()), this, SLOT(httpFinished()));
        this->downloading = true;

        return true;
    }
    else
    {
        return false;
    }

}

QObject* WeatherInfo::getCityByName(QString name)
{
    //qDebug() << name << " " << _cities.size() << _city_indexes;
    return this->findCityByName(name);
}

QObject *WeatherInfo::getCityByIndex(int index)
{
    return this->_cities.at(index);
}

bool WeatherInfo::queryWith(QString query, QueryType type)
{
    this->_type = type;
    this->setQuery(query);

    buildUrl();

    return downloadData();
}

bool WeatherInfo::refreshCurrentWeather()
{
    QString query = "";
    CityWeather* temp;
    foreach (QObject* city, this->_cities) {
        temp = dynamic_cast<CityWeather*>(city);
        if(temp->city() != "Summary")
        {
            query.append(QString::number(temp->cityId())).append(",");
        }
    }

    if(query != "")
    {
        query.remove(query.length() - 1, 1);
        return this->queryWith(query, WeatherInfo::CurrentWeather);
    }
    else
    {
        return false;
    }
}

void WeatherInfo::addCityBack(QString name, int id)
{
    CityWeather* city = new CityWeather(this);
    this->_cities.append( dynamic_cast<QObject*>(city) );
    int index = _cities.indexOf(dynamic_cast<QObject*>(city));
    city->setCity(name);
    city->setCityId(id);
    city->setDetailsUrl(id);
    this->_city_indexes[name] = index;
    emit citiesModelChanged();

}

void WeatherInfo::addCityFront(QString name, int id)
{
    CityWeather* city = new CityWeather(this);

    city->setCity(name);
    city->setCityId(id);
    city->setDetailsUrl(id);
    this->_cities.prepend( dynamic_cast<QObject*>(city) );
    int index = _cities.indexOf(dynamic_cast<QObject*>(city));
    QHashIterator<QString, int> i(_city_indexes);
    while (i.hasNext()) {
        i.next();
        _city_indexes[i.key()] += 1;
    }

    this->_city_indexes[name] = index;
    emit citiesModelChanged();

}

void WeatherInfo::removeCity(int index)
{
    if(index >= 0 && index < _cities.size())
    {
        CityWeather* temp = dynamic_cast<CityWeather*>(_cities.at(index));
        _city_indexes.remove(temp->city());
        _cities.removeAt(index);

        for(int i = 0; i < _cities.size(); i++)
        {
            _city_indexes[dynamic_cast<CityWeather*>(_cities.at(i))->city()] = i;
        }

        temp->deleteLater();
        emit citiesModelChanged();
    }

}

void WeatherInfo::swapCities(QString toSwap, QString target)
{
    int swapIndex = _city_indexes[toSwap];
    int targetIndex = _city_indexes[target];

    QObject* toSwapObject = _cities.at(swapIndex);
    QObject* targetObject = _cities.at(targetIndex);

    //Let the swap begin!
    _city_indexes[toSwap] = targetIndex;
    _city_indexes[target] = swapIndex;

    _cities[swapIndex] = targetObject;
    _cities[targetIndex] = toSwapObject;

    emit citiesModelChanged();

}

void WeatherInfo::resetForecastLoadtimes()
{
    for(int i = 0; i < _cities.size(); i++)
    {
        dynamic_cast<CityWeather*>(_cities.at(i))->setForecastLoadtime(QDateTime::fromTime_t(0));
    }

}

bool WeatherInfo::repeatLastQuery()
{
    return this->downloadData();
}

void WeatherInfo::setLocationFromSearchList(QString name)
{
    this->searching = false;

    QJsonDocument jDoc = QJsonDocument::fromJson(m_latestData.toLatin1());

    parseSearch(jDoc.object()["list"].toArray().at(_searchlist.indexOf(name)).toObject());
}

void WeatherInfo::clearSearchlist()
{
    this->_searchlist.clear();
    emit searchResultCitiesChanged();
}

void WeatherInfo::httpFinished()
{
    m_latestData = reply->readAll();

    qDebug() << m_latestData;

    bool isSuccess = false;
    bool isServiceError = false;

    QNetworkReply::NetworkError lastError = reply->error();

    switch (lastError) {
    case QNetworkReply::ConnectionRefusedError:
    case QNetworkReply::RemoteHostClosedError:
    case QNetworkReply::HostNotFoundError:
    case QNetworkReply::TimeoutError:
    case QNetworkReply::OperationCanceledError:
    case QNetworkReply::SslHandshakeFailedError:
    case QNetworkReply::TemporaryNetworkFailureError:
    case QNetworkReply::NetworkSessionFailedError:
    case QNetworkReply::BackgroundRequestNotAllowedError:
    case QNetworkReply::ProxyConnectionRefusedError:
    case QNetworkReply::ProxyConnectionClosedError:
    case QNetworkReply::ProxyNotFoundError:
    case QNetworkReply::ProxyTimeoutError:
    case QNetworkReply::ProxyAuthenticationRequiredError:
    case QNetworkReply::ContentAccessDenied:
    case QNetworkReply::ContentOperationNotPermittedError:
    case QNetworkReply::ContentNotFoundError:
    case QNetworkReply::AuthenticationRequiredError:
    case QNetworkReply::ContentReSendError:
    case QNetworkReply::ProtocolUnknownError:
    case QNetworkReply::ProtocolInvalidOperationError:
    case QNetworkReply::UnknownNetworkError:
    case QNetworkReply::UnknownProxyError:
    case QNetworkReply::UnknownContentError:
    case QNetworkReply::ProtocolFailure:
        isSuccess = false;
        break;
    case QNetworkReply::NoError:
        if(m_latestData.contains("iamdie"))
        {
            isSuccess = false;
            isServiceError = true;
        }
        else
        {
            isSuccess = true;
        }
        break;
    default:
        isSuccess = false;
        break;
    }

    this->downloading = false;

    if(searching && isSuccess)
    {
        parseCities(m_latestData);

    }
    else if(isSuccess)
    {
        QJsonDocument jDoc = QJsonDocument::fromJson(m_latestData.toLocal8Bit());
        //qDebug() << jDoc.object().toVariantMap();
        parseData(jDoc);
    }

    reply->deleteLater();
    reply = NULL;

    emit dataReady(isSuccess, isServiceError);
}


void WeatherInfo::parseCities(QString data)
{
    _searchlist.clear();
    QJsonDocument jDoc = QJsonDocument::fromJson(data.toLatin1());
    QJsonArray info = jDoc.object()["list"].toArray();


    for(int i = 0; i < info.size(); i++)
    {

        QJsonObject location = info[i].toObject();
        _searchlist.append(location["name"].toString()
                .append(", ").append(location["sys"].toObject()["country"].toString()));

    }

//    qDebug() << _searchlist.size() << "\n" << data;
    emit searchResultCitiesChanged();
}

void WeatherInfo::parseForecast(QJsonObject info)
{

    QJsonObject cityObject = info["city"].toObject();
    QString city = cityObject["name"].toString();
    QString country = cityObject["country"].toString();

    city = city.append(", ").append(country);

    int cityId = (int)cityObject["id"].toDouble();

    CityWeather* temp_city = this->checkCityExistance(cityId, city);

    temp_city->setForecastLoadtime(QDateTime::currentDateTime());
    temp_city->clearForecastData();

    QJsonArray days = info["list"].toArray();

    for(int i = 0; i < days.size(); i++)
    {
        Forecast* temp_forecast = new Forecast(temp_city);

        QJsonObject weather = days[i].toObject();
        QJsonObject temp_info = weather["temp"].toObject();
        QString min_temp = QString::number(temp_info["min"].toDouble());
        QString max_temp = QString::number(temp_info["max"].toDouble());
        QString humidity = QString::number((int)weather["humidity"].toDouble());

        QJsonObject cond = weather["weather"].toArray().first().toObject();
        QString condition = cond["description"].toString();
        QString icon = QString("http://openweathermap.org/img/w/")
                .append(cond["icon"].toString()).append(".png");

        QString windSpeed = QString::number(weather["speed"].toDouble());
        QString gust = "";
        if(weather.contains("gust"))
        {
            gust = QString::number(weather["gust"].toDouble());
        }

        temp_forecast->setIcon(icon);
        temp_forecast->setWind(windSpeed);
        temp_forecast->setMinimumTemperature(min_temp);
        temp_forecast->setMaximumTemperature(max_temp);
        temp_forecast->setHumidity(humidity);
        temp_forecast->setCondition(condition);
        temp_forecast->setGust(gust);
        temp_forecast->setWindDirection(this->degToDirection((int)weather["deg"].toDouble()));
        temp_forecast->setDate(QDateTime::fromTime_t((uint)weather["dt"].toDouble()));

        temp_city->pushForecastDay(temp_forecast);


    }

}

void WeatherInfo::parseSearch(QJsonObject info)
{

    //qDebug() << info.toVariantMap();

    QString city = info["name"].toString();

    QJsonObject weather = info["main"].toObject();
    QString country = info["sys"].toObject()["country"].toString();

    city = city.append(", ").append(country);

    int cityId = (int)info["id"].toDouble();

    CityWeather* temp_city = this->checkCityExistance(cityId, city);

    Forecast* current = dynamic_cast<Forecast*>(temp_city->currentWeather());

    QString temp = QString::number(weather["temp"].toDouble());

    QString humidity = QString::number((int)weather["humidity"].toDouble());

    QJsonObject cond = info["weather"].toArray().first().toObject();
    QString condition = cond["description"].toString();
    QString icon = QString("http://openweathermap.org/img/w/")
            .append(cond["icon"].toString()).append(".png");

    QJsonObject wind = info["wind"].toObject();
    QString windSpeed = QString::number(wind["speed"].toDouble());
    QString gust = "";
    if(wind.contains("gust"))
    {
        gust = QString::number(wind["gust"].toDouble());
    }

   // qDebug() << temp;
   // qDebug() << humidity;
   // qDebug() << weather.toVariantMap();

    current->setIcon(icon);
    current->setWind(windSpeed);
    current->setTemperature(temp);
    current->setHumidity(humidity);
    current->setCondition(condition);
    current->setGust(gust);
    current->setDate(QDateTime::fromTime_t((uint)info["dt"].toDouble()));
    current->setWindDirection(this->degToDirection((int)weather["deg"].toDouble()));

   // qDebug() << current->temperature();
   // qDebug() << current->condition();

//    qDebug() << temp_city->city();

}

void WeatherInfo::parseCurrentWeather(QJsonObject info)
{

    QJsonArray allCities = info["list"].toArray();

    for(int i = 0; i < allCities.size(); i++)
    {

        QJsonObject city = allCities[i].toObject();

        QJsonObject weather = city["main"].toObject();
        QString country = city["sys"].toObject()["country"].toString();
        QString name = city["name"].toString();


        name = name.append(", ").append(country);

        int cityId = (int)city["id"].toDouble();

        CityWeather* temp_city = this->checkCityExistance(cityId, name);

        Forecast* current = dynamic_cast<Forecast*>(temp_city->currentWeather());

        QString temp = QString::number(weather["temp"].toDouble());

        QString humidity = QString::number((int)weather["humidity"].toDouble());

        QJsonObject cond = city["weather"].toArray().first().toObject();
        QString condition = cond["description"].toString();
        QString icon = QString("http://openweathermap.org/img/w/")
                .append(cond["icon"].toString()).append(".png");

        QJsonObject wind = city["wind"].toObject();
        QString windSpeed = QString::number(wind["speed"].toDouble());
        QString gust = "";
        if(wind.contains("gust"))
        {
            gust = QString::number(wind["gust"].toDouble());
        }

        current->setIcon(icon);
        current->setWind(windSpeed);
        current->setTemperature(temp);
        current->setHumidity(humidity);
        current->setCondition(condition);
        current->setGust(gust);
        current->setDate(QDateTime::fromTime_t((uint)city["dt"].toDouble()));
        current->setWindDirection(this->degToDirection((int)weather["deg"].toDouble()));

     //   qDebug() << temp;
     //   qDebug() << humidity;
     //   qDebug() << weather.toVariantMap();

//        qDebug() << current->temperature();
  //      qDebug() << current->condition();

    }
}

CityWeather *WeatherInfo::checkCityExistance(int id, QString name)
{
    CityWeather* temp_city;

    temp_city = dynamic_cast<CityWeather*>(this->findCityById(id));

    if(temp_city == NULL)
    {
        temp_city = new CityWeather(this);
        QObject* temp_obj = dynamic_cast<QObject*>(temp_city);
        this->_cities.append( temp_obj);

        this->_city_indexes[name] = _cities.size()-1;
        temp_city->setCity(name);
        temp_city->setCityId(id);
        temp_city->setDetailsUrl(id);
        emit citiesModelChanged();
    }
    return temp_city;
}

QObject *WeatherInfo::findCityByName(QString name)
{
    for(int i = 0; i < _cities.size(); i++)
    {
        CityWeather* current = dynamic_cast<CityWeather*>(_cities.at(i));
        if(current->city() == name)
        {
            return _cities.at(i);
        }
    }

    return NULL;
}

QObject *WeatherInfo::findCityById(int id)
{
    for(int i = 0; i < _cities.size(); i++)
    {
        CityWeather* current = dynamic_cast<CityWeather*>(_cities.at(i));
        if(current->cityId() == id)
        {
            return _cities.at(i);
        }
    }

    return NULL;
}

QString WeatherInfo::degToDirection(int degree)
{
    if(degree >= (360-21) || degree < 22)
    {
        return tr("N");
    }
    else if(degree < 294+45 && degree >= 294)
    {
        return tr("NW");
    }
    else if(degree < 249+45 && degree >= 249 )
    {
        return tr("W");
    }
    else if(degree < 204+45 && degree >= 204 )
    {
        return tr("SW");
    }
    else if(degree < 159+45 && degree >= 159)
    {
        return tr("S");
    }
    else if(degree < 114+45 && degree >= 114)
    {
        return tr("SE");
    }
    else if(degree < (69+45) && degree >= 69)
    {
        return tr("E");
    }
    else if(degree < (23+45) && degree >= (23))
    {
        return tr("NE");
    }

    return "ERR";
}

void WeatherInfo::parseData(QJsonDocument jDoc)
{
    QJsonObject info;
    switch (this->_type) {
    case WeatherInfo::CurrentWeather:

        info = jDoc.object();

        this->parseCurrentWeather(info);

        break;
    case WeatherInfo::CurrentForecast:

        info = jDoc.object();
        this->parseForecast(info);

        break;
    case WeatherInfo::Search:
        info = jDoc.object()["list"].toArray().first().toObject();

        this->parseSearch(info);

        break;
    default:
        break;
    }

}

QUrl WeatherInfo::url() const
{
    return this->m_url;
}

void WeatherInfo::buildUrl()
{

    QString lang = "";
    QString count = "";

    const QString appId = "777684dfa2ab17d6d1b63586e772a256";
    QString baseUrl = "http://api.openweathermap.org/data/2.5/:qType:query:searchType"
                        ":lang"
                        "&units=:units&mode=json:count&APPID=:appId";

    QString qType = "";
    QString searchType = "";
    QString langCode = QLocale::system().name().toLower().left(2);

    //qDebug() << langCode;
    //qDebug() << QLocale::system().name();

    switch (this->_type) {
    case WeatherInfo::CurrentWeather:
        qType = "group?id=";
        lang = "&lang=";
        lang.append(langCode);
        break;
    case WeatherInfo::CurrentForecast:
        qType = "forecast/daily?id=";
        lang = "&lang=";
        lang.append(langCode);
        count = "&cnt=";
        count.append(QString::number(this->_numberOfDays));
        break;
    case WeatherInfo::Search:
        qType = "find?q=";
        searchType = "&type=like";
        break;
    default:
        break;
    }


    setUrl(QUrl(baseUrl.replace(":qType", qType)
                .replace(":query", this->m_query)
                .replace(":units", "metric")
                .replace(":appId", appId)
                .replace(":searchType", searchType)
                .replace(":lang", lang)
                .replace(":count", count)));

    qDebug() << this->url();
}
