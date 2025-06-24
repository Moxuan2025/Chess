// NFC.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: nfcPage
    anchors.fill: parent

    signal backRequested()

    // 对话框显示属性
    property bool showWaitingDialog: false

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
                onTapped: nfcPage.backRequested()
            }
        }

        // 标题文本
        Text {
            text: "NFC连接"
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
        spacing: 150

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
                    console.log("NFC创建房间点击")
                    showWaitingDialog = true
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
                    console.log("NFC加入房间点击")
                    showWaitingDialog = true
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
            text: "NFC连接系统 v1.0.0 | 状态: 准备中"
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 30
            font.pixelSize: 14
            font.family: "Arial"
        }
    }

    // 等待连接对话框
    Rectangle {
        id: waitingDialog
        visible: showWaitingDialog
        width: parent.width * 0.8
        height: 200
        anchors.centerIn: parent
        color: "#f0f0f0"
        radius: 10
        border.width: 2
        border.color: "#a67c52"
        z: 100

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Text {
                text: "请将设备靠近..."
                font.pixelSize: 24
                color: "#2a1e0f"
                Layout.alignment: Qt.AlignHCenter
                font.family: "Microsoft YaHei UI"
            }

            // 取消按钮
            Rectangle {
                Layout.preferredWidth: 120
                Layout.preferredHeight: 30
                radius: 8
                color: "#e0a85c"
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: "取消"
                    font.pixelSize: 20
                    color: "#2a1e0f"
                    anchors.centerIn: parent
                    font.family: "Microsoft YaHei UI"
                }

                TapHandler {
                    onTapped: {showWaitingDialog = false
                    point.accepted = true}
                }
            }
        }
    }

    // 处理返回信号
    onBackRequested: {
        if (typeof stackView !== "undefined") {
            stackView.pop();
        }
    }
}
