#pragma once

#include <QObject>
#include <QPoint>

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

    Q_PROPERTY(bool captured READ isCaptured NOTIFY capturedChanged) //被俘状态属性gf
public:
    enum Type { None, Pawn, Rook, Knight, Bishop, Queen, King };
    Q_ENUM(Type)

    ChessPiece(QObject *parent = nullptr);
    ChessPiece(Type type, bool isWhite, int x, int y, QObject *parent = nullptr);

    int x() const { return m_position.x(); }
    int y() const { return m_position.y(); }
    bool isWhite() const { return m_isWhite; }
    bool isCaptured() const { return m_captured; } // 被俘状态访问器gf

    Type type() const;
    QString typeStr() const;

    Q_INVOKABLE void go(int newX, int newY);
    Q_INVOKABLE void setCaptured(bool captured); // 设置被俘状态方法gf
    Q_INVOKABLE QList<QPoint> willGo();
    //...

signals:
    void positionChanged(); // 通知棋盘棋子位置改变
    void capturedChanged(); // 通知被俘状态改变gf
private:
    Type m_type;
    bool m_isWhite;
    QPoint m_position;
    bool m_captured = false; // 被俘状态gf
};
