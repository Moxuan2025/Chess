#pragma once

#include <QObject>
#include <QTcpSocket>
#include <QTcpServer>
#include <QPoint>

class NetworkManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(
        bool isConnected READ isConnected NOTIFY connectedChanged)
public:
    explicit NetworkManager(QObject *parent = nullptr);
    bool isConnected() const;

    Q_INVOKABLE void startServer();
    Q_INVOKABLE void connectToServer(const QString &ip);
    Q_INVOKABLE void sendMove(const QPoint &from, const QPoint &to);

signals:
    void connectedChanged(bool connected);
    void moveReceived(QPoint from, QPoint to);
    void newConnection();

private slots:
    void onNewConnection();
    void onReadyRead();

private:
    QTcpServer *m_server;
    QTcpSocket *m_socket;
    bool m_connected;
};
