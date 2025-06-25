import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtMultimedia
import Chess

ApplicationWindow {
    id: window
    width: 800
    height: 800
    visible: true
    title: qsTr("国际象棋")

    //游戏状态
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
    // 初始步时属性
    property int whiteStepTimeInitial: 15 * 1000
    property int blackStepTimeInitial: 15 * 1000

    // 网络移动处理
    function handleNetworkMove(from, to) {
        var piece = chessBoard.pieceAtPosition(from.x, from.y);
        if (piece) {
            chessBoard.movePiece(piece, to.x, to.y);
            // 播放移动音效
            moveSound.play();
        }
    }
    Connections {
        target: networkManager

        function onMoveReceived(from, to) {
            console.log("收到移动:", from, "->", to);
            handleNetworkMove(from, to);
        }
    }
    // 音效属性
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
        running: !gameEnded && timerActive //
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
        anchors.topMargin: 60
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
                    color: "#8b0000"
                    radius: 5
                    border.width: 1
                    border.color: "#5a0000"
                }


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
                    // 投降逻辑: 发送投降操作数据给对手+本地处理
                    // networkManager.sendOperation(SurrenderRequest);
                    networkManager.sendOperation(NetworkManager.SurrenderRequest);
                    gameState =  playerColor=="white"? gameStateBlackWins : gameStateWhiteWins;
                    settlementPanel.visible = true;
                }
            }


            // 悔棋按钮
            Button {
                id: undoButton
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                palette.buttonText: "white"

                background: Rectangle {
                    color: "dodgerblue"
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
                    networkManager.sendOperation(NetworkManager.UndoRequest);
                   /* if (chessBoard.undoMove) {
                        chessBoard.undoMove()
                        window.selectedPiece = null
                        window.highlightedPositions = []
                        window.isWhiteTurn = chessBoard.isWhiteTurn
                    }*/
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
                    networkManager.sendOperation(NetworkManager.DrawRequest);
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
        visible: true

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

                transform: [
                    Scale {
                        id: boardScale
                        origin.x: boardContainer.width /2
                        origin.y: boardContainer.height /2
                        xScale: mainWindow.playerColor === "black" ? -1 : 1
                        yScale: mainWindow.playerColor === "black" ? -1 : 1
                    }
                ]

                // 棋盘网格
                Grid {
                    id: chessGrid
                    flow: Grid.LeftToRight
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
                                text: mainWindow.playerColor === "black" ? (8 - row) : (1 + row)
                                font.pixelSize: 10
                                font.bold: true
                                color: "#5d432c"
                                transform: [
                                    Scale {
                                        xScale: mainWindow.playerColor === "black" ? -1 : 1
                                        yScale: mainWindow.playerColor === "black" ? -1 : 1
                                    }
                                ]
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
                                transform: [
                                    Scale {
                                        xScale: mainWindow.playerColor === "black" ? -1 : 1
                                        yScale: mainWindow.playerColor === "black" ? -1 : 1
                                    }
                                ]
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
                                        chessBoard.movePiece(window.selectedPiece, col, row, true)

                                        // 播放移动音效
                                        moveSound.play()

                                        window.highlightedPositions = []
                                        window.selectedPiece = null
                                        resetStepTimeWithRoomSettings()
                                    }
                                }
                            }
                            function handleNetworkMove(from, to) {
                                var piece = chessBoard.pieceAtPosition(from.x, from.y);
                                if (piece) {
                                    // 执行移动
                                    chessBoard.handleNetworkMove(from, to);

                                    // 播放音效
                                    moveSound.play();

                                    // 更新UI状态
                                    window.selectedPiece = null;
                                    window.highlightedPositions = [];
                                    window.resetStepTime();
                                    // 重置步时 - 使用创建房间时选择的步时设置
                                    resetStepTimeWithRoomSettings();
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

                        transform: [
                            Scale {
                                origin.x: pieceImage.width*0.6
                                origin.y: pieceImage.height*0.6
                                xScale: mainWindow.playerColor === "black" ? -1 : 1
                                yScale: mainWindow.playerColor === "black" ? -1 : 1
                            }
                        ]

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
                                // 检查玩家是否有权操作该棋子
                                if (mainWindow.playerColor === "white" && !modelData.isWhite) return;
                                if (mainWindow.playerColor === "black" && modelData.isWhite) return;

                                const isHighlightedPosition = window.highlightedPositions.some(pos =>
                                    pos.x === modelData.x && pos.y === modelData.y
                                )

                                if (isHighlightedPosition) {
                                    eventPoint.accepted = false
                                    return
                                }

                                if (modelData.isWhite === window.isWhiteTurn && !modelData.captured && !gameEnded) {
                                    window.selectedPiece = modelData
                                    window.highlightedPositions = modelData.willGo()
                                    window.currentHighlight = null
                                }
                                // 发送移动信息给对手
                                if (networkManager.connected) {
                                    networkManager.sendMove(Qt.point(modelData.x, modelData.y), Qt.point(col, row));
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
            // 音效开关按钮
            Button {
                id: soundButton
                text: soundEnabled ? "🔊" : "🔇"
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                palette.buttonText: "white"
                Layout.alignment: Qt.AlignLeft

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


    // 使用房间设置重置步时
    function resetStepTimeWithRoomSettings() {
        if (isWhiteTurn) {
            whiteStepTime = whiteStepTimeInitial;
        } else {
            blackStepTime = blackStepTimeInitial;
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

    Dialog {
            id: operationDialog
            anchors.centerIn: parent
            width: parent.width * 0.7
            height: 200
            modal: true
            title: ""
            standardButtons: Dialog.Yes | Dialog.No

            property int operationType: -1

            contentItem: ColumnLayout {
                spacing: 20
                Text {
                    id: dialogText
                    text: ""
                    font.pixelSize: 20
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            onAccepted: {
                if (operationType === NetworkManager.UndoRequest) {
                    networkManager.sendOperation(NetworkManager.UndoResponse, true);
                    chessBoard.undoMove();
                } else if (operationType === NetworkManager.DrawRequest) {
                    networkManager.sendOperation(NetworkManager.DrawResponse, true);
                    gameState = gameStateDraw;
                    settlementPanel.visible = true;
                }
            }

            onRejected: {
                if (operationType === NetworkManager.UndoRequest) {
                    networkManager.sendOperation(NetworkManager.UndoResponse, false);
                } else if (operationType === NetworkManager.DrawRequest) {
                    networkManager.sendOperation(NetworkManager.DrawResponse, false);
                }
            }
        }

        // 添加操作接收处理
        Connections {
            target: networkManager

            function onOperationReceived(operation, response) {
                console.log("收到操作:", operation, "响应:", response);

                switch(operation) {
                case NetworkManager.SurrenderRequest://投降
                    // 对方投降，我方胜利
                    gameState = mainWindow.playerColor == "white" ?
                        gameStateWhiteWins : gameStateBlackWins;//根据棋手阵营判断输赢
                    settlementPanel.visible = true;
                    break;

                case NetworkManager.UndoRequest://悔棋请求
                    operationDialog.title = "悔棋请求";
                    dialogText.text = "对方请求悔棋，是否同意？";
                    operationDialog.operationType = operation;
                    operationDialog.open();
                    break;

                case NetworkManager.DrawRequest://和棋请求
                    operationDialog.title = "和棋请求";
                    dialogText.text = "对方请求和棋，是否同意？";
                    operationDialog.operationType = operation;
                    operationDialog.open();
                    break;

                case NetworkManager.UndoResponse://悔棋请求响应
                    if (response) {
                        chessBoard.undoMove();
                    } else {
                        console.log("对方拒绝了悔棋请求");
                    }
                    break;

                case NetworkManager.DrawResponse://和棋请求响应
                    if (response) {
                        gameState = gameStateDraw;
                        settlementPanel.visible = true;
                    } else {
                        console.log("对方拒绝了和棋请求");
                    }
                    break;
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

        // 设置默认时间为25分钟+25秒模式
        whiteTotalTime = 25 * 60 * 1000
        blackTotalTime = 25 * 60 * 1000
        whiteStepTime = 25 * 1000
        blackStepTime = 25 * 1000
        whiteStepTimeInitial = 25 * 1000
        blackStepTimeInitial = 25 * 1000

        // 直接开始游戏
        startNewGame(false)

        chessBoard.pieceMoved.connect(function() {
            resetStepTimeWithRoomSettings();
            isWhiteTurn = chessBoard.isWhiteTurn;
        });
    }
}
