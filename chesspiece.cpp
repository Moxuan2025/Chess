#include "chesspiece.h"
#include <iostream>

ChessPiece::ChessPiece(QObject *parent) : QObject(parent)

{
    m_type = None;
    m_isWhite = false;
    // m_position = (0, 0);
    m_position = QPoint(0, 0);
}

ChessPiece::ChessPiece(
    Type type, bool isWhite, int x, int y, QObject *parent)
    : QObject(parent)

{
    m_type = type;
    m_isWhite = isWhite;
    m_position = QPoint(x, y);
}

ChessPiece::Type ChessPiece::type() const
{
    return m_type;
}

QString ChessPiece::typeStr() const
{
    switch (m_type) {
    case Pawn:
        return "pawn"; //xiaobing
    case Rook:
        return "rook"; //che
    case Knight:
        return "knight"; //ma
    case Bishop:
        return "bishop"; //xiang
    case Queen:
        return "queen"; //wanghou
    case King:
        return "king"; //wang
    default:
        return "none"; //wu
    }
}

void ChessPiece::go(int newX, int newY)
{
    m_position.setX(newX);
    m_position.setY(newY);
}

QList<QPoint> ChessPiece::willgo()
{
    QList<QPoint> possibleMove;

    switch (m_type) {
    case Pawn:
    case Rook:
    case Knight:
    case Bishop:
        for (int i = 1; i < 8; i++) {
            possibleMove.append(QPoint(m_position.x() + i, m_position.y() + i));
            possibleMove.append(QPoint(m_position.x() - i, m_position.y() - i));
            possibleMove.append(QPoint(m_position.x() + i, m_position.y() - i));
            possibleMove.append(QPoint(m_position.x() - i, m_position.y() + i));
        }
    case Queen:
        for (int i = 1; i < 8; i++) {
            possibleMove.append(QPoint(m_position.x() + i, m_position.y() + i));
            possibleMove.append(QPoint(m_position.x() - i, m_position.y() - i));
            possibleMove.append(QPoint(m_position.x() + i, m_position.y() - i));
            possibleMove.append(QPoint(m_position.x() - i, m_position.y() + i));
            possibleMove.append(QPoint(m_position.x() + i, m_position.y()));
            possibleMove.append(QPoint(m_position.x() - i, m_position.y()));
            possibleMove.append(QPoint(m_position.x(), m_position.y() - i));
            possibleMove.append(QPoint(m_position.x(), m_position.y() + i));
        }
    case King:
        possibleMove.append(QPoint(m_position.x() + 1, m_position.y() + 1));
        possibleMove.append(QPoint(m_position.x() - 1, m_position.y() - 1));
        possibleMove.append(QPoint(m_position.x() + 1, m_position.y() - 1));
        possibleMove.append(QPoint(m_position.x() - 1, m_position.y() + 1));
        possibleMove.append(QPoint(m_position.x() + 1, m_position.y()));
        possibleMove.append(QPoint(m_position.x() - 1, m_position.y()));
        possibleMove.append(QPoint(m_position.x(), m_position.y() - 1));
        possibleMove.append(QPoint(m_position.x(), m_position.y() + 1));
    case None:
        break;
    }

    return possibleMove;
    std::cout << "ok";
}
