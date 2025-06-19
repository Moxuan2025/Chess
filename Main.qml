import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import Chess 1.0

ApplicationWindow {
    id: window
    width: 640
    height: 640
    visible: true
    title: qsTr("国际象棋棋盘")

    readonly property int gameStateOngoing: 0
        readonly property int gameStateWhiteWins: 1
        readonly property int gameStateBlackWins: 2
        readonly property int gameStateDraw: 3



    property var selectedPiece: null//当前选中的棋子
    property var highlightedPositions: []//需要高亮的格子集合
    property bool isWhiteTurn: chessBoard.isWhiteTurn//轮次
    property var currentHighlight: null //高亮格子具体实现
    property var checkHighlight: null  // 将军高亮标记
        property int gameState: gameStateOngoing


    function checkGameState() {
        // 检查黑王是否存活
        if (chessBoard.blackKing() && chessBoard.blackKing().captured) {
            gameState = gameStateWhiteWins
            settlementPanel.visible = true
            return
        }

        // 检查白王是否存活
        if (chessBoard.whiteKing() && chessBoard.whiteKing().captured) {
            gameState = gameStateBlackWins
            settlementPanel.visible = true
            return
        }

        // 默认游戏继续
        gameState = gameStateOngoing
    }

    // 检查并更新将军状态
    function updateCheckState() {
        // 清除旧的高亮
        if (checkHighlight) {
            checkHighlight.destroy()
            checkHighlight = null
        }

        // 检查白王是否被将军
        if (chessBoard.isKingInCheck(true)) {
            var whiteKing = chessBoard.whiteKing()
            if (whiteKing) {
                createCheckHighlight(whiteKing.x, whiteKing.y)
            }
        }

        // 检查黑王是否被将军
        if (chessBoard.isKingInCheck(false)) {
            var blackKing = chessBoard.blackKing()
            if (blackKing) {
                createCheckHighlight(blackKing.x, blackKing.y)
            }
        }
    }

    // 创建将军高亮标记
       function createCheckHighlight(x, y) {
           checkHighlight = checkHighlightComp.createObject(chessGrid, {
               "xPos": x,
               "yPos": y
           })
       }

       // 内联组件定义 - 避免单独文件
       Component {
           id: checkHighlightComp
           Rectangle {
               property int xPos
               property int yPos

               // 精确位置计算 - 直接使用棋格尺寸
               x: xPos * (parent.width / 8)
               y: yPos * (parent.height / 8)
               width: parent.width / 8
               height: parent.height / 8
               color: "red"
               opacity: 0.3
               z: 50
           }
       }

       Connections {
           target: chessBoard
           function onPieceMoved() {
               updateCheckState()
               isWhiteTurn = chessBoard.isWhiteTurn // 更新回合显示
               checkGameState()
           }
       }

       Component.onCompleted: updateCheckState()


  //  Component.onCompleted: console.log("Piece source: ", p.source)

    // 虚拟键盘
   /* InputPanel {
        id: inputPanel
        z: 99
        x: 0
        y: window.height
        width: window.width

        states: State {
            name: "visible"
            when: inputPanel.active
            PropertyChanges {
                target: inputPanel
                y: window.height - inputPanel.height
            }
        }
        transitions: Transition {
            from: ""
            to: "visible"
            reversible: true
            ParallelAnimation {
                NumberAnimation {
                    properties: "y"
                    duration: 250
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }*/

    // 菜单栏
    menuBar: MenuBar {
        Menu {
            title: qsTr("游戏")
            MenuItem {
                text: qsTr("新游戏 - 白方先行")
                     onTriggered: {
                     chessBoard.initializeBoard();
                 chessBoard.setFirstMove(true);
                     }
                      }
             MenuItem {
              text: qsTr("新游戏 - 黑方先行")
            onTriggered: {
            chessBoard.initializeBoard();
            chessBoard.setFirstMove(false);
                           }
                       }
            MenuItem {
                text: qsTr("退出")
                onTriggered: Qt.quit();
            }
        }
        Menu {
            title: qsTr("视图")
            MenuItem {
                text: qsTr("放大")
                onTriggered: console.log("放大棋盘")
            }
            MenuItem {
                text: qsTr("缩小")
                onTriggered: console.log("缩小棋盘")
            }
        }
        Menu {
            title: qsTr("帮助")
            MenuItem {
                text: qsTr("关于")
                onTriggered: aboutDialog.open()
            }
        }
    }

    // 主内容区 - 国际象棋棋盘
    Rectangle {
        anchors.fill: parent
        color: "#f0d9b5"
        Text {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 10
      //  text: isWhiteTurn ? "白方回合" : "黑方回合"
        text: settlementPanel.visible ? "游戏结束" : (isWhiteTurn ? "白方回合" : "黑方回合")

        font.pixelSize: 20
        font.bold: true
        color: "#8b0000"
                }

        // 棋盘网格
        Grid {
            id: chessGrid
            anchors.centerIn: parent
            width: Math.min(parent.width, parent.height) * 0.9
            height: width
            columns: 8
            rows: 8


            Repeater {
                model: 64
                Rectangle {
                    property int row: Math.floor(index / 8)
                    property int col: index % 8

                    width: chessGrid.width / 8
                    height: chessGrid.height / 8
                    color: (row + col) % 2 === 0 ? "#f0d9b5" : "#b58863"

                    // 坐标标签 - 行
                    Text {
                        visible: col === 0
                        x: 2
                        y: 2
                        text: 8 - row
                        font.pixelSize: 12
                        font.bold: true
                        color: "#5d432c"
                    }

                    // 坐标标签 - 列
                    Text {
                        visible: row === 7
                        x: parent.width - width - 2
                        y: parent.height - height - 2
                        text: String.fromCharCode(97 + col)
                        font.pixelSize: 12
                        font.bold: true
                        color: "#5d432c"
                    }
                    Rectangle{
                        width: chessGrid.width / 16
                        height:width
                        radius: width/2
                        color:"yellow"
                        opacity: 0.5
                        anchors.centerIn: parent
                        visible: !settlementPanel.visible && window.highlightedPositions.some(pos =>
                            pos.x === col && pos.y === row)
                        MouseArea {
                                    anchors.fill: parent
                                    // 在黄色圆点的点击事件中
                                    onClicked: {
                                        if (window.selectedPiece) {
                                        //  console.log("tap in heightlight");
                                           window.currentHighlight = {x: col, y: row};
                                            chessBoard.movePiece(window.selectedPiece, col, row);
                                            window.highlightedPositions = [];
                                            window.selectedPiece = null;
                                        }
                                    }
                              }
                        }
                    }
                }
            }

            // 棋子显示 - 使用网格作为父对象
            Repeater {
                       model: chessBoard.pieces
                       z: 100

                       delegate: Item {
                           visible: !modelData.captured
                           // 计算棋子在网格中的位置
                           property real cellWidth: chessGrid.width / 8
                           property real cellHeight: chessGrid.height / 8

                           x: chessGrid.x + modelData.x * cellWidth
                           y: chessGrid.y + modelData.y * cellHeight
                           width: cellWidth
                           height: cellHeight

                           // 棋子图片
                           Image {
                               id: pieceImage
                               anchors.centerIn: parent
                               width: parent.width * 0.8
                               height: width
                               source: getPieceSource(modelData.pieceType, modelData.isWhite)
                               fillMode: Image.PreserveAspectFit

                               /*调试信息
                               onStatusChanged: {
                                   if (status === Image.Error) {
                                       console.error("无法加载棋子图片: ", source, "错误:", errorString)
                                   } else if (status === Image.Ready) {
                                       console.log("成功加载棋子图片: ", source)
                                   }
                               }*/

                               // 获取棋子资源路径
                               function getPieceSource(type, isWhite) {
                                   const color = isWhite ? "white" : "black";
                                   switch(type) {
                                   case ChessPiece.Pawn:   return "qrc:/pieces/pawn_" + color + ".png";
                                   case ChessPiece.Rook:   return "qrc:/pieces/rook_" + color + ".png";
                                   case ChessPiece.Knight: return "qrc:/pieces/knight_" + color + ".png";
                                   case ChessPiece.Bishop: return "qrc:/pieces/bishop_" + color + ".png";
                                   case ChessPiece.Queen:  return "qrc:/pieces/queen_" + color + ".png";
                                   case ChessPiece.King:   return "qrc:/pieces/king_" + color + ".png";
                                   default: return "";
                                   }
                               }
                              MouseArea {
                                z:0
                                   anchors.fill: parent
                                   propagateComposedEvents: true
                                   onClicked: {
                                     //console.log("tap in chesspiece");
                                     const isHighlightedPosition = window.highlightedPositions.some(pos =>
                                                 pos.x === modelData.x && pos.y === modelData.y
                                             );

                                             if (isHighlightedPosition) {
                                      // console.log("tap in both\n");
                                       mouse.accepted = false;}
                                     // 只能选择当前回合的棋子
                                     if (modelData.isWhite === isWhiteTurn && !modelData.captured) {
                                        window.selectedPiece = modelData;
                                        window.highlightedPositions = modelData.willGo();

                                       window.currentHighlight = null;
                                          }
                               }/*MouseArea {
                                   anchors.fill: parent
                                   onClicked: {
                                       // 选中当前棋子
                                       window.selectedPiece = model;

                                       // 获取可移动位置并转换为 {x, y} 格式
                                       var moves = modelData.willGo();
                                       var positions = [];
                                       for (var i = 0; i < moves.length; i++) {
                                           positions.push({x: moves[i].x, y: moves[i].y});
                                       }

                                       window.highlightedPositions = positions;
                                   }
                               }*/
                           }
                       }
                   }
            }





        // 棋子显示
        /*
        Repeater {
            id: piecesRepeater
            model: chessBoard.pieceCount()

            delegate: Item {
                property ChessPiece piece: chessBoard.pieceAt(index)*/



    // about
    Dialog {
        id: aboutDialog
        title: "关于国际象棋"
        anchors.centerIn: parent
        modal: true

        Label {
            text: "国际象棋棋盘"
            horizontalAlignment: Text.AlignHCenter
        }

        standardButtons: Dialog.Ok
    }
    Rectangle {
        id: settlementPanel
        visible: false
        width: parent.width * 0.8
        height: parent.height * 0.7
        anchors.centerIn: parent
        radius: 20
        color: "#f0f0f0"
        border.color: "#8b4513"
        border.width: 4



        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 30

            // 标题
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "游戏结束"
                font.pixelSize: 48
                font.bold: true
                font.family: "Times New Roman"
                color: "#8b4513"
            }

            // 胜负结果
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: settlementPanel.height * 0.5
                // MODIFIED: 使用新的常量而不是枚举
                color: {
                    if (gameState === gameStateWhiteWins) return "#f0f0f0";
                    else if (gameState === gameStateBlackWins) return "#222";
                    else return "#e0e0e0"; // Draw
                }
                radius: 10
                border.color: {
                    if (gameState === gameStateWhiteWins) return "#8b4513";
                    else if (gameState === gameStateBlackWins) return "#d3d3d3";
                    else return "#808080"; // Draw
                }
                border.width: 4

                Text {
                    anchors.centerIn: parent
                    // MODIFIED: 使用新的常量而不是枚举
                    text: {
                        if (gameState === gameStateWhiteWins) return "白方胜利!";
                        else if (gameState === gameStateBlackWins) return "黑方胜利!";
                        else return "平局!"; // Draw
                    }
                    font.pixelSize: 46
                    font.bold: true
                    color: {
                        if (gameState === gameStateWhiteWins) return "#8b4513";
                        else if (gameState === gameStateBlackWins) return "#f0f0f0";
                        else return "#333"; // Draw
                    }
                }
            }


            Button {
                Layout.alignment: Qt.AlignHCenter
                text: "返回菜单栏"
                font.pixelSize: 24
                onClicked: {
                    //To return Menu

                }
            }
        }
    }



    // 状态栏
    /*footer: ToolBar {
        Label {
            anchors.centerIn: parent
            text: "开局"
            font.italic: true
        }
    }*/



}

}

