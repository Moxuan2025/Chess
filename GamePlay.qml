import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: window
    width: 800
    height: 800
    visible: true
    title: qsTr("国际象棋")

    readonly property int gameStateOngoing: 0
    readonly property int gameStateWhiteWins: 1
    readonly property int gameStateBlackWins: 2
    readonly property int gameStateDraw: 3

    property var selectedPiece: null
    property var highlightedPositions: []
    property bool isWhiteTurn: chessBoard.isWhiteTurn
    property var currentHighlight: null
    property var checkHighlight: null
    property int gameState: gameStateOngoing

    // 计时器属性
    property int whiteTotalTime: 10 * 60 * 1000
    property int blackTotalTime: 10 * 60 * 1000
    property int whiteStepTime: 15 * 1000
    property int blackStepTime: 15 * 1000
    property bool timerActive: true
    property bool gameEnded: false

    // 格式化时间显示
    function formatTime(ms) {
        var minutes = Math.floor(ms / 60000)
        var seconds = Math.floor((ms % 60000) / 1000)
        return minutes.toString().padStart(2, '0') + ":" + seconds.toString().padStart(2, '0')
    }

    // 检查时间是否结束
    function checkTime() {
        if (whiteTotalTime <= 0 || whiteStepTime <= 0) {
            gameEnded = true
            gameState = gameStateBlackWins
            settlementPanel.visible = true
        } else if (blackTotalTime <= 0 || blackStepTime <= 0) {
            gameEnded = true
            gameState = gameStateWhiteWins
            settlementPanel.visible = true
        }
    }

    // 切换回合时重置步时
    function resetStepTime() {
        if (isWhiteTurn) {
            whiteStepTime = 15 * 1000
        } else {
            blackStepTime = 15 * 1000
        }
    }

    // 检查游戏状态
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

    // 更新将军状态
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

    // 游戏计时器
    Timer {
        id: gameTimer
        interval: 100
        running: !gameEnded && timerActive
        repeat: true
        onTriggered: {
            if (isWhiteTurn) {
                whiteTotalTime -= interval
                whiteStepTime -= interval
            } else {
                blackTotalTime -= interval
                blackStepTime -= interval
            }
            checkTime()
        }
    }

    // 菜单栏
    menuBar: MenuBar {
        Menu {
            title: qsTr("游戏")
            MenuItem {
                text: qsTr("新游戏")
                onTriggered: {
                    chessBoard.initializeBoard()
                    chessBoard.setFirstMove(true)
                    gameEnded = false
                    whiteTotalTime = 10 * 60 * 1000
                    blackTotalTime = 10 * 60 * 1000
                    resetStepTime()
                    settlementPanel.visible = false
                    gameState = gameStateOngoing
                    timerActive = true
                }
            }
            MenuItem {
                text: qsTr("暂停/继续")
                onTriggered: timerActive = !timerActive
            }
            MenuItem {
                text: qsTr("退出")
                onTriggered: Qt.quit()
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

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        // 顶部布局 - 黑方倒计时和回合指示器
        RowLayout {
            Layout.fillWidth: true
            spacing: 20

            // 黑方倒计时
            RowLayout {
                spacing: 10
                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "黑方总时间"
                        font.bold: true
                        font.pixelSize: 10
                        color: "black"
                    }
                    Text {
                        text: formatTime(blackTotalTime)
                        font.pixelSize: 12
                        color: blackTotalTime < 60000 ? "red" : "black"
                    }
                }
                ColumnLayout {
                    spacing: 2
                    Text {
                        text: "黑方步时"
                        font.bold: true
                        font.pixelSize: 10
                        color: "black"
                    }
                    Text {
                        text: formatTime(blackStepTime)
                        font.pixelSize: 12
                        color: blackStepTime < 5000 ? "red" : "black"
                    }
                }
            }

            // 回合指示器
            Text {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                text: gameEnded ? "游戏结束" : (isWhiteTurn ? "白方回合" : "黑方回合")
                font.pixelSize: 18
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                color: "#8b0000"
            }

            // 右侧占位符
            Item {
                Layout.preferredWidth: 100
            }
        }

        // 棋盘区域
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.minimumHeight: 400

            Rectangle {
                id: boardContainer
                anchors.fill: parent
                color: "#f0d9b5"

                // 棋盘网格
                Grid {
                    id: chessGrid
                    anchors.centerIn: parent
                    width: Math.min(parent.width, parent.height)
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

                            // 行坐标标签
                            Text {
                                visible: col === 0
                                x: 2
                                y: 2
                                text: 8 - row
                                font.pixelSize: 10
                                font.bold: true
                                color: "#5d432c"
                            }

                            // 列坐标标签
                            Text {
                                visible: row === 7
                                x: parent.width - width - 2
                                y: parent.height - height - 2
                                text: String.fromCharCode(97 + col)
                                font.pixelSize: 10
                                font.bold: true
                                color: "#5d432c"
                            }

                            // 可移动位置高亮
                            Rectangle {
                                id: highlightRect
                                width: chessGrid.width / 16
                                height: width
                                radius: width/2
                                color: "yellow"
                                opacity: 0.5
                                anchors.centerIn: parent
                                visible: !settlementPanel.visible && window.highlightedPositions.some(pos =>
                                    pos.x === col && pos.y === row)
                            }


                            TapHandler {
                                enabled: highlightRect.visible
                                onTapped: {
                                    if (window.selectedPiece && !gameEnded) {
                                        window.currentHighlight = {x: col, y: row}
                                        chessBoard.movePiece(window.selectedPiece, col, row)
                                        window.highlightedPositions = []
                                        window.selectedPiece = null
                                        resetStepTime()
                                    }
                                }
                            }
                        }
                    }
                }

                // 棋子显示
                Repeater {
                    model: chessBoard.pieces
                    z: 100

                    delegate: Item {
                        visible: !modelData.captured
                        property real cellWidth: chessGrid.width / 8
                        property real cellHeight: chessGrid.height / 8

                        x: chessGrid.x + modelData.x * cellWidth
                        y: chessGrid.y + modelData.y * cellHeight
                        width: cellWidth
                        height: cellHeight
                        /*调试信息
                        onStatusChanged: {
                            if (status === Image.Error) {
                                console.error("无法加载棋子图片: ", source, "错误:", errorString)
                            } else if (status === Image.Ready) {
                                console.log("成功加载棋子图片: ", source)
                            }
                        }*/

                        // 棋子图片
                        Image {
                            id: pieceImage
                            anchors.centerIn: parent
                            width: parent.width * 0.8
                            height: width
                            source: getPieceSource(modelData.pieceType, modelData.isWhite)
                            fillMode: Image.PreserveAspectFit

                            function getPieceSource(type, isWhite) {
                                const color = isWhite ? "white" : "black"
                                switch(type) {
                                case ChessPiece.Pawn:   return "qrc:/pieces/pawn_" + color + ".png"
                                case ChessPiece.Rook:   return "qrc:/pieces/rook_" + color + ".png"
                                case ChessPiece.Knight: return "qrc:/pieces/knight_" + color + ".png"
                                case ChessPiece.Bishop: return "qrc:/pieces/bishop_" + color + ".png"
                                case ChessPiece.Queen:  return "qrc:/pieces/queen_" + color + ".png"
                                case ChessPiece.King:   return "qrc:/pieces/king_" + color + ".png"
                                default: return ""
                                }
                            }
                        }


                        TapHandler {
                            onTapped: function(eventPoint) {
                                const isHighlightedPosition = window.highlightedPositions.some(pos =>
                                    pos.x === modelData.x && pos.y === modelData.y
                                )

                                if (isHighlightedPosition) {
                                    eventPoint.accepted = false
                                    return
                                }

                                if (modelData.isWhite === isWhiteTurn && !modelData.captured && !gameEnded) {
                                    window.selectedPiece = modelData
                                    window.highlightedPositions = modelData.willGo()
                                    window.currentHighlight = null
                                }
                            }
                        }
                    }
                }
            }
        }

        // 白方倒计时
        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: 10

            ColumnLayout {
                spacing: 2
                Text {
                    text: "白方总时间"
                    font.bold: true
                    font.pixelSize: 10
                    color: "black"
                }
                Text {
                    text: formatTime(whiteTotalTime)
                    font.pixelSize: 12
                    color: whiteTotalTime < 60000 ? "red" : "black"
                }
            }

            ColumnLayout {
                spacing: 2
                Text {
                    text: "白方步时"
                    font.bold: true
                    font.pixelSize: 10
                    color: "black"
                }
                Text {
                    text: formatTime(whiteStepTime)
                    font.pixelSize: 12
                    color: whiteStepTime < 5000 ? "red" : "black"
                }
            }
        }
    }

    // 将军高亮组件
    Component {
        id: checkHighlightComp
        Rectangle {
            property int xPos
            property int yPos

            x: xPos * (parent.width / 8)
            y: yPos * (parent.height / 8)
            width: parent.width / 8
            height: parent.height / 8
            color: "red"
            opacity: 0.3
            z: 50
        }
    }

    // 游戏结束结算面板
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
        z: 1000

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
                color: {
                    if (gameState === gameStateWhiteWins) return "#f0f0f0"
                    else if (gameState === gameStateBlackWins) return "#222"
                    else return "#e0e0e0"
                }
                radius: 10
                border.color: {
                    if (gameState === gameStateWhiteWins) return "#8b4513"
                    else if (gameState === gameStateBlackWins) return "#d3d3d3"
                    else return "#808080"
                }
                border.width: 4

                Text {
                    anchors.centerIn: parent
                    text: {
                        if (gameState === gameStateWhiteWins) return "白方胜利!"
                        else if (gameState === gameStateBlackWins) return "黑方胜利!"
                        else return "平局!"
                    }
                    font.pixelSize: 46
                    font.bold: true
                    color: {
                        if (gameState === gameStateWhiteWins) return "#8b4513"
                        else if (gameState === gameStateBlackWins) return "#f0f0f0"
                        else return "#333"
                    }
                }
            }

            Button {
                Layout.alignment: Qt.AlignHCenter
                text: "返回菜单"
                font.pixelSize: 24
                onClicked: {
                    chessBoard.initializeBoard()
                    chessBoard.setFirstMove(true)
                    gameEnded = false
                    whiteTotalTime = 10 * 60 * 1000
                    blackTotalTime = 10 * 60 * 1000
                    resetStepTime()
                    settlementPanel.visible = false
                    gameState = gameStateOngoing
                    timerActive = true
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
    // 关于对话框
    Dialog {
        id: aboutDialog
        title: "关于国际象棋"
        anchors.centerIn: parent
        modal: true

        contentItem: Label {
            text: "国际象棋游戏\n版本 1.0\n© 2023"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 18
        }

        standardButtons: Dialog.Ok
    }

    // 连接棋盘信号
    Connections {
        target: chessBoard
        function onPieceMoved() {
            updateCheckState()
            isWhiteTurn = chessBoard.isWhiteTurn
            checkGameState()
            if (gameState !== gameStateOngoing) {
                gameEnded = true
                timerActive = false
            }
        }
    }

    Component.onCompleted: {
        updateCheckState()
        chessBoard.initializeBoard()
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
