import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Item {
    id: root
    signal backRequested()

    // 背景设置
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
                    onTapped: root.backRequested()
                }
        }
    }

    StackLayout {
        id: stackLayout
        anchors {
            top: header.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 20
        }
        currentIndex: 0

        // 第一页：局域网帮助
        Item {
            id: wlanPage

            ColumnLayout {
                anchors.fill: parent
                spacing: 20

                // 标题
                Text {
                    text: "局域网连接"
                    font.pixelSize: 36
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    color: "#2a1e0f"
                    font.family: "Microsoft YaHei UI"
                    style: Text.Outline
                    styleColor: "#f9f1dc"  // 添加描边
                    font.weight: Font.Bold
                }

                // 内容
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#f9f1dc"  // 背景色对比度
                    border.color: "#e0a85c"
                    border.width: 2
                    radius: 10
                    opacity: 0.6

                    Text {
                        anchors.fill: parent
                        anchors.margins: 20
                        text: "1. 任意一方选择创建房间，另一个选择加入房间\n\n" +
                              "2. 创建房间的名称随意\n\n" +
                              "3. 加入房间需要输入对方的IP地址\n" +
                              "   (提示：可以打开WIFI配置查看)\n\n" +
                              "4. 创建房间一方执白棋，另一方执黑棋"
                        font.pixelSize: 24
                        wrapMode: Text.WordWrap
                        color: "#2a1e0f"  // 深色文字
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Microsoft YaHei UI"
                        lineHeight: 1.4  // 增加行高
                    }
                }

                // 底部导航
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60

                    // 下一页按钮 (右下角)
                    Rectangle {
                        width: 150
                        height: 50
                        radius: 10
                        color: "#e0a85c"
                        border.width: 2
                        border.color: "#c88c40"
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "下一页"
                                font.pixelSize: 18
                                color: "#2a1e0f"
                                font.family: "Microsoft YaHei UI"
                            }

                            Image {
                                source: "qrc:/pieces/right_arrow.png"
                                width: 25
                                height: 25
                            }
                        }

                        TapHandler {
                            onTapped: stackLayout.currentIndex = 1
                        }
                    }
                }
            }
        }

        // 第二页：NFC帮助
        Item {
            id: nfcPage

            ColumnLayout {
                anchors.fill: parent
                spacing: 20

                // 标题
                Text {
                    text: "NFC连接"
                    font.pixelSize: 36
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    color: "#2a1e0f"
                    font.family: "Microsoft YaHei UI"
                    style: Text.Outline
                    styleColor: "#f9f1dc"  // 添加描边增强可读性
                    font.weight: Font.Bold
                }

                // 内容
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "#f9f1dc"
                    border.color: "#e0a85c"
                    border.width: 2
                    radius: 10
                    opacity: 0.6

                    Text {
                        anchors.fill: parent
                        anchors.margins: 20
                        text: "1. 任意一方选择创建房间，另一个选择加入房间\n\n" +
                              "2. 弹出等待连接对话框时\n\n" +
                              "3. 将两台设备靠近即可连接\n\n" +
                              "4. 创建房间一方执白棋，另一方执黑棋"
                        font.pixelSize: 24
                        wrapMode: Text.WordWrap
                        color: "#2a1e0f"  // 深色文字
                        verticalAlignment: Text.AlignVCenter
                        font.family: "Microsoft YaHei UI"
                        lineHeight: 1.4  // 增加行高
                    }
                }

                // 底部导航
                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 60

                    // 上一页按钮 (左下角)
                    Rectangle {
                        width: 150
                        height: 50
                        radius: 10
                        color: "#e0a85c"
                        border.width: 2
                        border.color: "#c88c40"
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                        }

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Image {
                                source: "qrc:/pieces/left_arrow.png"
                                width: 25
                                height: 25
                            }

                            Text {
                                text: "上一页"
                                font.pixelSize: 18
                                color: "#2a1e0f"
                                font.family: "Microsoft YaHei UI"
                            }
                        }

                        TapHandler {
                            onTapped: stackLayout.currentIndex = 0
                        }
                    }
                }
            }
        }
    }

    // // 底部状态栏
    // Rectangle {
    //     width: parent.width
    //     height: 40
    //     anchors.bottom: parent.bottom
    //     color: "#33000000"
    //     opacity: 0.9

    //     Text {
    //         text: "帮助系统 | " + (stackLayout.currentIndex === 0 ? "局域网连接帮助" : "NFC连接帮助")
    //         color: "white"
    //         anchors.verticalCenter: parent.verticalCenter
    //         anchors.left: parent.left
    //         anchors.leftMargin: 30
    //         font.pixelSize: 14
    //         font.family: "Arial"
    //     }
    // }

    // 处理返回信号
//     Connections {
//         target: root
//         onBackRequested: {
//             // 确保正确返回到 Connect.qml
//             if (stackView.currentItem && stackView.currentItem.objectName === "connectHelp") {
//                 stackView.pop()
//             }
//         }
//     }
 }
