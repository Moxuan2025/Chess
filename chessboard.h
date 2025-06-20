#pragma once
#include "chesspiece.h"
//#include <memory>
#include <QObject>
#include <QList>
#include <QVariant>
#include <QStack>

//记录棋子行走，便于悔棋
struct MoveRecord
{
    ChessPiece *piece;           // 被移动的棋子
    QPoint oldPosition;          // 移动前的位置
    ChessPiece *capturedPiece;   // 被吃掉的棋子（如果有）
    QPoint enPassantPointBefore; // 移动前的过路兵标记
    bool wasCaptured;            // 被吃掉的棋子原先的捕获状态
};

class ChessBoard : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList pieces READ pieces NOTIFY piecesChanged)
    Q_PROPERTY(bool isWhiteTurn READ isWhiteTurn NOTIFY turnChanged) // 回合属性gf
public:
    explicit ChessBoard(QObject *parent = nullptr);
    ChessPiece *pieceAtPosition(int x, int y) const;
    ~ChessBoard();

    Q_INVOKABLE void undoMove(); //悔棋

    //检测将军
    Q_INVOKABLE bool isKingInCheck(bool isWhite);
    Q_INVOKABLE ChessPiece *whiteKing() const { return m_whiteKing; }
    Q_INVOKABLE ChessPiece *blackKing() const { return m_blackKing; }
    //轮次
    QVariantList pieces() const;
    Q_INVOKABLE int pieceCount() const;
    Q_INVOKABLE ChessPiece *pieceAt(int index) const;
    bool isWhiteTurn() const { return m_isWhiteTurn; } // 新增gf

    // ...
    Q_INVOKABLE void capturePieceAt(int x, int y);
    Q_INVOKABLE void setFirstMove(bool isWhite); // 设置先行方
    Q_INVOKABLE void movePiece(ChessPiece *piece, int newX, int newY); // 移动棋子方法，调用go
    //...

    void printBoardState() const; /////////////

    void setLastPiece(
        ChessPiece *piece)
    {
        m_lastPiece = piece;
    } //记录上次移动的棋子

    ChessPiece *getLsatPiece() { return m_lastPiece; } //获取上次移动棋子
    //
signals:
    void piecesChanged();
    void turnChanged(); // 回合改变信号gf
    void pieceMoved();  // 棋子移动信号gf
private:
    // 添加王指针
    ChessPiece *m_whiteKing = nullptr;
    ChessPiece *m_blackKing = nullptr;

    // 添加将军检查方法
    bool isPositionUnderAttack(int x, int y, bool byWhite);

    void initializeBoard();
    void switchTurn(); // 切换回合gf

    // QList<std::unique_ptr<ChessPiece>> m_pieces;
    QList<ChessPiece *> m_pieces;
    bool m_isWhiteTurn = true; // 回合状态gf
    ChessPiece *m_lastPiece = nullptr; //记录上次移动的棋子

    QStack<MoveRecord> m_moveHistory;
};
