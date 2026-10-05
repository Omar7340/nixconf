import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: theme.surface
    property var theme: ({surface: "#131318", text: "#e4e1e9", primary: "#bfc2ff",
        onPrimary: "#272955", container: "#24242c", outline: "#464650", error: "#ffb4ab"})
    property bool busy: false
    property string message: ""
    property string clockText: Qt.formatTime(new Date(), "hh:mm")
    readonly property string fontFamily: "JetBrainsMono Nerd Font"
    readonly property color surfaceColor: theme.surface

    function loadTheme() {
        const request = new XMLHttpRequest();
        request.open("GET", "file:///var/lib/niri-greeter/theme.json");
        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE && request.responseText.length > 0) {
                try { root.theme = JSON.parse(request.responseText); }
                catch (error) { console.warn("Using fallback login palette:", error); }
            }
        };
        request.send();
    }
    function login() {
        if (busy || user.text.trim().length === 0) return;
        message = "";
        busy = true;
        sddm.login(user.text.trim(), password.text, session.currentIndex);
    }
    Component.onCompleted: {
        loadTheme();
        user.text = userModel.lastUser || "kage";
        password.forceActiveFocus();
    }
    Connections {
        target: sddm
        function onLoginFailed() {
            root.busy = false;
            root.message = qsTr("Login failed. Check your password.");
            password.text = "";
            password.forceActiveFocus();
        }
    }
    Timer {
        interval: 1000; running: true; repeat: true
        onTriggered: root.clockText = Qt.formatTime(new Date(), "hh:mm")
    }
    Image {
        anchors.fill: parent
        source: "file:///var/lib/niri-greeter/wallpaper.png"
        fillMode: Image.PreserveAspectCrop
        cache: false
    }
    Rectangle { anchors.fill: parent; color: "#55000000" }
    Column {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: Math.max(40, root.height * 0.09)
        spacing: 8
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.clockText
            color: "#ffffff"; font.family: root.fontFamily; font.pixelSize: 64
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Qt.formatDate(new Date(), "dddd, d MMMM")
            color: "#ffffff"; font.family: root.fontFamily; font.pixelSize: 18
        }
    }
    Rectangle {
        anchors.centerIn: parent
        width: 440
        height: form.implicitHeight + 64
        radius: 18
        color: Qt.rgba(root.surfaceColor.r, root.surfaceColor.g, root.surfaceColor.b, 0.96)
        border.color: root.theme.outline
        border.width: 1
        ColumnLayout {
            id: form
            anchors.left: parent.left; anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 32
            spacing: 16
            Text {
                text: qsTr("Welcome home")
                color: root.theme.text
                font.family: root.fontFamily; font.pixelSize: 24
                Layout.alignment: Qt.AlignHCenter
            }
            Text {
                text: "TOWER"
                color: root.theme.primary
                font.family: root.fontFamily; font.pixelSize: 12
                font.letterSpacing: 4
                Layout.alignment: Qt.AlignHCenter
            }
            TextField {
                id: user
                Layout.fillWidth: true
                placeholderText: qsTr("Username")
                font.family: root.fontFamily; font.pixelSize: 15
                color: root.theme.text; placeholderTextColor: root.theme.outline
                selectionColor: root.theme.primary; selectedTextColor: root.theme.onPrimary
                padding: 14
                enabled: !root.busy
                background: Rectangle {
                    color: root.theme.container; radius: 9
                    border.color: user.activeFocus ? root.theme.primary : root.theme.outline
                }
                onAccepted: password.forceActiveFocus()
            }
            TextField {
                id: password
                Layout.fillWidth: true
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                font.family: root.fontFamily; font.pixelSize: 15
                color: root.theme.text; placeholderTextColor: root.theme.outline
                selectionColor: root.theme.primary; selectedTextColor: root.theme.onPrimary
                padding: 14
                enabled: !root.busy
                background: Rectangle {
                    color: root.theme.container; radius: 9
                    border.color: password.activeFocus ? root.theme.primary : root.theme.outline
                }
                onAccepted: root.login()
            }
            ComboBox {
                id: session
                Layout.fillWidth: true
                model: sessionModel
                textRole: "name"
                currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
                font.family: root.fontFamily; font.pixelSize: 14
                palette.window: root.theme.container
                palette.base: root.theme.container
                palette.text: root.theme.text
                palette.buttonText: root.theme.text
                palette.button: root.theme.container
                palette.highlight: root.theme.primary
                palette.highlightedText: root.theme.onPrimary
                enabled: !root.busy
            }
            Button {
                id: signIn
                Layout.fillWidth: true
                text: root.busy ? qsTr("Signing in…") : qsTr("Sign in")
                enabled: !root.busy
                font.family: root.fontFamily; font.pixelSize: 15; font.bold: true
                padding: 14
                contentItem: Text {
                    text: signIn.text; font: signIn.font
                    color: root.theme.onPrimary
                    horizontalAlignment: Text.AlignHCenter
                }
                background: Rectangle { color: root.theme.primary; radius: 9 }
                onClicked: root.login()
            }
            Text {
                text: root.message
                visible: text.length > 0
                color: root.theme.error
                font.family: root.fontFamily; font.pixelSize: 13
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }
    Row {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 32
        spacing: 20
        Repeater {
            model: [qsTr("Suspend"), qsTr("Restart"), qsTr("Shut down")]
            Button {
                required property string modelData
                required property int index
                text: modelData
                font.family: root.fontFamily; font.pixelSize: 14
                palette.button: root.theme.container; palette.buttonText: root.theme.text
                onClicked: {
                    if (index === 0) sddm.suspend();
                    else if (index === 1) sddm.reboot();
                    else sddm.powerOff();
                }
            }
        }
    }
}
