#include "chesspiece.h"

ChessPiece::ChessPiece(
    QObject *parent)
    : QObject(parent)

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
    m_type(type);
    m_isWhite(isWhite);
    m_position = QPoint(x, y);
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
