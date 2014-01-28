#ifndef WEATHERINFO_H
#define WEATHERINFO_H

#include <QNetworkAccessManager>
#include <QUrl>
#include <QObject>
#include <QHash>
#include <QVariantList>

class QNetworkReply;
class CityWeather;


class WeatherInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int numberOfDays READ numberOfDays WRITE setNumberOfDays NOTIFY numberOfDaysChanged)

    Q_PROPERTY(QList<QObject*> citiesModel READ citiesModel NOTIFY citiesModelChanged)

    Q_PROPERTY(QVariantList searchResultCities READ searchList NOTIFY searchResultCitiesChanged)
    Q_PROPERTY(bool isSearch READ isSearch NOTIFY isSearchChanged)
    Q_ENUMS(QueryType)

public:
    explicit WeatherInfo(QObject *parent=0, QUrl url=QUrl(""));

    void setUrl(QUrl url);

    QUrl url() const;

    QString query() const;
    int numberOfDays() const;
    QList<QObject*> citiesModel();

    void setQuery(QString query);
    void setNumberOfDays(int nod);

    QVariantList searchList() const;

    bool isSearch() const;

    enum QueryType {CurrentWeather, CurrentForecast, Search};

signals:
    void queryChanged();
    void numberOfDaysChanged();
    void isSearchChanged();
    void searchResultCitiesChanged();
    void citiesModelChanged();

    void dataReady(bool isSuccess, bool isServiceError=false);
public slots:
    void startSearch();
    void stopSearch();
    bool downloadData();
    QObject* getCity(QString name);
    bool queryWith(QString query, QueryType type);
    bool refreshCurrentWeather();

    void addCityBack(QString name, int id);
    void addCityFront(QString name, int id);
    void removeCity(QString name);
    void swapCities(QString toSwap, QString target);
    void resetForecastLoadtimes();

    bool repeatLastQuery();

    void setLocationFromSearchList(QString name);
    void clearSearchlist();
private slots:
    void httpFinished();
private:
    void parseData(QJsonDocument jDoc);
    void parseCities(QString data);

    void parseForecast(QJsonObject info);
    void parseSearch(QJsonObject info);
    void parseCurrentWeather(QJsonObject info);

    QObject * findCityByName(QString name, QList<QObject *> cities);

    QString degToDirection(int degree);

    void buildUrl();

    QUrl m_url;
    QString m_query;
    QNetworkAccessManager qnam;
    QNetworkReply *reply;

    QHash<QString, int> _city_indexes;
    QList<QObject *> _cities;

    QVariantList _searchlist;

    bool downloading;
    bool searching;

    QString m_latestData;

    QueryType _type;

    int _numberOfDays;
};

#endif // WEATHERINFO_H
