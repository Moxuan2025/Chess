import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtMultimedia

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
    property bool showTimeSelection: true

    // 音效属性 - 只保留移动音效
    property bool soundEnabled: true
    SoundEffect {
        id: moveSound
        source: "qrc:/pieces/move.wav"     // 移动音效
        volume: soundEnabled ? 1.0 : 0.0
    }

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
        running: !gameEnded && timerActive && !showTimeSelection // 新增条件：不在时间选择界面时运行
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

    // 工具栏 - 包含投降、悔棋、和棋按钮
    ToolBar {
        id: gameToolBar
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.9
        height: 50
        position: ToolBar.Header

        RowLayout {
            anchors.fill: parent
            spacing: 10

            Button {
                id: surrenderButton
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                palette.buttonText: "white"

                background: Rectangle {
                    color: "#8b0000"  // 深红色
                    radius: 5
                    border.width: 1
                    border.color: "#5a0000"
                }

                // 自定义内容区域
                contentItem: Row {
                    spacing: 8
                    anchors.centerIn: parent

                    // 投降图标
                    Image {
                        source: "qrc:/pieces/touxiang.png"
                        width: 24
                        height: 24
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // 投降文本
                    Text {
                        text: "投降"
                        color: "white"
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                onClicked: {
                    // 投降逻辑
                    console.log("玩家选择投降")
                    gameState = isWhiteTurn ? gameStateBlackWins : gameStateWhiteWins
                    settlementPanel.visible = true
                }
            }


            // 悔棋按钮
            Button {
                id: undoButton
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                palette.buttonText: "white"

                background: Rectangle {
                    color: "dodgerblue"  // 道奇蓝
                    radius: 5
                    border.width: 1
                    border.color: "royalblue"
                }


                contentItem: Row {
                    spacing: 8
                    anchors.centerIn: parent

                    // 悔棋图标
                    Image {
                        source: "qrc:/pieces/takeback.png"
                        width: 24
                        height: 24
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // 悔棋文本
                    Text {
                        text: "悔棋"
                        color: "white"
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                onClicked: {
                    // 悔棋逻辑
                    if (chessBoard.undoMove) {
                        chessBoard.undoMove()
                        window.selectedPiece = null
                        window.highlightedPositions = []
                        window.isWhiteTurn = chessBoard.isWhiteTurn
                    }
                }
            }

            // 和棋按钮
            Button {
                id: drawButton
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                palette.buttonText: "white"

                background: Rectangle {
                    color: "limegreen"
                    radius: 5
                    border.width: 1
                    border.color: "forestgreen"
                }


                contentItem: Row {
                    spacing: 8
                    anchors.centerIn: parent

                    // 和棋图标
                    Image {
                        source: "qrc:/pieces/draw.png"
                        width: 24
                        height: 24
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    // 和棋文本
                    Text {
                        text: "和棋"
                        color: "white"
                        font.pixelSize: 16
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                onClicked: {
                    // 和棋逻辑
                    console.log("玩家请求和棋")
                    gameState = gameStateDraw
                    settlementPanel.visible = true
                }
            }

            // 音效开关按钮
            Button {
                id: soundButton
                text: soundEnabled ? "🔊" : "🔇"
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                palette.buttonText: "white"

                background: Rectangle {
                    color: "#555555"
                    radius: 5
                    border.width: 1
                    border.color: "#333333"
                }

                onClicked: {
                    soundEnabled = !soundEnabled
                }
            }
        }
    }

    // 主游戏区域
    ColumnLayout {
        anchors.top: gameToolBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10
        spacing: 10
        visible: !showTimeSelection // 只在非时间选择界面显示

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

                                        // 播放移动音效
                                        moveSound.play()

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

    // 时间选择界面（已添加背景图片）
    Rectangle {
        id: timeSelection
        visible: showTimeSelection

        width: parent.width * 0.8
        height: parent.height * 0.6

        anchors.centerIn: parent
        color: "transparent"
        z: 2000

        radius: 20

        // 背景图片
        Image {
            anchors.fill: parent
            source: "qrc:/pieces/back.jpg"
            fillMode: Image.PreserveAspectCrop
            opacity: 0.9
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: timeSelection.width
                    height: timeSelection.height
                    radius: timeSelection.radius
                }
            }
        }

        // 边框
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            radius: parent.radius
            border.color: "#8b4513"
            border.width: 3
        }

        Rectangle {
            id: innerContainer
            anchors.fill: parent
            anchors.margins: 20
            color: "transparent"

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30

                Text {
                    text: "选择计时模式"
                    font.pixelSize: 32
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    color: "#f9f1dc"
                    font.family: "Microsoft YaHei UI"
                    style: Text.Outline
                    styleColor: "#a67c52"
                    font.weight: Font.Bold
                }

                // 20分钟 + 20秒模式
                Button {
                    text: "20分钟 + 20秒/步"
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "Arial"
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 60

                    background: Rectangle {
                        color: "#e0a85c"
                        radius: 10
                        border.width: 2
                        border.color: "#c88c40"
                        opacity: 0.85
                    }

                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: "#2a1e0f"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    // 使用 TapHandler 替换 MouseArea
                    TapHandler {
                        onTapped: {
                            whiteTotalTime = 20 * 60 * 1000
                            blackTotalTime = 20 * 60 * 1000
                            whiteStepTime = 20 * 1000
                            blackStepTime = 20 * 1000
                            showTimeSelection = false
                            startNewGame(false)
                        }
                    }
                }

                // 25分钟 + 25秒模式
                Button {
                    text: "25分钟 + 25秒/步"
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "Arial"
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 60

                    background: Rectangle {
                        color: "#e0a85c"
                        radius: 10
                        border.width: 2
                        border.color: "#c88c40"
                        opacity: 0.85
                    }

                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: "#2a1e0f"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    // 使用 TapHandler 替换 MouseArea
                    TapHandler {
                        onTapped: {
                            whiteTotalTime = 25 * 60 * 1000
                            blackTotalTime = 25 * 60 * 1000
                            whiteStepTime = 25 * 1000
                            blackStepTime = 25 * 1000
                            showTimeSelection = false
                            startNewGame(false)
                        }
                    }
                }

                // 30分钟 + 30秒模式
                Button {
                    text: "30分钟 + 30秒/步"
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "Arial"
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 60

                    background: Rectangle {
                        color: "#e0a85c"
                        radius: 10
                        border.width: 2
                        border.color: "#c88c40"
                        opacity: 0.85
                    }

                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        color: "#2a1e0f"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    // 使用 TapHandler 替换 MouseArea
                    TapHandler {
                        onTapped: {
                            whiteTotalTime = 30 * 60 * 1000
                            blackTotalTime = 30 * 60 * 1000
                            whiteStepTime = 30 * 1000
                            blackStepTime = 30 * 1000
                            showTimeSelection = false
                            startNewGame(false)
                        }
                    }
                }
            }
        }
    }

    function startNewGame(initBoard) {
        if (initBoard) {
            chessBoard.initializeBoard()
        }
        chessBoard.setFirstMove(true)
        gameEnded = false
        settlementPanel.visible = false
        gameState = gameStateOngoing
        timerActive = true
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
                    //showTimeSelection = true
                    //settlementPanel.visible = false
                    stackView.pop()
                    window.visible = false
                }
            }
        }
    }

    // 关于对话框
    Dialog {
        id: aboutDialog
        title: "关于国际象棋"
        anchors.centerIn: parent
        modal: true

        contentItem: Label {
            text: "国际象棋游戏\n版本 1.0\n© 2025"
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
        chessBoard.initializeBoard()
        updateCheckState()
        showTimeSelection = true
    }
}
