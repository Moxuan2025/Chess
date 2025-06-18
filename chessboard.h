#pragma once
#include "chesspiece.h"
//#include <memory>
#include <QObject>
#include <QList>
#include <QVariant>
class ChessBoard : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList pieces READ pieces NOTIFY piecesChanged)

public:
    explicit ChessBoard(QObject *parent = nullptr);
    ChessPiece *pieceAtPosition(int x, int y) const;
    ~ChessBoard();

    QVariantList pieces() const;
    Q_INVOKABLE int pieceCount() const;
    Q_INVOKABLE ChessPiece *pieceAt(int index) const;

signals:
    void piecesChanged();

private:
    void initializeBoard();

    // QList<std::unique_ptr<ChessPiece>> m_pieces;
    QList<ChessPiece *> m_pieces;
};
