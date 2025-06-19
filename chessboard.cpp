#include "chessboard.h"
#include <QVariant>
#include <QDebug>
ChessBoard::ChessBoard(QObject* parent) : QObject(parent)
{
    initializeBoard();
}

ChessBoard::~ChessBoard()
{
    qDeleteAll(m_pieces);
    m_pieces.clear();
}

/*void ChessBoard::initializeBoard()
{
    //初始化棋盘
    qDeleteAll(m_pieces);
    m_pieces.clear();

    //创黑棋
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Rook, false, 0, 0));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Knight, false, 1, 0));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Bishop, false, 2, 0));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Queen, false, 3, 0));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::King, false, 4, 0));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Bishop, false, 5, 0));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Knight, false, 6, 0));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Rook, false, 7, 0));
    for (int i = 0; i < 8; ++i) {
        m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Pawn, false, i, 1));
    }

    // 创白棋
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Rook, true, 0, 7));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Knight, true, 1, 7));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Bishop, true, 2, 7));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Queen, true, 3, 7));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::King, true, 4, 7));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Bishop, true, 5, 7));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Knight, true, 6, 7));
    m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Rook, true, 7, 7));
    for (int i = 0; i < 8; ++i) {
        m_pieces.push_back(std::make_unique<ChessPiece>(ChessPiece::Pawn, true, i, 6));
    }
}

QVariantList ChessBoard::pieces()
{
    QVariantList list;
    for (int i = 0; i < m_pieces.size(); i++) {
        ChessPiece *piece = m_pieces[i].get();
        list.push_back(QVariant::fromValue(piece));
    }
    return list;
}*/
void ChessBoard::capturePieceAt(int x, int y)
{
    for (ChessPiece* pieces : m_pieces) {
        if (!pieces->isCaptured() && pieces->x() == x && pieces->y() == y) {
            pieces->setCaptured(true);
            break;
        }
    }
}

void ChessBoard::setFirstMove(bool isWhite)
{
    m_isWhiteTurn = isWhite;
    emit turnChanged();
}

void ChessBoard::switchTurn()
{
    m_isWhiteTurn = !m_isWhiteTurn;
    emit turnChanged();
}

void ChessBoard::initializeBoard()
{
    // 清空现有棋子
    for (ChessPiece* piece : m_pieces) {
        delete piece;
    }
    m_pieces.clear();
    m_isWhiteTurn = true; // 重置为先手白方
    emit turnChanged();

    // 创建黑方棋子
    m_pieces.append(new ChessPiece(ChessPiece::Rook, false, 0, 0, this));
    m_pieces.append(new ChessPiece(ChessPiece::Knight, false, 1, 0, this));
    m_pieces.append(new ChessPiece(ChessPiece::Bishop, false, 2, 0, this));
    m_pieces.append(new ChessPiece(ChessPiece::Queen, false, 3, 0, this));
    m_pieces.append(new ChessPiece(ChessPiece::King, false, 4, 0, this));
    m_pieces.append(new ChessPiece(ChessPiece::Bishop, false, 5, 0, this));
    m_pieces.append(new ChessPiece(ChessPiece::Knight, false, 6, 0, this));
    m_pieces.append(new ChessPiece(ChessPiece::Rook, false, 7, 0, this));
    for (int i = 0; i < 8; ++i) {
        m_pieces.append(new ChessPiece(ChessPiece::Pawn, false, i, 1, this));
    }

    // 创建白方棋子
    m_pieces.append(new ChessPiece(ChessPiece::Rook, true, 0, 7, this));
    m_pieces.append(new ChessPiece(ChessPiece::Knight, true, 1, 7, this));
    m_pieces.append(new ChessPiece(ChessPiece::Bishop, true, 2, 7, this));
    m_pieces.append(new ChessPiece(ChessPiece::Queen, true, 3, 7, this));
    m_pieces.append(new ChessPiece(ChessPiece::King, true, 4, 7, this));
    m_pieces.append(new ChessPiece(ChessPiece::Bishop, true, 5, 7, this));
    m_pieces.append(new ChessPiece(ChessPiece::Knight, true, 6, 7, this));
    m_pieces.append(new ChessPiece(ChessPiece::Rook, true, 7, 7, this));
    for (int i = 0; i < 8; ++i) {
        m_pieces.append(new ChessPiece(ChessPiece::Pawn, true, i, 6, this));
    }

    emit piecesChanged();
}

int ChessBoard::pieceCount() const
{
    return m_pieces.size();
}

ChessPiece* ChessBoard::pieceAt(int index) const
{
    if (index >= 0 && index < m_pieces.size()) { return m_pieces[index]; }
    return nullptr;
}
QVariantList ChessBoard::pieces() const
{
    QVariantList list;
    for (ChessPiece* piece : m_pieces) {
        list.append(QVariant::fromValue(piece));
    }
    return list;
} /*
void ChessBoard::movePiece(ChessPiece* piece, int newX, int newY)
{
    if (!piece) return;

    // 检查目标位置是否有对方棋子
    ChessPiece* target = pieceAtPosition(newX, newY);
    if (target && target->isWhite() != piece->isWhite()) {
        // 吃子 - 从列表中移除并删除
        m_pieces.removeOne(target);
        delete target;
        emit piecesChanged(); // 通知QML列表已变更
    }
    if (!piece) {
        qDebug() << "移动失败：棋子为空";
        return;
    }

    //测试代码...
    qDebug() << "尝试移动棋子：" << piece->typeStr() << "(" << piece->x() << "," << piece->y() << ")"
             << "-> (" << newX << "," << newY << ")";

    // 检查目标位置
    if (target) {
        qDebug() << "目标位置有棋子：" << target->typeStr() << (target->isWhite() ? "白" : "黑");

        if (target->isWhite() != piece->isWhite()) {
            qDebug() << "执行吃子操作";
            m_pieces.removeOne(target);
            delete target;
            emit piecesChanged();
        } else {
            qDebug() << "不能吃己方棋子";
        }
    } //...
    // 移动棋子
    piece->go(newX, newY);

    // 切换回合
    switchTurn();

    // 通知QML棋子位置已更新
    emit piecesChanged();
}*/
// ///////////////

void ChessBoard::movePiece(
    ChessPiece* piece, int newX, int newY)
{
    // 检查目标位置是否有棋子
    ChessPiece* targetPiece = pieceAtPosition(newX, newY);
    //  ChessPiece* targetPiece = piece;

    // 如果目标位置有敌方棋子，则吃掉它
    if (targetPiece) {
        targetPiece->setCaptured(true);
    }

    // 移动当前棋子
    piece->go(newX, newY);

    // 切换回合
    switchTurn();

    emit pieceMoved();
} /*
ChessPiece* ChessBoard::pieceAtPosition(int x, int y) const
{
    for (ChessPiece* piece : m_pieces) {
        // 跳过已被俘的棋子
        if (!piece->isCaptured() && piece->x() == x && piece->y() == y) { return piece; }
    }
    return nullptr;
} */
ChessPiece* ChessBoard::pieceAtPosition(
    int x, int y) const
{
    //  qDebug() << "查找位置: (" << x << "," << y << ")";
    int foundCount = 0;

    for (ChessPiece* piece : m_pieces) {
        // 检查位置匹配
        if (!piece->isCaptured() && piece->x() == x && piece->y() == y) {
            //qDebug() << "找到匹配棋子: " << piece->typeStr();
            foundCount++;
            //if (piece)
            //  qDebug() << "OKOKOKinAt\n";
            return piece;
        }
    }

    //qDebug() << "未找到棋子，共检查" << m_pieces.size() << "个棋子";
    return nullptr;
}

/*
void ChessBoard::printBoardState() const
{
    // 创建8x8空棋盘
    QString board[8][8];
    for (int y = 0; y < 8; y++) {
        for (int x = 0; x < 8; x++) {
            board[y][x] = " - ";
        }
    }

    // 用棋子填充棋盘
    for (ChessPiece* piece : m_pieces) {
        if (!piece->isCaptured()) {
            int x = piece->x();
            int y = piece->y();

            QString symbol;
            switch (piece->type()) {
            case ChessPiece::Pawn:
                symbol = "P";
                break;
            case ChessPiece::Rook:
                symbol = "R";
                break;
            case ChessPiece::Knight:
                symbol = "N";
                break;
            case ChessPiece::Bishop:
                symbol = "B";
                break;
            case ChessPiece::Queen:
                symbol = "Q";
                break;
            case ChessPiece::King:
                symbol = "K";
                break;
            default:
                symbol = "?";
            }

            // 添加颜色标记
            symbol = piece->isWhite() ? symbol.toUpper() : symbol.toLower();
            board[y][x] = " " + symbol + " ";
        }
    }

    // 打印棋盘
    qDebug() << "   a  b  c  d  e  f  g  h";
    for (int y = 0; y < 8; y++) {
        QString line = QString::number(8 - y) + " ";
        for (int x = 0; x < 8; x++) {
            line += board[y][x];
        }
        qDebug() << line;
    }
}*/
