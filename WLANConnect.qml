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

    // IP地址输入属性
    property bool showIpInputDialog: false
    property var ipDigits: [1,9,2,1,6,8,0,0,0,0,0,0]

    // 格式化IP地址显示
    function formatIpAddress() {
        return "192.168." +
               ipDigits[6] + "" + ipDigits[7] + "" + ipDigits[8] + "." +
               ipDigits[9] + "" + ipDigits[10] + "" + ipDigits[11];
    }

    // 背景图片设置
    Image {
        anchors.fill: parent
        source: "qrc:/pieces/back.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.7
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
                    roomName = "我的房间"
                    console.log("创建房间:", roomName)
                    createRoomRequested()
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
                    // 初始化IP地址为192.168.000.000格式
                    ipDigits = [1,9,2,1,6,8,0,0,0,0,0,0]
                    showIpInputDialog = true
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

    // IP地址输入对话框
    Rectangle {
        id: ipInputDialog
        visible: showIpInputDialog
        width: Math.min(parent.width * 0.9, 500)
        height: 500
        anchors.centerIn: parent
        color: "#f9f1dc"
        radius: 15
        border.width: 2
        border.color: "#a67c52"
        z: 100

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "输入服务器IP地址"
                font.pixelSize: 24
                Layout.alignment: Qt.AlignHCenter
                font.bold: true
                color: "#5c3c1f"
            }

            // IP地址显示
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                radius: 10
                color: "#f0f0f0"
                border.color: "#a67c52"
                border.width: 1

                Text {
                    id: ipDisplay
                    text: formatIpAddress()
                    font.pixelSize: 28
                    anchors.centerIn: parent
                    color: "#8a5c2e"
                    font.family: "Courier New"
                    font.bold: true
                }
            }

            // 固定IP部分提示
            Text {
                text: "前六位固定为: 192.168"
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
                color: "#5c3c1f"
            }

            // 滑动选择器区域
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "transparent"

                GridLayout {
                    anchors.fill: parent
                    columns: 3
                    columnSpacing: 15
                    rowSpacing: 15

                    // 生成6个数字选择器 (后6位)
                    Repeater {
                        model: 6
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            // 数字标签
                            Text {
                                text: "数字 " + (index + 1)
                                font.pixelSize: 14
                                color: "#5c3c1f"
                                Layout.alignment: Qt.AlignHCenter
                            }

                            // 滑动条
                            Slider {
                                id: slider
                                Layout.fillWidth: true
                                Layout.preferredHeight: 40
                                from: 0
                                to: 9
                                stepSize: 1
                                value: ipDigits[6 + index]
                                snapMode: Slider.SnapAlways

                                background: Rectangle {
                                    x: slider.leftPadding
                                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 4
                                    width: slider.availableWidth
                                    height: implicitHeight
                                    radius: 2
                                    color: "#d3c0a5"

                                    Rectangle {
                                        width: slider.visualPosition * parent.width
                                        height: parent.height
                                        color: "#e0a85c"
                                        radius: 2
                                    }
                                }

                                handle: Rectangle {
                                    x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
                                    y: slider.topPadding + slider.availableHeight / 2 - height / 2
                                    implicitWidth: 30
                                    implicitHeight: 30
                                    radius: 15
                                    color: slider.pressed ? "#c88c40" : "#e0a85c"
                                    border.color: "#a67c52"
                                    border.width: 2

                                    Text {
                                        text: Math.round(slider.value)
                                        anchors.centerIn: parent
                                        font.pixelSize: 16
                                        color: "white"
                                        font.bold: true
                                    }
                                }

                                onValueChanged: {
                                    ipDigits[6 + index] = Math.round(value)
                                }
                            }

                            // 当前值显示
                            Text {
                                text: ipDigits[6 + index]
                                font.pixelSize: 24
                                font.bold: true
                                color: "#5c3c1f"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }

            // 按钮区域
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 30

                // 取消按钮
                Rectangle {
                    width: 120
                    height: 50
                    radius: 10
                    color: "#e0a85c"
                    border.width: 2
                    border.color: "#c88c40"

                    Text {
                        text: "取消"
                        font.pixelSize: 22
                        font.bold: true
                        color: "#2a1e0f"
                        anchors.centerIn: parent
                    }

                    TapHandler {
                        onTapped: showIpInputDialog = false
                    }
                }

                // 确定按钮
                Rectangle {
                    width: 120
                    height: 50
                    radius: 10
                    color: "#e0a85c"
                    border.width: 2
                    border.color: "#c88c40"

                    Text {
                        text: "确定"
                        font.pixelSize: 22
                        font.bold: true
                        color: "#2a1e0f"
                        anchors.centerIn: parent
                    }

                    TapHandler {
                        onTapped: {
                            ipAddress = formatIpAddress()
                            console.log("加入房间:", ipAddress)
                            joinRoomRequested()
                            showIpInputDialog = false
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
