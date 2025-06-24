import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: lanConnectionPage
    anchors.fill: parent

    signal backRequested()
    signal createRoomRequested()
    signal joinRoomRequested()
    signal startGameRequested()

    onBackRequested: {
        if (typeof stackView !== "undefined") {
            stackView.pop();
        }
    }

    // 房间信息属性
    property string roomStatus: "未连接"
    property string roomName: "我的房间"
    property string ipAddress: "192.168.1.100"
    property string statusBarText: "局域网连接 | 状态: 准备中"
    property bool isConnected: false

    // 添加输入对话框属性
    property bool showCreateDialog: false
    property bool showJoinDialog: false
    property string inputText: ""

    // 背景图片设置
    Image {
        anchors.fill: parent
        source: "qrc:/pieces/back.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.7
    }

    Rectangle {
        anchors.fill: parent
        color: "#f0d6a0"
        opacity: 0.35
    }

    // 顶部标题栏
    Rectangle {
        id: header
        width: parent.width
        height: 70
        color: "transparent"

        // 返回按钮
        Rectangle {
            width: 40
            height: 40
            radius: 20
            color: "#e0a85c"
            anchors {
                left: parent.left
                leftMargin: 20
                verticalCenter: parent.verticalCenter
            }

            Image {
                anchors.centerIn: parent
                width: 25
                height: 25
                source: "qrc:/pieces/takeback.png"
                fillMode: Image.PreserveAspectFit
            }

            TapHandler {
                onTapped: lanConnectionPage.backRequested()
            }
        }

        // 标题文本
        Text {
            text: "局域网连接"
            font.pixelSize: 32
            font.bold: true
            color: "#f9f1dc"
            anchors.centerIn: parent
            font.family: "Microsoft YaHei UI"
            style: Text.Outline
            styleColor: "#a67c52"
        }
    }

    // 主内容区域
    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.8
        spacing: 30

        // 创建房间按钮
        Rectangle {
            Layout.preferredWidth: 280
            Layout.preferredHeight: 100
            radius: 15
            color: "#e0a85c"
            border.width: 2
            border.color: "#c88c40"
            opacity: 0.85

            RowLayout {
                anchors.centerIn: parent
                spacing: 15

                Image {
                    source: "qrc:/pieces/create.png"
                    width: 40
                    height: 40
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "创建房间"
                    color: "#2a1e0f"
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "Microsoft YaHei UI"
                }
            }

            TapHandler {
                onTapped: {
                    // 打开创建房间输入对话框
                    inputText = ""
                    showCreateDialog = true
                }
            }
        }

        // 加入房间按钮
        Rectangle {
            Layout.preferredWidth: 280
            Layout.preferredHeight: 100
            radius: 15
            color: "#e0a85c"
            border.width: 2
            border.color: "#c88c40"
            opacity: 0.85

            RowLayout {
                anchors.centerIn: parent
                spacing: 15

                Image {
                    source: "qrc:/pieces/join.png"
                    width: 40
                    height: 40
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: "加入房间"
                    color: "#2a1e0f"
                    font.pixelSize: 24
                    font.bold: true
                    font.family: "Microsoft YaHei UI"
                }
            }

            TapHandler {
                onTapped: {
                    // 打开加入房间输入对话框
                    inputText = ""
                    showJoinDialog = true
                }
            }
        }

        // 添加开始对战按钮
        Rectangle {
            id: startGameButton
            Layout.preferredWidth: 280
            Layout.preferredHeight: 80
            Layout.topMargin: 20
            radius: 15
            color: isConnected ? "#e0a85c" : "#aaaaaa"
            border.width: 2
            border.color: "#c88c40"
            opacity: 0.85
            enabled: isConnected

            Text {
                text: "开始对战"
                font.pixelSize: 28
                font.bold: true
                color: isConnected ? "#2a1e0f" : "#666666"
                anchors.centerIn: parent
                font.family: "Microsoft YaHei UI"
            }

            TapHandler {
                enabled: parent.enabled
                onTapped: {
                    console.log("开始对战点击");
                    startGameRequested();
                }
            }
        }

        // 房间信息显示
        Rectangle {
            Layout.preferredWidth: 380
            Layout.preferredHeight: 180
            Layout.topMargin: 20
            radius: 10
            color: "#f9f1dc"
            opacity: 0.8
            border.color: "#a67c52"
            border.width: 2

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 10

                Text {
                    text: "房间信息"
                    font.pixelSize: 22
                    font.bold: true
                    color: "#2a1e0f"
                    Layout.alignment: Qt.AlignHCenter
                }

                GridLayout {
                    columns: 2
                    columnSpacing: 15
                    rowSpacing: 10

                    Text {
                        text: "房间状态:"
                        font.pixelSize: 18
                        color: "#5c3c1f"
                    }
                    Text {
                        text: roomStatus
                        font.pixelSize: 18
                        color: roomStatus === "已连接" ? "green" : "#8a5c2e"
                    }

                    Text {
                        text: "房间名称:"
                        font.pixelSize: 18
                        color: "#5c3c1f"
                    }
                    Text {
                        text: roomName
                        font.pixelSize: 18
                        color: "#8a5c2e"
                    }

                    Text {
                        text: "IP地址:"
                        font.pixelSize: 18
                        color: "#5c3c1f"
                    }
                    Text {
                        text: ipAddress
                        font.pixelSize: 18
                        color: "#8a5c2e"
                    }
                }
            }
        }
    }

    // 底部状态栏
    Rectangle {
        width: parent.width
        height: 40
        anchors.bottom: parent.bottom
        color: "#33000000"
        opacity: 0.9

        Text {
            text: statusBarText
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            font.pixelSize: 14
            font.family: "Arial"
        }
    }

    // 创建房间输入对话框
    Rectangle {
        id: createDialog
        visible: showCreateDialog
        width: parent.width * 0.8
        height: 200
        anchors.centerIn: parent
        color: "#f0f0f0"
        radius: 10
        border.width: 2
        border.color: "#a67c52"
        z: 100

        // 对话框显示时确保输入框获得焦点
        onVisibleChanged: if (visible) createInput.forceActiveFocus()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            Text {
                text: "输入房间名称:"
                font.pixelSize: 20
                Layout.alignment: Qt.AlignHCenter
            }

            TextField {
                id: createInput
                Layout.fillWidth: true
                placeholderText: "例如: 我的国际象棋房间"
                text: inputText
                font.pixelSize: 18
                onTextChanged: inputText = text

                // 禁用软键盘的关键设置
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferNumbers | Qt.ImhNoPredictiveText
                activeFocusOnPress: false
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Button {
                    text: "取消"
                    onClicked: showCreateDialog = false
                }

                Button {
                    text: "确定"
                    onClicked: {
                        if (inputText.trim() !== "") {
                            roomName = inputText
                            console.log("创建房间:", inputText)
                            createRoomRequested()
                            showCreateDialog = false
                        }
                    }
                }
            }
        }
    }

    // 加入房间输入对话框
    Rectangle {
        id: joinDialog
        visible: showJoinDialog
        width: parent.width * 0.8
        height: 200
        anchors.centerIn: parent
        color: "#f0f0f0"
        radius: 10
        border.width: 2
        border.color: "#a67c52"
        z: 100

        // 对话框显示时确保输入框获得焦点
        onVisibleChanged: if (visible) joinInput.forceActiveFocus()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            Text {
                text: "输入服务器IP地址:"
                font.pixelSize: 20
                Layout.alignment: Qt.AlignHCenter
            }

            TextField {
                id: joinInput
                Layout.fillWidth: true
                placeholderText: "例如: 192.168.1.2"
                text: inputText
                font.pixelSize: 18
                onTextChanged: inputText = text

                // 禁用软键盘的关键设置
                inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhPreferNumbers | Qt.ImhNoPredictiveText
                activeFocusOnPress: false
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 20

                Button {
                    text: "取消"
                    onClicked: showJoinDialog = false
                }

                Button {
                    text: "确定"
                    onClicked: {
                        if (inputText.trim() !== "") {
                            ipAddress = inputText
                            console.log("加入房间:", inputText)
                            joinRoomRequested()
                            showJoinDialog = false
                        }
                    }
                }
            }
        }
    }

    // 网络连接管理
    function updateRoomStatus(status, name, ip) {
        roomStatus = status;
        roomName = name || roomName;
        ipAddress = ip || ipAddress;
        statusBarText = "局域网连接 | 状态: " + status;
        isConnected = status === "已连接";
    }

    // 处理网络信号
    Connections {
        target: networkManager

        function onConnectedChanged(connected) {
            updateRoomStatus(connected ? "已连接" : "未连接", roomName, ipAddress);
        }

        function onNewConnection() {
            updateRoomStatus("已连接", roomName, ipAddress);
        }
    }

    // 修改创建房间和加入房间的处理函数
    onCreateRoomRequested: {
        console.log("创建房间点击");
        networkManager.startServer();
        updateRoomStatus("等待连接...", roomName, "本机IP");
        mainWindow.playerColor = "white"
    }

    onJoinRoomRequested: {
        console.log("加入房间点击");
        networkManager.connectToServer(ipAddress);
        updateRoomStatus("连接中...", "加入的房间", ipAddress);
        mainWindow.playerColor = "black"
    }

    onStartGameRequested: {
        stackView.push("GamePlay.qml");
    }
}
