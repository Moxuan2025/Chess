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
    Q_PROPERTY(bool isWhiteTurn READ isWhiteTurn NOTIFY turnChanged) // 回合属性gf
public:
    explicit ChessBoard(QObject *parent = nullptr);
    ChessPiece *pieceAtPosition(int x, int y) const;
    ~ChessBoard();

    QVariantList pieces() const;
    Q_INVOKABLE int pieceCount() const;
    Q_INVOKABLE ChessPiece *pieceAt(int index) const;
    bool isWhiteTurn() const { return m_isWhiteTurn; } // 新增gf

    // ...
    Q_INVOKABLE void capturePieceAt(int x, int y);
    Q_INVOKABLE void setFirstMove(bool isWhite); // 设置先行方
    Q_INVOKABLE void movePiece(ChessPiece *piece, int newX, int newY); // 移动棋子方法
    //...

    void printBoardState() const; /////////////
        //
signals:
    void piecesChanged();
    void turnChanged(); // 回合改变信号gf
    void pieceMoved();  // 棋子移动信号gf
private:
    void initializeBoard();
    void switchTurn(); // 切换回合gf

    // QList<std::unique_ptr<ChessPiece>> m_pieces;
    QList<ChessPiece *> m_pieces;
    bool m_isWhiteTurn = true; // 回合状态gf
};
