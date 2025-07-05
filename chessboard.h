#pragma once
//#include <memory>
#include <QObject>
#include <QList>
#include <QVariant>
#include <QStack>
#include <QtQml/qqmlregistration.h>
#include "chesspiece.h"
#include "networkmanager.h"

//记录棋子行走，便于悔棋
struct MoveRecord
{
    ChessPiece *piece;           // 被移动的棋子
    QPoint oldPosition;          // 移动前的位置
    ChessPiece *capturedPiece;   // 被吃掉的棋子（如果有）
    QPoint enPassantPointBefore; // 移动前的过路兵标记
    bool wasCaptured;            // 被吃掉棋子原先的状态
};

class ChessBoard : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariantList pieces READ pieces NOTIFY piecesChanged)
    Q_PROPERTY(bool isWhiteTurn READ isWhiteTurn NOTIFY turnChanged) // 回合属性

    QML_ELEMENT
public:
    Q_INVOKABLE void initializeBoard();
    explicit ChessBoard(QObject *parent = nullptr);
    Q_INVOKABLE ChessPiece *pieceAtPosition(int x, int y) const;
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
    bool isWhiteTurn() const { return m_isWhiteTurn; }

    // ...
    Q_INVOKABLE void capturePieceAt(int x, int y);
    Q_INVOKABLE void setFirstMove(bool isWhite); // 设置先行方
    Q_INVOKABLE void movePiece(
        ChessPiece *piece,
        int newX,
        int newY,
        bool isLocalMove = true); // 移动棋子方法，调用go//添加参数便于识别是本地移动还是同步网络
    //...

    void printBoardState() const;

    void setLastPiece(
        ChessPiece *piece)
    {
        m_lastPiece = piece;
    } //记录上次移动的棋子

    ChessPiece *getLsatPiece() { return m_lastPiece; } //获取上次移动棋子
    void setNetworkManager(
        NetworkManager *manager)
    {
        m_networkManager = manager;
    }

    // 处理网络移动
    Q_INVOKABLE void handleNetworkMove(const QPoint &from, const QPoint &to);

    //
signals:
    void piecesChanged();
    void turnChanged();                               // 回合改变信号
    void pieceMoved();                                // 棋子移动信号
    void pieceMovedByNetwork(QPoint from, QPoint to); // 网络移动信号

private:
    // 添加王指针
    ChessPiece *m_whiteKing = nullptr;
    ChessPiece *m_blackKing = nullptr;

    // 添加将军检查方法
    bool isPositionUnderAttack(int x, int y, bool byWhite);

    void switchTurn(); // 切换回合gf

    // QList<std::unique_ptr<ChessPiece>> m_pieces;
    QList<ChessPiece *> m_pieces;
    bool m_isWhiteTurn = true;         // 回合状态
    ChessPiece *m_lastPiece = nullptr; //记录上次移动的棋子

    QStack<MoveRecord> m_moveHistory;
    NetworkManager *m_networkManager = nullptr; // 添加网络管理器指针
};
