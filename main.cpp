#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "chessboard.h"
#include <QResource>

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

    // 创建棋盘实例
    ChessBoard board;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("chessBoard", &board);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Chess", "Main");

    return app.exec();
}
