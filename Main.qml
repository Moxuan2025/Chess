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

    // 虚拟键盘
    InputPanel {
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
    }

    // 菜单栏
    menuBar: MenuBar {
        Menu {
            title: qsTr("游戏")
            MenuItem {
                text: qsTr("新游戏")
                onTriggered: console.log("开始新游戏")
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
            z: 1 // 确保在网格上方

            delegate: Item {
                // 关键：设置父对象为网格
                parent: chessGrid

                // 在网格坐标系中定位
                x: model.x * (chessGrid.width / 8)
                y: model.y * (chessGrid.height / 8)
                width: chessGrid.width / 8
                height: chessGrid.height / 8

                // 棋子符号
                Image {
                    anchors.centerIn: parent
                    width: parent.width * 0.8
                    height: width
                    source: {
                        var pieceName = "";
                        var colorPrefix = model.isWhite ? "white" : "black";

                        switch(model.type) {
                        case ChessPiece.Pawn:
                            pieceName = "pawn"; break;
                        case ChessPiece.Rook:
                            pieceName = "rook"; break;
                        case ChessPiece.Knight:
                            pieceName = "knight"; break;
                        case ChessPiece.Bishop:
                            pieceName = "bishop"; break;
                        case ChessPiece.Queen:
                            pieceName = "queen"; break;
                        case ChessPiece.King:
                            pieceName = "king"; break;
                        default:
                            return ""; // 空格无图
                        }

                        return "qrc:/assets/pieces/" + pieceName + "_" + colorPrefix + ".png";
                    }
                    fillMode: Image.PreserveAspectFit
                }
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
    footer: ToolBar {
        Label {
            anchors.centerIn: parent
            text: "开局"
            font.italic: true
        }
    }

    // 字体测试

}
