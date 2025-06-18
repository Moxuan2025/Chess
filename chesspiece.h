#pragma once

#include <QObject>
#include <QPoint>

class ChessPiece : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int x READ x CONSTANT)
    Q_PROPERTY(int y READ y CONSTANT)
    Q_PROPERTY(bool isWhite READ isWhite CONSTANT)
    Q_PROPERTY(QString type READ typeStr CONSTANT)
    Q_PROPERTY(Type pieceType READ type CONSTANT)

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

private:
    Type m_type;
    bool m_isWhite;
    QPoint m_position;
};
