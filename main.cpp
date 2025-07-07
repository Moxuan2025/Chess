#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QResource>
#include "chessboard.h"
#include "networkmanager.h"
#include "nfcmanager.h"
int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    // 创建棋盘实例
    ChessBoard board;
    ChessPiece piece;

    NetworkManager networkManager;
    NfcManager nfcManager;
    QQmlApplicationEngine engine;

    board.setNetworkManager(&networkManager);

    engine.rootContext()->setContextProperty("networkManager", &networkManager);
    engine.rootContext()->setContextProperty("nfcManager", &nfcManager);
    engine.rootContext()->setContextProperty("chessBoard", &board);
    engine.rootContext()->setContextProperty("chessPiece", &piece);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Chess", "Main");

    return app.exec();
}
