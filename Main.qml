import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

ApplicationWindow {
    id: mainWindow
    width: 800
    height: 700
    visible: true
    title: "国际象棋"
    color: "#1e1e2e"
    property string playerColor: "white"
    // 使用 StackView 管理页面导航
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainMenu
    }

    // ==================== 主菜单页面 ====================
    Component {
        id: mainMenu

        Rectangle {
            id: menuPage
            anchors.fill: parent
            color:"#1e1e2e"

            // 背景图片设置
            Item{
                anchors.fill:parent

                Image {
                    id: background
                    anchors.fill: parent
                    source: "qrc:/pieces/back.jpg"
                    fillMode: Image.PreserveAspectCrop
                    opacity: 0.7
                }
            }

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 30

                Text {
                    text: "国际象棋"
                    font.pixelSize: 56
                    font.bold: true
                    color: "#f9f1dc"
                    Layout.alignment: Qt.AlignHCenter
                    font.family: "Microsoft YaHei UI"
                    style: Text.Outline
                    styleColor: "#a67c52"
                    font.weight: Font.Bold
                }

                Button {
                       id: startButton
                       Layout.preferredWidth: 250
                       Layout.preferredHeight: 70
                       Layout.alignment: Qt.AlignHCenter
                       font.pixelSize: 24
                       font.bold: true
                       font.family: "Arial"

                       background: Rectangle {
                           color: "#e0a85c"
                           radius: 10
                           border.width: 2
                           border.color: "#c88c40"
                           opacity: 0.85
                       }

                       contentItem: Item {
                                      Row {
                                          spacing: 15
                                          anchors.centerIn: parent
                                          Image {
                                              source: "qrc:/pieces/start.png"
                                              width: 28
                                              height: 28
                                              anchors.verticalCenter: parent.verticalCenter
                                          }
                                          Text {
                                              text: "开始游戏"
                                              font: startButton.font
                                              color: "#2a1e0f"
                                              anchors.verticalCenter: parent.verticalCenter
                                          }
                                      }
                                  }

                       onClicked: {
                           stackView.push(connectPage)
                       }
                   }

                   // 连接按钮
                   Button {
                       id: connectButton
                       Layout.preferredWidth: 250
                       Layout.preferredHeight: 70
                       Layout.alignment: Qt.AlignHCenter
                       font.pixelSize: 24
                       font.bold: true
                       font.family: "Arial"

                       background: Rectangle {
                           color: "#e0a85c"
                           radius: 10
                           border.width: 2
                           border.color: "#b88344"
                           opacity: 0.85
                       }

                       contentItem: Item {
                                          Row {
                                              spacing: 15
                                              anchors.centerIn: parent
                                              Image {
                                                  source: "qrc:/pieces/again.png"
                                                  width: 28
                                                  height: 28
                                                  anchors.verticalCenter: parent.verticalCenter
                                              }
                                              Text {
                                                  text: "再战一次"
                                                  font: connectButton.font
                                                  color: "#2a1e0f"
                                                  anchors.verticalCenter: parent.verticalCenter
                                              }
                                          }
                                      }

                       onClicked: {
                           stackView.push(gamePlay)
                       }
                   }

                   // 设置按钮
                   Button {
                       id: settingsButton
                       Layout.preferredWidth: 250
                       Layout.preferredHeight: 70
                       Layout.alignment: Qt.AlignHCenter
                       font.pixelSize: 24
                       font.bold: true
                       font.family: "Arial"

                       background: Rectangle {
                           color: "#e0a85c"
                           radius: 10
                           border.width: 2
                           border.color: "#a67438"
                           opacity: 0.85
                       }

                       contentItem: Item {
                                           Row {
                                               spacing: 15
                                               anchors.centerIn: parent
                                               Image {
                                                   source: "qrc:/pieces/setting.png"
                                                   width: 28
                                                   height: 28
                                                   anchors.verticalCenter: parent.verticalCenter
                                               }
                                               Text {
                                                   text: "游戏设置"
                                                   font: settingsButton.font
                                                   color: "#2a1e0f"
                                                   anchors.verticalCenter: parent.verticalCenter
                                               }
                                           }
                                       }
                       onClicked: {
                           stackView.push(settingsPage)
                       }
                   }

                   // 退出游戏按钮
                   Button {
                       id: exitButton
                       Layout.preferredWidth: 250
                       Layout.preferredHeight: 70
                       Layout.alignment: Qt.AlignHCenter
                       font.pixelSize: 24
                       font.bold: true
                       font.family: "Arial"

                       background: Rectangle {
                           color: "#e0a85c"
                           radius: 10
                           border.width: 2
                           border.color: "#9a642c"
                           opacity: 0.85
                       }

                       contentItem: Item {
                                          Row {
                                              spacing: 15
                                              anchors.centerIn: parent
                                              Image {
                                                  source: "qrc:/pieces/exit.png"
                                                  width: 28
                                                  height: 28
                                                  anchors.verticalCenter: parent.verticalCenter
                                              }
                                              Text {
                                                  text: "退出游戏"
                                                  font: exitButton.font
                                                  color: "#2a1e0f"
                                                  anchors.verticalCenter: parent.verticalCenter
                                              }
                                          }
                                      }

                    onClicked: {
                        Qt.quit()
                    }
                }
            }

            // 底部版权信息
            Text {
                text: "© 2025 国际象棋 | v1.2.0 | 联系我们 17761071375"
                color: "#aaa"
                font.pixelSize: 14
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 20
                font.family: "Arial"
            }
        }
    }

    //
    Component {id: connectPage;ConnectPages{}}
    Component {id: gamePlay;GamePlay{}}

    // ==================== 设置页面 ====================
    Component {
        id: settingsPage

        Rectangle {
            id: settingsRect
            anchors.fill: parent
            color: "#1e1e2e"

            // 添加对话框属性
            property bool isDialogOpen: false

            // 未开发提示对话框
            Dialog {
                id: featureDialog
                anchors.centerIn: parent
                width: parent.width * 0.7
                height: 200
                modal: true
                visible: false
                title: "功能提示"

                background: Rectangle {
                    color: "#2a2a3a"
                    radius: 10
                    border.color: "#e0a85c"
                    border.width: 2
                }

                contentItem: ColumnLayout {
                    spacing: 20
                    anchors.centerIn: parent

                    Image {
                        source: "qrc:/pieces/warning.png"
                        Layout.alignment: Qt.AlignHCenter
                        width: 60
                        height: 60
                    }

                    Text {
                        text: "该功能未开发，敬请期待"
                        font.pixelSize: 20
                        color: "#f9f1dc"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Button {
                        text: "确定"
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: 120
                        Layout.preferredHeight: 40

                        background: Rectangle {
                            color: "#e0a85c"
                            radius: 5
                            border.color: "#c88c40"
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "#2a1e0f"
                            font.pixelSize: 18
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            featureDialog.close()
                            settingsRect.isDialogOpen = false
                        }
                    }
                }
            }

            function showFeatureDialog() {
                if (!isDialogOpen) {
                    isDialogOpen = true
                    featureDialog.open()
                }
            }


            // 标题
            Text {
                id: title
                text: "游戏设置"
                font.pixelSize: 42
                font.bold: true
                color: "#f9f1dc"
                anchors.top: parent.top
                anchors.topMargin: 50
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Microsoft YaHei UI"
                style: Text.Outline
                styleColor: "#a67c52"
                font.weight: Font.Bold
            }

            // 设置内容
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 40
                width: parent.width * 0.7

                // 声音设置区域
                ColumnLayout {
                    spacing: 20
                    Layout.fillWidth: true

                    // 声音标题
                    Text {
                        text: "声音设置"
                        font.pixelSize: 28
                        color: "#f9f1dc"
                        font.family: "Microsoft YaHei UI"
                        font.bold: true
                        Layout.alignment: Qt.AlignLeft
                    }

                    // 音量滑块
                    RowLayout {
                        spacing: 20
                        Layout.fillWidth: true

                        Text {
                            text: "音量"
                            font.pixelSize: 20
                            color: "#f9f1dc"
                            font.family: "Microsoft YaHei UI"
                        }

                        Slider {
                            id: volumeSlider
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            value: 50
                            stepSize: 5

                            background: Rectangle {
                                implicitWidth: 400
                                implicitHeight: 8
                                color: "#3a3a4e"
                                radius: 4

                                Rectangle {
                                    width: volumeSlider.visualPosition * parent.width
                                    height: parent.height
                                    color: "#e0a85c"
                                    radius: 4
                                }
                            }

                            handle: Rectangle {
                                x: volumeSlider.visualPosition * (volumeSlider.width - width)
                                y: volumeSlider.height / 2 - height / 2
                                implicitWidth: 26
                                implicitHeight: 26
                                radius: 13
                                color: "#f9f1dc"
                                border.color: "#a67c52"
                                border.width: 2
                            }

                            // 添加值改变处理
                            onValueChanged: {
                                showFeatureDialog()
                            }
                        }

                        Text {
                            text: volumeSlider.value + "%"
                            font.pixelSize: 20
                            color: "#f9f1dc"
                            font.family: "Microsoft YaHei UI"
                            width: 60
                        }
                    }

                    // 音效开关
                    RowLayout {
                        spacing: 20

                        Text {
                            text: "音效"
                            font.pixelSize: 20
                            color: "#f9f1dc"
                            font.family: "Microsoft YaHei UI"
                        }

                        Switch {
                            id: soundSwitch
                            checked: true
                            indicator: Rectangle {
                                implicitWidth: 60
                                implicitHeight: 30
                                radius: 15
                                color: soundSwitch.checked ? "#e0a85c" : "#3a3a4e"
                                border.color: "#a67c52"
                                border.width: 2

                                Rectangle {
                                    x: soundSwitch.checked ? parent.width - width - 4 : 4
                                    y: 4
                                    width: 22
                                    height: 22
                                    radius: 11
                                    color: "#f9f1dc"
                                    Behavior on x {
                                        NumberAnimation { duration: 200 }
                                    }
                                }
                            }

                            onCheckedChanged: {
                                showFeatureDialog()
                            }
                        }
                    }
                }

                // 分隔线
                Rectangle {
                    Layout.fillWidth: true
                    height: 2
                    color: "#3a3a4e"
                    Layout.topMargin: 10
                    Layout.bottomMargin: 10
                }

                ColumnLayout {
                    spacing: 20
                    Layout.fillWidth: true

                    Text {
                        text: "其他设置"
                        font.pixelSize: 28
                        color: "#f9f1dc"
                        font.family: "Microsoft YaHei UI"
                        font.bold: true
                        Layout.alignment: Qt.AlignLeft
                    }

                    // 棋盘样式
                    RowLayout {
                        spacing: 20
                        Layout.fillWidth: true

                        Text {
                            text: "棋盘样式"
                            font.pixelSize: 20
                            color: "#f9f1dc"
                            font.family: "Microsoft YaHei UI"
                        }

                        ComboBox {
                            id: boardStyle
                            model: ["经典木纹", "大理石", "深色简约", "蓝白棋盘"]
                            Layout.fillWidth: true

                            background: Rectangle {
                                color: "#3a3a4e"
                                radius: 5
                                border.color: "#a67c52"
                                border.width: 2
                            }

                            contentItem: Text {
                                text: boardStyle.displayText
                                color: "#f9f1dc"
                                font.pixelSize: 18
                                font.family: "Microsoft YaHei UI"
                                leftPadding: 15
                                verticalAlignment: Text.AlignVCenter
                            }

                            popup: Popup {
                                y: boardStyle.height
                                width: boardStyle.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: boardStyle.popup.visible ? boardStyle.delegateModel : null
                                    currentIndex: boardStyle.highlightedIndex

                                    ScrollIndicator.vertical: ScrollIndicator { }
                                }

                                background: Rectangle {
                                    color: "#3a3a4e"
                                    border.color: "#a67c52"
                                    border.width: 2
                                    radius: 5
                                }
                            }

                            delegate: ItemDelegate {
                                width: boardStyle.width
                                height: 40

                                contentItem: Text {
                                    text: modelData
                                    color: "#f9f1dc"
                                    font.pixelSize: 18
                                    font.family: "Microsoft YaHei UI"
                                    leftPadding: 15
                                    verticalAlignment: Text.AlignVCenter
                                }

                                background: Rectangle {
                                    color: parent.highlighted ? "#e0a85c" : "transparent"
                                    radius: 5
                                }
                            }

                            onActivated: {
                                showFeatureDialog()
                            }
                        }
                    }

                    // 动画速度
                    RowLayout {
                        spacing: 20
                        Layout.fillWidth: true

                        Text {
                            text: "动画速度"
                            font.pixelSize: 20
                            color: "#f9f1dc"
                            font.family: "Microsoft YaHei UI"
                        }

                        Slider {
                            id: animationSlider
                            Layout.fillWidth: true
                            from: 0.1
                            to: 2.0
                            value: 1.0
                            stepSize: 0.1

                            background: Rectangle {
                                implicitWidth: 400
                                implicitHeight: 8
                                color: "#3a3a4e"
                                radius: 4

                                Rectangle {
                                    width: animationSlider.visualPosition * parent.width
                                    height: parent.height
                                    color: "#e0a85c"
                                    radius: 4
                                }
                            }

                            handle: Rectangle {
                                x: animationSlider.visualPosition * (animationSlider.width - width)
                                y: animationSlider.height / 2 - height / 2
                                implicitWidth: 26
                                implicitHeight: 26
                                radius: 13
                                color: "#f9f1dc"
                                border.color: "#a67c52"
                                border.width: 2
                            }

                            onValueChanged: {
                                showFeatureDialog()
                            }
                        }

                        Text {
                            text: animationSlider.value.toFixed(1) + "x"
                            font.pixelSize: 20
                            color: "#f9f1dc"
                            font.family: "Microsoft YaHei UI"
                            width: 60
                        }
                    }
                }
            }

            // 返回按钮
            Button {
                id: backButton
                text: "返回主菜单"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 40
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                height: 60
                font.pixelSize: 24
                font.bold: true
                font.family: "Arial"

                background: Rectangle {
                    color: "#e0a85c"
                    radius: 10
                    border.width: 2
                    border.color: "#a67438"
                    opacity: 0.85
                }

                contentItem: Text {
                    text: backButton.text
                    font: backButton.font
                    color: "#2a1e0f"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                onClicked: {
                    stackView.pop()
                }
            }

        }
    }

}
