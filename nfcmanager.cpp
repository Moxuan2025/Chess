#include "nfcmanager.h"
#include <QNetworkInterface>
#include <QDebug>
#include <QTimer>

NfcManager::NfcManager(QObject *parent) : QObject(parent), m_manager(new QNearFieldManager(this))
{
    m_timer.setSingleShot(true);
    connect(&m_timer, &QTimer::timeout, this, &NfcManager::handleTimeout);
    retryCount = 0; // 初始化重试计数器
}

bool NfcManager::isHost() const
{
    return m_isHost;
}

void NfcManager::startHost()
{
    m_isHost = true;
    emit isHostChanged(true);

    // 断开所有旧连接
    disconnect(m_manager, &QNearFieldManager::targetDetected, 0, 0);

    // 设置读取模式
    connect(m_manager, &QNearFieldManager::targetDetected, this, &NfcManager::handleDetectedTargetForRead);

    if (!m_manager->startTargetDetection(QNearFieldTarget::NdefAccess)) {
        qWarning() << "Failed to start NFC target detection";
        emit nfcError("Failed to start NFC detection");
        return;
    }

    m_timer.start(60000); // 60秒超时
    qDebug() << "NFC Host started, waiting for device...";
}

void NfcManager::startClient(const QString &textData)
{
    m_textData = textData;
    m_isHost = false;
    emit isHostChanged(false);

    // 断开所有旧连接
    disconnect(m_manager, &QNearFieldManager::targetDetected, 0, 0);

    // 设置写入模式
    connect(m_manager, &QNearFieldManager::targetDetected, this, &NfcManager::handleDetectedTargetForWrite);

    if (!m_manager->startTargetDetection(QNearFieldTarget::NdefAccess)) {
        qWarning() << "Failed to start NFC target detection";
        emit nfcError("Failed to start NFC detection");
        return;
    }

    m_timer.start(30000);
    qDebug() << "NFC Client started, searching for host...";
}

void NfcManager::stopNfc()
{
    m_manager->stopTargetDetection();
    m_timer.stop();
    qDebug() << "NFC stopped";
}

void NfcManager::handleTimeout()
{
    m_manager->stopTargetDetection();
    qDebug() << "NFC operation timed out";

    if (retryCount < 2) {
        retryCount++;
        qDebug() << "Retrying NFC operation... Attempt:" << retryCount;

        // 使用单次定时器延迟重试
        QTimer::singleShot(1000, this, [this]() {
            if (m_isHost) {
                startHost();
            } else {
                startClient(m_textData);
            }
        });
    } else {
        retryCount = 0; // 重置计数器
        emit nfcError("Operation timed out after retries");
    }
}

void NfcManager::handleDetectedTargetForRead(QNearFieldTarget *target)
{
    qDebug() << "NFC tag detected for reading";
    qDebug() << "检测到NFC标签，类型:" << target->type();

    // 检查标签是否支持NDEF
    if (!(target->accessMethods() & QNearFieldTarget::NdefAccess)) {
        qWarning() << "标签不支持NDEF格式";
        emit nfcError("标签格式不支持");
        target->deleteLater();
        stopNfc();
        return;
    }

    if (target->accessMethods() & QNearFieldTarget::NdefAccess) {
        connect(target, &QNearFieldTarget::ndefMessageRead, this, [=](const QNdefMessage &message) {
            qDebug() << "NDEF message received";

            // 处理所有NDEF记录
            for (const QNdefRecord &record : message) {
                if (record.isRecordType<QNdefNfcTextRecord>()) {
                    QNdefNfcTextRecord textRecord(record);
                    emit messageReceived(textRecord.text());
                }
            }

            target->deleteLater();
            stopNfc();
        });

        connect(target, &QNearFieldTarget::error, this, [=](QNearFieldTarget::Error error) {
            qWarning() << "NFC read error:" << error << "| Target:" << target;
            emit nfcError(QString("Read error: %1").arg(error));
            target->deleteLater();
            stopNfc();
        });

        target->readNdefMessages();
    } else {
        qWarning() << "Tag does not support NDEF";
        emit nfcError("Tag does not support NDEF");
        target->deleteLater();
        stopNfc();
    }
}

void NfcManager::handleDetectedTargetForWrite(QNearFieldTarget *target)
{
    qDebug() << "NFC tag detected for writing. Target type:" << target->type();
    qDebug() << "Access methods:" << target->accessMethods();
    qDebug() << "Supported protocols:";

    if (target->accessMethods() & QNearFieldTarget::NdefAccess) {
        // 创建要写入的消息
        QNdefMessage message;
        QNdefNfcTextRecord textRecord;
        textRecord.setText(m_textData);
        textRecord.setEncoding(QNdefNfcTextRecord::Utf8);
        message.append(textRecord);

        // 修复1: 使用正确的信号
        connect(target, &QNearFieldTarget::requestCompleted, this, [=](const QNearFieldTarget::RequestId &id) {
            qDebug() << "Message successfully written to NFC tag";
            emit messageReceived("Data written successfully");
            target->deleteLater();
            stopNfc();
        });

        connect(target,
                &QNearFieldTarget::error,
                this,
                [=](QNearFieldTarget::Error error, const QNearFieldTarget::RequestId &id) {
                    qWarning() << "NFC write error:" << error << "| Target:" << target;
                    emit nfcError(QString("Write error: %1").arg(error));
                    target->deleteLater();
                    stopNfc();
                });

        // 修复2: 使用异步请求方式
        QNearFieldTarget::RequestId requestId = target->writeNdefMessages(QList<QNdefMessage>() << message);

        if (!requestId.isValid()) {
            qWarning() << "Failed to start write operation";
            emit nfcError("Failed to start write operation");
            target->deleteLater();
            stopNfc();
        }
    } else {
        qWarning() << "Tag does not support NDEF writing";
        emit nfcError("Tag does not support writing");
        target->deleteLater();
        stopNfc();
    }
}
