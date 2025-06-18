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


    property var selectedPiece: null
    property var highlightedPositions: []
    property bool isWhiteTurn: chessBoard.isWhiteTurn//gf
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
        text: isWhiteTurn ? "白方回合" : "黑方回合"
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
                        visible: window.highlightedPositions.some(pos =>
                            pos.x === col && pos.y === row)
                        MouseArea {
                                    anchors.fill: parent
                                    // 在黄色圆点的点击事件中
                                    onClicked: {
                                        if (window.selectedPiece) {
                                            // 使用正确的坐标系统
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
        }
        // 棋子显示
        /*
        Repeater {
            id: piecesRepeater
            model: chessBoard.pieceCount()

            delegate: Item {
                property ChessPiece piece: chessBoard.pieceAt(index)*/


        // 棋子显示 - 使用网格作为父对象
        Repeater {
                   model: chessBoard.pieces
                   z: 2

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

                           /* 添加调试信息
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
                               case ChessPiece.Pawn:   return "pieces/pawn_" + color + ".png";
                               case ChessPiece.Rook:   return "pieces/rook_" + color + ".png";
                               case ChessPiece.Knight: return "pieces/knight_" + color + ".png";
                               case ChessPiece.Bishop: return "pieces/bishop_" + color + ".png";
                               case ChessPiece.Queen:  return "pieces/queen_" + color + ".png";
                               case ChessPiece.King:   return "pieces/king_" + color + ".png";
                               default: return "";
                               }
                           }
                          MouseArea {
                            z:3
                               anchors.fill: parent
                               onClicked: {
                                 // 只能选择当前回合的棋子
                                 if (modelData.isWhite === isWhiteTurn && !modelData.captured) {
                                    window.selectedPiece = modelData;
                                    window.highlightedPositions = modelData.willGo();
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

