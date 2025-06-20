import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window

ApplicationWindow {
    id: mainWindow
    width: 800
    height: 700
    visible: true
    title: "国际象棋设备连接系统"
    color: "#1e1e2e"

    // 使用 StackView 管理页面导航
    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: mainMenu

        // 页面切换动画
        pushEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
            }
        }
        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }
        }
        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 300
            }
        }
        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 300
            }
        }
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

            Rectangle {
                anchors.fill: parent
                color: "#f0d6a0"
                opacity: 0.35
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

                // 开始游戏按钮
                Button {
                    id: startButton
                    text: "开始游戏"
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

                    contentItem: Text {
                        text: startButton.text
                        font: startButton.font
                        color: "#2a1e0f"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        stackView.push(gamePlay)
                    }
                }

                // 连接按钮
                Button {
                    id: connectButton
                    text: "设备连接"
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

                    contentItem: Text {
                        text: connectButton.text
                        font: connectButton.font
                        color: "#2a1e0f"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        stackView.push(connectPage)
                    }
                }

                // 设置按钮
                Button {
                    id: settingsButton
                    text: "游戏设置"
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

                    contentItem: Text {
                        text: settingsButton.text
                        font: settingsButton.font
                        color: "#2a1e0f"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        console.log("设置点击")
                    }
                }

                // 退出游戏按钮
                Button {
                    id: exitButton
                    text: "退出游戏"
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

                    contentItem: Text {
                        text: exitButton.text
                        font: exitButton.font
                        color: "#2a1e0f"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        Qt.quit()
                    }
                }
            }

            // 底部版权信息
            Text {
                text: "© 2025 国际象棋大师 | v1.2.0"
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
}
