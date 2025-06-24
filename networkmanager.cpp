#include "networkmanager.h"
#include <QDebug>

NetworkManager::NetworkManager(
    QObject *parent)
    : QObject(parent)
    , m_server(nullptr)
    , m_socket(nullptr)
    , m_connected(false)
{}

bool NetworkManager::isConnected() const
{
    return m_connected;
}

void NetworkManager::startServer()
{
    if (!m_server) {
        m_server = new QTcpServer(this);
        connect(m_server, &QTcpServer::newConnection, this, &NetworkManager::onNewConnection);
    }

    if (m_server->listen(QHostAddress::Any, 8080)) {
        qDebug() << "Server started on port 8080";
    } else {
        qDebug() << "Server failed to start:" << m_server->errorString();
    }
}

void NetworkManager::connectToServer(
    const QString &ip)
{
    if (m_socket) {
        m_socket->deleteLater();
    }

    m_socket = new QTcpSocket(this);
    connect(m_socket, &QTcpSocket::connected, this, [this]() {
        m_connected = true;
        emit connectedChanged(true);
    });
    connect(m_socket, &QTcpSocket::readyRead, this, &NetworkManager::onReadyRead);

    m_socket->connectToHost(ip, 8080);
}

void NetworkManager::sendMove(
    const QPoint &from, const QPoint &to)
{
    if (!m_socket || !m_connected)
        return;

    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << 1 << from << to;
    m_socket->write(data);
}

void NetworkManager::sendOperation(
    OperationType operation, bool response)
{
    if (!m_socket || !m_connected)
        return;

    QByteArray data;
    QDataStream stream(&data, QIODevice::WriteOnly);
    stream << -1; // 标志位 -1 表示操作数据
    stream << static_cast<int>(operation);
    stream << response;
    m_socket->write(data);
}

void NetworkManager::onNewConnection()
{
    if (m_server->hasPendingConnections()) {
        if (m_socket) {
            m_socket->deleteLater();
        }

        m_socket = m_server->nextPendingConnection();
        connect(m_socket, &QTcpSocket::readyRead, this, &NetworkManager::onReadyRead);
        m_connected = true;
        emit connectedChanged(true);
        emit newConnection();
    }
}

void NetworkManager::onReadyRead()
{
    QDataStream stream(m_socket);

    // 读取标志位
    int flag;
    stream >> flag;

    if (flag == 1) { // 移动数据
        QPoint from, to;
        stream >> from >> to;
        emit moveReceived(from, to);
    } else if (flag == -1) { // 操作数据
        OperationType operation{};
        bool response{};
        stream >> operation;
        stream >> response;
        emit operationReceived(operation, response);
    }
}
