#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QResource>
#include "chessboard.h"
#include "networkmanager.h"

int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    //QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);

    // 注册资源文件
    // Q_INIT_RESOURCE(licons);

    // 注册C++类型到QML
    qmlRegisterType<ChessPiece>("Chess", 1, 0, "ChessPiece");
    qmlRegisterType<ChessBoard>("Chess", 1, 0, "ChessBoard");
    //qmlRegisterType<NetworkManager>("Chess", 1, 0, "NetworkManger");
    qmlRegisterType<NetworkManager>("Chess", 1, 0, "NetworkManager");

    // 注册枚举类型
    //qmlRegisterUncreatableType<NetworkManager>("Chess", 1, 0, "GameOperation", "Connot creat");
    qmlRegisterUncreatableMetaObject(NetworkManager::staticMetaObject,
                                     "Chess",
                                     1,
                                     0,
                                     "GameOperation",
                                     "Cannot create GameOperation type");

    // 创建棋盘实例
    ChessBoard board;

    NetworkManager networkManager;
    QQmlApplicationEngine engine;

    board.setNetworkManager(&networkManager);

    engine.rootContext()->setContextProperty("networkManager", &networkManager);
    engine.rootContext()->setContextProperty("chessBoard", &board);
    // engine.rootContext()->setContextProperty("networkManager", &networkManager);
    // engine.rootContext()->setContextProperty("chessBoard", &board);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Chess", "Main");

    return app.exec();
}
