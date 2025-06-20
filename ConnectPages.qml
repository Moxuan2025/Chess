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

        // 半透明遮罩层
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
                id: backButton
                width: 50
                height: 50
                radius: 25
                color: "#e0a85c"
                anchors {
                    left: parent.left
                    leftMargin: 20
                    verticalCenter: parent.verticalCenter
                }

                // 返回图标
                Canvas {
                    anchors.centerIn: parent
                    width: 25
                    height: 25
                    onPaint: {
                        var ctx = getContext("2d");
                        ctx.reset();
                        ctx.strokeStyle = "white";
                        ctx.lineWidth = 3;
                        ctx.lineCap = "round";

                        ctx.beginPath();
                        ctx.moveTo(20, 5);
                        ctx.lineTo(5, 12.5);
                        ctx.lineTo(20, 20);
                        ctx.stroke();
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: connectPag.backRequested()
                    hoverEnabled: true
                    onEntered: backButton.color = "#8aafef"
                    onExited: backButton.color = "#7a9fd5"
                }
            }

            // 页面标题
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
                anchors.centerIn: parent
            }
        }

        // 主内容区域
        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: header.height + 30
            anchors.bottomMargin: statusBar.height + 20
            anchors.margins: 20
            spacing: 20

            // 功能按钮区域
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignCenter
                spacing: 20

                // 局域网连接按钮
                Rectangle {
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 80
                    radius: 15
                    color: "#e0a85c"
                    border.color: "#c88c40"
                    border.width: 2
                    opacity: mouseArea1.containsMouse ? 0.9 : 1.0

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        // 局域网图标
                        Canvas {
                            width: 40
                            height: 40
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.strokeStyle = "white";
                                ctx.lineWidth = 2;
                                ctx.lineCap = "round";

                                // 中心点
                                ctx.beginPath();
                                ctx.arc(width/2, height/2, 5, 0, Math.PI * 2);
                                ctx.stroke();

                                // 连接线
                                ctx.beginPath();
                                ctx.moveTo(width/2, height/2);
                                ctx.lineTo(4, 4);
                                ctx.stroke();

                                ctx.beginPath();
                                ctx.moveTo(width/2, height/2);
                                ctx.lineTo(width-4, 4);
                                ctx.stroke();

                                ctx.beginPath();
                                ctx.moveTo(width/2, height/2);
                                ctx.lineTo(4, height-4);
                                ctx.stroke();

                                ctx.beginPath();
                                ctx.moveTo(width/2, height/2);
                                ctx.lineTo(width-4, height-4);
                                ctx.stroke();
                            }
                        }

                        Text {
                            text: "局域网连接"
                            color: "white"
                            font.pixelSize: 22
                            font.bold: true
                            font.family: "Arial"
                        }
                    }

                    MouseArea {
                        id: mouseArea1
                        anchors.fill: parent
                        onClicked: console.log("局域网连接点击")
                        hoverEnabled: true
                    }
                }

                // NFC连接按钮
                Rectangle {
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 80
                    radius: 15
                    color: "#e0a85c"
                    border.color: "#c88c40"
                    border.width: 2
                    opacity: mouseArea2.containsMouse ? 0.9 : 1.0

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        // NFC图标
                        Canvas {
                            width: 40
                            height: 40
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.strokeStyle = "white";
                                ctx.lineWidth = 2;
                                ctx.lineCap = "round";

                                // 波浪线
                                ctx.beginPath();
                                ctx.moveTo(4, 20);
                                for (var i = 0; i < 3; i++) {
                                    ctx.bezierCurveTo(
                                        4 + i*12 + 4, 8,
                                        4 + i*12 + 8, 32,
                                        4 + i*12 + 12, 20
                                    );
                                }
                                ctx.stroke();
                            }
                        }

                        Text {
                            text: "NFC连接"
                            color: "white"
                            font.pixelSize: 22
                            font.bold: true
                            font.family: "Arial"
                        }
                    }

                    MouseArea {
                        id: mouseArea2
                        anchors.fill: parent
                        onClicked: console.log("NFC连接点击")
                        hoverEnabled: true
                    }
                }

                // 连接记录按钮
                Rectangle {
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 80
                    radius: 15
                    color: "#e0a85c"
                    border.color: "#c88c40"
                    border.width: 2
                    opacity: mouseArea3.containsMouse ? 0.9 : 1.0

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        // 历史记录图标
                        Canvas {
                            width: 40
                            height: 40
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.strokeStyle = "white";
                                ctx.lineWidth = 2;
                                ctx.lineCap = "round";

                                // 圆
                                ctx.beginPath();
                                ctx.arc(width/2, height/2, 14, 0, Math.PI * 2);
                                ctx.stroke();

                                // 指针
                                ctx.beginPath();
                                ctx.moveTo(width/2, height/2);
                                ctx.lineTo(width/2 + 10, height/2 + 10);
                                ctx.stroke();

                                ctx.beginPath();
                                ctx.moveTo(width/2, height/2);
                                ctx.lineTo(width/2, height/2 - 10);
                                ctx.stroke();
                            }
                        }

                        Text {
                            text: "连接记录"
                            color: "white"
                            font.pixelSize: 22
                            font.bold: true
                            font.family: "Arial"
                        }
                    }

                    MouseArea {
                        id: mouseArea3
                        anchors.fill: parent
                        onClicked: console.log("连接记录点击")
                        hoverEnabled: true
                    }
                }

                // 帮助按钮
                Rectangle {
                    Layout.preferredWidth: 300
                    Layout.preferredHeight: 80
                    radius: 15
                    color: "#e0a85c"
                    border.color: "#c88c40"
                    border.width: 2
                    opacity: mouseArea4.containsMouse ? 0.9 : 1.0

                    RowLayout {
                        anchors.centerIn: parent
                        spacing: 15

                        // 帮助图标
                        Canvas {
                            width: 40
                            height: 40
                            onPaint: {
                                var ctx = getContext("2d");
                                ctx.reset();
                                ctx.strokeStyle = "white";
                                ctx.lineWidth = 2;
                                ctx.lineCap = "round";

                                // 圆圈
                                ctx.beginPath();
                                ctx.arc(width/2, height/2, 14, 0, Math.PI * 2);
                                ctx.stroke();

                                // 问号上半部分
                                ctx.beginPath();
                                ctx.moveTo(width/2, height/2 - 5);
                                ctx.lineTo(width/2, height/2 - 2);
                                ctx.stroke();

                                // 问号点
                                ctx.beginPath();
                                ctx.arc(width/2, height/2 + 8, 2, 0, Math.PI * 2);
                                ctx.fillStyle = "white";
                                ctx.fill();
                            }
                        }

                        Text {
                            text: "连接帮助"
                            color: "white"
                            font.pixelSize: 22
                            font.bold: true
                            font.family: "Arial"
                        }
                    }

                    MouseArea {
                        id: mouseArea4
                        anchors.fill: parent
                        onClicked: console.log("帮助点击")
                        hoverEnabled: true
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
