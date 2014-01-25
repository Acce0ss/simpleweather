#ifndef Forecast_H
#define Forecast_H

#include <QObject>
#include <QDateTime>
#include <QStringList>

class Forecast : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QDateTime dateTime READ date NOTIFY dateTimeChanged)
    Q_PROPERTY(QString temperature READ temperature NOTIFY temperatureChanged)
    Q_PROPERTY(QString icon READ icon NOTIFY iconChanged)
    Q_PROPERTY(QString humidity READ humidity NOTIFY humidityChanged)
    Q_PROPERTY(QString condition READ condition NOTIFY conditionChanged)
    Q_PROPERTY(QString wind READ wind NOTIFY windChanged)
    Q_PROPERTY(QString windDirection READ windDirection NOTIFY windDirectionChanged)
    Q_PROPERTY(QString gust READ gust NOTIFY gustChanged)

    Q_PROPERTY(QStringList weatherModel READ weatherModel NOTIFY weatherModelChanged)

public:
    explicit Forecast(QObject *parent = 0);

    QString temperature() const;
    QString condition() const;
    QString humidity() const;
    QString icon() const;
    QString wind() const;
    QString windDirection() const;
    QString gust() const;
    QDateTime date() const;

    QStringList weatherModel();

    void setTemperature(QString temperature);
    void setCondition(QString condition);
    void setHumidity(QString humidity);
    void setWind(QString wind);
    void setGust(QString gust);
    void setWindDirection(QString direction);
    void setIcon(QString icon);
    void setDate(QDateTime date);

signals:
    void temperatureChanged();
    void humidityChanged();
    void iconChanged();
    void conditionChanged();

    void windChanged();
    void windDirectionChanged();
    void gustChanged();
    void dateTimeChanged();

    void weatherModelChanged();
public slots:


private:
    QString _icon;
    QString _temperature;
    QString _condition;
    QString _wind;
    QString _wind_direction;
    QString _gust;
    QString _humidity;

    QDateTime _date;
};

#endif // Forecast_H
