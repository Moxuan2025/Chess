import QtQuick
import QtQuick.Layouts

Item {
    Item {
        id: connectPag
        anchors.fill: parent

        // 定义返回信号
        signal backRequested()

        // 背景图片设置
        Image {
            id: background
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
                id: backButton
                width: 40
                height: 40
                radius: 20
                color: "#e0a85c"
                anchors {
                    left: parent.left
                    leftMargin: 20
                    verticalCenter: parent.verticalCenter
                }

                // 返回图标 (替换为图片)
                Image {
                    anchors.centerIn: parent
                    width: 25
                    height: 25
                    source: "qrc:/pieces/takeback.png"
                    fillMode: Image.PreserveAspectFit
                }

                TapHandler {
                    onTapped: connectPag.backRequested()
                }
            }

        }

        // 主内容区域
        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: header.height + 30
            anchors.bottomMargin: statusBar.height + 20
            anchors.margins: 20
            spacing: 20

            Text {
                text: "设备连接"
                font.pixelSize: 56
                font.bold: true
                color: "#f9f1dc"
                Layout.alignment: Qt.AlignHCenter
                font.family: "Microsoft YaHei UI"
                style: Text.Outline
                styleColor: "#a67c52"
                font.weight: Font.Bold
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            // 功能按钮区域
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
                spacing: 25

                // 局域网连接按钮
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 70
                    radius: 10
                    color: "#e0a85c"
                    border.width: 2
                    border.color: "#c88c40"
                    opacity: 0.85

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        // 局域网图标
                        Rectangle {
                            width: 40
                            height: 40
                            color: "transparent"

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/pieces/wlan.png"
                                width: Math.min(implicitWidth, 36)
                                height: Math.min(implicitHeight, 36)
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Text {
                            text: "局域网连接"
                            color: "#2a1e0f"
                            font.pixelSize: 24
                            font.bold: true
                            font.family: "Arial"
                        }
                    }

                    TapHandler {
                           onTapped: {
                               console.log("局域网连接点击")
                               stackView.push("WLANConnect.qml")
                           }
                       }

                }

                // NFC连接按钮
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 70
                    radius: 10
                    color: "#e0a85c"
                    border.width: 2
                    border.color: "#c88c40"
                    opacity: 0.85

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        // NFC图标
                        Rectangle {
                            width: 40
                            height: 40
                            color: "transparent"

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/pieces/NFC.png"
                                width: Math.min(implicitWidth, 36)
                                height: Math.min(implicitHeight, 36)
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Text {
                            text: "NFC连接"
                            color: "#2a1e0f"
                            font.pixelSize: 24
                            font.bold: true
                            font.family: "Arial"
                        }
                    }

                    TapHandler {
                        onTapped: stackView.push("Nfc.qml")
                    }                }

                // 连接记录按钮
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 70
                    radius: 10
                    color: "#e0a85c"
                    border.width: 2
                    border.color: "#c88c40"
                    opacity: 0.85

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        // 连接记录图标
                        Rectangle {
                            width: 40
                            height: 40
                            color: "transparent"

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/pieces/connect.png"
                                width: Math.min(implicitWidth, 36)
                                height: Math.min(implicitHeight, 36)
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Text {
                            text: "连接记录"
                            color: "#2a1e0f"
                            font.pixelSize: 24
                            font.bold: true
                            font.family: "Arial"
                        }
                    }

                    TapHandler {
                        onTapped: console.log("连接记录点击")
                    }
                }


                // 帮助按钮
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.preferredHeight: 70
                    radius: 10
                    color: "#e0a85c"
                    border.width: 2
                    border.color: "#c88c40"
                    opacity: 0.85

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        // 帮助图标
                        Rectangle {
                            width: 40
                            height: 40
                            color: "transparent"

                            Image {
                                anchors.centerIn: parent
                                source: "qrc:/pieces/about.png"
                                width: Math.min(implicitWidth, 36)
                                height: Math.min(implicitHeight, 36)
                                fillMode: Image.PreserveAspectFit
                            }
                        }

                        Text {
                            text: "连接帮助"
                            color: "#2a1e0f"
                            font.pixelSize: 24
                            font.bold: true
                            font.family: "Arial"
                        }
                    }

                    TapHandler {
                        onTapped: console.log("帮助点击")
                    }
                }
            }
        }

        // 底部状态栏
        Rectangle {
            id: statusBar
            width: parent.width
            height: 40
            anchors.bottom: parent.bottom
            color: "#33000000"
            opacity: 0.9

            Text {
                text: "设备连接系统 v1.2.0 | 已连接设备: 0"
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 30
                font.pixelSize: 14
                font.family: "Arial"
            }
        }

        // 处理返回信号
        onBackRequested: {
            stackView.pop()
        }
    }
}
