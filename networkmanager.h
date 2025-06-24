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
    enum OperationType {
        SurrenderRequest, // 投降请求
        UndoRequest,      // 悔棋请求
        DrawRequest,      // 和棋请求
        UndoResponse,     // 悔棋应答
        DrawResponse      // 和棋应答
    };
    Q_ENUM(
        OperationType)
    explicit NetworkManager(QObject *parent = nullptr);
    bool isConnected() const;

    Q_INVOKABLE void startServer();
    Q_INVOKABLE void connectToServer(const QString &ip);
    Q_INVOKABLE void sendMove(const QPoint &from, const QPoint &to);                //发送点位
    Q_INVOKABLE void sendOperation(OperationType operation, bool response = false); //发送操作信息

signals:
    void connectedChanged(bool connected);
    void moveReceived(QPoint from, QPoint to);
    void operationReceived(OperationType operation, bool response);
    void newConnection();

private slots:
    void onNewConnection();
    void onReadyRead();

private:
    QTcpServer *m_server;
    QTcpSocket *m_socket;
    bool m_connected;
};
