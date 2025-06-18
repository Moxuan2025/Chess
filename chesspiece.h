#pragma once

#include <QObject>
#include <QPoint>

class ChessPiece : public QObject
{
    Q_OBJECT

    /*Q_PROPERTY(
        int x READ x NOTIFY positionChanged)
    Q_PROPERTY(
        int y READ y NOTIFY positionChanged)*/
    Q_PROPERTY(
        bool isWhite READ isWhite CONSTANT)
    Q_PROPERTY(QString type READ typeStr CONSTANT)
    Q_PROPERTY(Type pieceType READ type CONSTANT)

    Q_PROPERTY(
        int x READ x NOTIFY positionChanged)
    Q_PROPERTY(
        int y READ y NOTIFY positionChanged)
public:
    enum Type { None, Pawn, Rook, Knight, Bishop, Queen, King };
    Q_ENUM(Type)

    ChessPiece(QObject *parent = nullptr);
    ChessPiece(Type type, bool isWhite, int x, int y, QObject *parent = nullptr);

    int x() const { return m_position.x(); }
    int y() const { return m_position.y(); }
    bool isWhite() const { return m_isWhite; }

    Type type() const;
    QString typeStr() const;

    Q_INVOKABLE void go(int newX, int newY);
    Q_INVOKABLE QList<QPoint> willGo();

signals:
    void positionChanged(); // 通知棋盘棋子位置改变

private:
    Type m_type;
    bool m_isWhite;
    QPoint m_position;
};
