#include "chessboard.h"
#include "chesspiece.h"

ChessPiece::ChessPiece(QObject *parent) : QObject(parent)

{
    m_type = None;
    m_isWhite = false;
    m_captured = false;
    // m_position = (0, 0);
    m_position = QPoint(0, 0);
}

ChessPiece::ChessPiece(
    Type type, bool isWhite, int x, int y, QObject *parent)
    : QObject(parent)

{
    m_type = type;
    m_isWhite = isWhite;
    m_captured = false;
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

void ChessPiece::go(
    bool isPawn, int newX, int newY)
{
    ChessBoard *board = qobject_cast<ChessBoard *>(parent());

    if (isPawn && board->getLsatPiece()) {
        if (board->getLsatPiece()->m_enPassantPoint == QPoint(newX, newY))
            board->getLsatPiece()->setCaptured(true);
    }

    m_lastPosition = m_position; //记录上次点位

    m_position.setX(newX);
    m_position.setY(newY);
    emit positionChanged();
    // 通知棋盘棋子已移动
    if (board) {
        board->pieceMoved();
    }

    //过路兵
}

//...
void ChessPiece::setCaptured(bool captured)
{
    if (m_captured != captured) {
        m_captured = captured;
        emit capturedChanged();
    }
}
//...
QList<QPoint> ChessPiece::willGo()
{
    QList<QPoint> possibleMove;

    ChessBoard *board = qobject_cast<ChessBoard *>(parent());
    if (!board)
        return possibleMove;

    switch (m_type) {
    case None:
        break;
    case Pawn: {
        // 兵的移动方向（白棋向上，黑棋向下）
        int dir = m_isWhite ? -1 : 1;

        // 直行一格
        QPoint forward = m_position + QPoint(0, dir);
        if (forward.y() >= 0 && forward.y() <= 7) {
            ChessPiece *target = board->pieceAtPosition(forward.x(), forward.y());
            if (!target) {
                possibleMove.append(forward); // 前方无棋子，可移动
            }
        }

        // 吃子（斜前一格）
        QPoint leftDiag = m_position + QPoint(-1, dir);
        if (leftDiag.x() >= 0 && leftDiag.y() >= 0 && leftDiag.y() <= 7) {
            ChessPiece *leftTarget = board->pieceAtPosition(leftDiag.x(), leftDiag.y());
            if (leftTarget && leftTarget->isWhite() != m_isWhite) {
                possibleMove.append(leftDiag); // 斜左前方有敌方棋子，可吃
            }
        }

        QPoint rightDiag = m_position + QPoint(1, dir);
        if (rightDiag.x() <= 7 && rightDiag.y() >= 0 && rightDiag.y() <= 7) {
            ChessPiece *rightTarget = board->pieceAtPosition(rightDiag.x(), rightDiag.y());
            if (rightTarget && rightTarget->isWhite() != m_isWhite) {
                possibleMove.append(rightDiag); // 斜右前方有敌方棋子，可吃
            }
        }

        // 初始两步移动（未移动过）
        bool isInitialPosition = (!m_isWhite && m_position.y() == 1)
                                 || (m_isWhite && m_position.y() == 6);
        if (isInitialPosition) {
            QPoint twoSteps = m_position + QPoint(0, dir * 2);
            ChessPiece *firstStep = board->pieceAtPosition(m_position.x(), m_position.y() + dir);
            ChessPiece *secondStep = board->pieceAtPosition(twoSteps.x(), twoSteps.y());
            if (!firstStep && !secondStep) {
                possibleMove.append(twoSteps); // 初始两步且路径畅通
            }
        }

        //吃过路兵
        //if (m_position.y() == enPassantRow) {
        // 检查左右两侧是否有敌方兵
        for (int dx : {-1, 1}) {
            int x = m_position.x() + dx;
            int y = m_position.y();

            if (x >= 0 && x <= 7) {
                ChessPiece *adjacentPiece = board->pieceAtPosition(x, y);

                // 检查是否是敌方兵且刚移动两步
                if (adjacentPiece && adjacentPiece->type() == Pawn
                    && adjacentPiece->isWhite() != m_isWhite
                    && (adjacentPiece == board->getLsatPiece())) {
                    // 添加吃过路兵位置
                    if (abs(adjacentPiece->m_position.y() - adjacentPiece->m_lastPosition.y()) == 2)
                        possibleMove.append(QPoint(x, y + dir));
                    //被吃过路兵捕获逻辑在go中
                }
            }
        }
        // }

        break;
    }
    case Rook: {
        static const QPoint directions[] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
        for (const QPoint &dir : directions) {     //上下左右四个方向
            for (int step = 1; step < 8; ++step) { //棋盘边界限制
                QPoint nextPos = m_position + dir * step;
                if (nextPos.x() < 0 || nextPos.x() > 7 || nextPos.y() < 0
                    || nextPos.y() > 7) //棋盘边界检查
                    break;

                ChessPiece *target = board->pieceAtPosition(nextPos.x(),
                                                            nextPos.y()); //探寻索引（检查下一个格子）
                if (!target) {
                    possibleMove.append(nextPos); //没有棋子则可以移动，添加到可以移动队列
                } else {
                    if (target->isWhite() != m_isWhite) {
                        possibleMove.append(nextPos); // 敌方棋子阻挡也可以占据（吃子）
                    }
                    break; // 遇到任意棋子停止该方向
                }
            }
        }
        break;
    }
    case Knight: {
        // 马的移动规则（"日"字型）
        static const QPoint knightMoves[]
            = {{1, 2}, {2, 1}, {2, -1}, {1, -2}, {-1, -2}, {-2, -1}, {-2, 1}, {-1, 2}};

        for (const QPoint &move : knightMoves) {
            QPoint nextPos = m_position + move;
            if (nextPos.x() < 0 || nextPos.x() > 7 || nextPos.y() < 0 || nextPos.y() > 7)
                continue;

            ChessPiece *target = board->pieceAtPosition(nextPos.x(), nextPos.y());
            if (!target || target->isWhite() != m_isWhite) {
                possibleMove.append(nextPos);
            }
        }
        break;
    }
    case Bishop: {
        // 象的移动规则（对角线）
        static const QPoint directions[] = {{1, 1}, {1, -1}, {-1, 1}, {-1, -1}};

        for (const QPoint &dir : directions) {
            for (int step = 1; step < 8; ++step) {
                QPoint nextPos = m_position + dir * step;
                if (nextPos.x() < 0 || nextPos.x() > 7 || nextPos.y() < 0 || nextPos.y() > 7)
                    break;

                ChessPiece *target = board->pieceAtPosition(nextPos.x(), nextPos.y());
                if (!target) {
                    possibleMove.append(nextPos);
                } else {
                    if (target->isWhite() != m_isWhite) {
                        possibleMove.append(nextPos);
                    }
                    break;
                }
            }
        }
        break;
    }
    case Queen: /*
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
        break;*/
    {
        // 后的移动规则（车+象的组合）
        // 水平/垂直方向
        static const QPoint straightDirs[] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};
        // 对角线方向
        static const QPoint diagonalDirs[] = {{1, 1}, {1, -1}, {-1, 1}, {-1, -1}};

        // 处理水平/垂直移动
        for (const QPoint &dir : straightDirs) {
            for (int step = 1; step < 8; ++step) {
                QPoint nextPos = m_position + dir * step;
                if (nextPos.x() < 0 || nextPos.x() > 7 || nextPos.y() < 0 || nextPos.y() > 7)
                    break;

                ChessPiece *target = board->pieceAtPosition(nextPos.x(), nextPos.y());
                if (!target) {
                    possibleMove.append(nextPos);
                } else {
                    if (target->isWhite() != m_isWhite) {
                        possibleMove.append(nextPos);
                    }
                    break;
                }
            }
        }

        // 处理对角线移动
        for (const QPoint &dir : diagonalDirs) {
            for (int step = 1; step < 8; ++step) {
                QPoint nextPos = m_position + dir * step;
                if (nextPos.x() < 0 || nextPos.x() > 7 || nextPos.y() < 0 || nextPos.y() > 7)
                    break;

                ChessPiece *target = board->pieceAtPosition(nextPos.x(), nextPos.y());
                if (!target) {
                    possibleMove.append(nextPos);
                } else {
                    if (target->isWhite() != m_isWhite) {
                        possibleMove.append(nextPos);
                    }
                    break;
                }
            }
        }
        break;
    }
    case King: // 王的移动规则（周围8个方向一格）
        /*
        possibleMove.append(QPoint(m_position.x() + 1, m_position.y() + 1));
        possibleMove.append(QPoint(m_position.x() - 1, m_position.y() - 1));
        possibleMove.append(QPoint(m_position.x() + 1, m_position.y() - 1));
        possibleMove.append(QPoint(m_position.x() - 1, m_position.y() + 1));
        possibleMove.append(QPoint(m_position.x() + 1, m_position.y()));
        possibleMove.append(QPoint(m_position.x() - 1, m_position.y()));
        possibleMove.append(QPoint(m_position.x(), m_position.y() - 1));
        possibleMove.append(QPoint(m_position.x(), m_position.y() + 1));
    case None:*/
        {
            static const QPoint kingMoves[]
                = {{1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}};

            for (const QPoint &move : kingMoves) {
                QPoint nextPos = m_position + move;
                if (nextPos.x() < 0 || nextPos.x() > 7 || nextPos.y() < 0 || nextPos.y() > 7)
                    continue;

                ChessPiece *target = board->pieceAtPosition(nextPos.x(), nextPos.y());
                if (!target || target->isWhite() != m_isWhite) {
                    possibleMove.append(nextPos);
                }
            }

            // TODO: 添加王车易位规则
            break;
        }
    }

    return possibleMove;
}
