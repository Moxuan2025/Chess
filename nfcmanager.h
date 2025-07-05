#pragma once

#include <QObject>
#include <QNearFieldManager>
#include <QNearFieldTarget>
#include <QTimer>
#include <QDebug>
#include <QNdefMessage>
#include <QNdefNfcTextRecord>
#include <QtQml/qqmlregistration.h>

class NfcManager : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(bool isHost READ isHost NOTIFY isHostChanged)
public:
    explicit NfcManager(QObject *parent = nullptr);

    bool isHost() const;

    Q_INVOKABLE void startHost();
    Q_INVOKABLE void startClient(const QString &textData);
    Q_INVOKABLE void stopNfc();

signals:
    void messageReceived(const QString &message);
    void nfcError(const QString &error);
    void isHostChanged(bool isHost);

private slots:
    void handleTimeout();
    void handleDetectedTargetForRead(QNearFieldTarget *target);
    void handleDetectedTargetForWrite(QNearFieldTarget *target);

private:
    QNearFieldManager *m_manager;
    QTimer m_timer;
    bool m_isHost = false;
    QString m_textData;
    int retryCount = 0; // 添加重试计数器
};
