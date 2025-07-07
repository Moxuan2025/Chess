#pragma once

#include <QObject>
#include <QPoint>
#include <QtQml/qqmlregistration.h>

class ChessPiece : public QObject
{
    Q_OBJECT

    /*Q_PROPERTY(int x READ x NOTIFY positionChanged)
    Q_PROPERTY(int y READ y NOTIFY positionChanged)*/
    Q_PROPERTY(bool isWhite READ isWhite CONSTANT)
    Q_PROPERTY(QString type READ typeStr CONSTANT)
    Q_PROPERTY(Type pieceType READ type CONSTANT)

    Q_PROPERTY(int x READ x NOTIFY positionChanged)
    Q_PROPERTY(int y READ y NOTIFY positionChanged)

    Q_PROPERTY(bool captured READ isCaptured NOTIFY capturedChanged) //被俘状态属性

    QML_ELEMENT
public:
    enum Type { None, Pawn, Rook, Knight, Bishop, Queen, King };
    Q_ENUM(Type)

    ChessPiece(QObject *parent = nullptr);
    ChessPiece(Type type, bool isWhite, int x, int y, QObject *parent = nullptr);

    int x() const { return m_position.x(); }
    int y() const { return m_position.y(); }

    bool isWhite() const { return m_isWhite; }
    bool isCaptured() const { return m_captured; } // 被俘状态访问器
    QPoint getPosition() { return m_position; }
    QPoint getLastPosition() { return m_lastPosition; }

    Type type() const;
    QString typeStr() const;

    void setEnPassantPoint(
        QPoint p)
    {
        m_enPassantPoint = p;
    }
    QPoint getEnPassantPoint() { return m_enPassantPoint; }
    void clearEnPassantPoint() { QPoint m_enPassantPoint = QPoint(-1, -1); }

    Q_INVOKABLE void go(bool isPawn, int newX, int newY);
    Q_INVOKABLE void setCaptured(bool captured); // 设置被俘状态方法
    Q_INVOKABLE QList<QPoint> willGo();
    //...

signals:
    void positionChanged(); // 通知棋盘棋子位置改变
    void capturedChanged(); // 通知被俘状态改变
private:
    Type m_type;             //棋子类型
    bool m_isWhite;          //阵营判断
    QPoint m_position;       //当前位置
    QPoint m_lastPosition{}; //上次位置

    bool m_captured = false; // 被俘状态

    QPoint m_enPassantPoint = QPoint(-1, -1); //专门为小兵设计 初始化为无效点
};
