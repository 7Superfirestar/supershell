import Quickshell
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import Quickshell.Networking
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

PanelWindow { // root
    id: root

    Component.onCompleted: console.log("Thank you for using superbar!")

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 25
    color: "#001a1b26"

    property color colMain: "#1a1b26"
    property color colBg: "#232323"
    property color colFg: "#333333"
    property color colWhite: "#ffffff"
    property color colDarkWhite: "#cccccc"
    property color colGrey: "#999999"
    property color colDarkGrey: "#4F4F4F"
    property color colBlack: "#000000"
    property color colRed: "#FF0000"
    property color colYellow: "#FCDD41"
    property color colOrange: "#F95A04"
    property color colDarkRed: "#910000"

    property color wifiLabelColor: getWifiLabelColor(Math.round(signalStrength * 100))
    property color batteryLabelColor: getBatteryLabelColor(batteryLevel)
    property color memLabelColor: getMemLabelColor(memUsage)
    property color cpuLabelColor: getCpuLabelColor(cpuUsage)

    property string fontFamily: "JetBrainsMono Nerd Font"
    property int fontSize: 11

    property int cpuUsage: 0
    property double memUsage: 0
    property double memCap: 0

    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    property string kernelVersion: "Unknown"

    property string networkDevName: ""
    property var networkDevState: ""
    property string networkName: "N/A"
    property string networkSignalStrength: "0% "
    property var signalStrength: ""
    property var networkType: 0
    property string wifiLabel: "󰤮 "


    property var batteryLevel: Math.round(UPower.displayDevice.percentage * 100)
    property var batteryStates: [
        {min:90,label: "󰁹 "},
        {min:80,label: "󰂂 "},
        {min:70,label: "󰂁 "},
        {min:60,label: "󰂀 "},
        {min:50,label:"󰁿 "},
        {min:40,label:"󰁾 "},
        {min:30,label:"󰁽 "},
        {min:20,label:"󰁼! "},
        {min:10,label:"󰁻! "},
        {min:0,label:"󰁺! "}
    ]
    property var batteryStatesColor: [
        {min:50,label:colWhite},
        {min:35,label:colYellow},
        {min:25,label:colOrange},
        {min:10,label:colRed},
        {min:5,label:colDarkRed}
    ]
    property var wifiStates: [
        {min:75,label:"󰤨 "},
        {min:60,label:"󰤥 "},
        {min:30,label:"󰤢 "},
        {min:1,label:"󰤟 "},
        {min:0,label:"󰤫 "}
    ]
    property var wifiStatesColor: [
        {min:75,label:colWhite},
        {min:60,label:colDarkWhite},
        {min:30,label:colGrey},
        {min:1,label:colDarkGrey},
        {min:0,label:colRed}
    ]
    property var memStatesColor: [
        {min:0,max:49,label:colWhite},
        {min:49,max:84,label:colYellow},
        {min:84,max:94,label:colRed},
        {min:94,max:100,label:colDarkRed}
    ]
    property var cpuStatesColor: [
        {min:0,max:79,label:colWhite},
        {min:79,max:94,label:colYellow},
        {min:94,max:100,label:colRed}
    ]

    property bool batteryIsCharging: false


    function batteryCharging() {
        if (batteryIsCharging === true)
            return "󱐋"
        else return ""
    }
    function getBatLabel(p) {
        if (UPower.displayDevice.isLaptopBattery === true) {
            for (let i = 0; i < batteryStates.length; i++) {
                if (p >= batteryStates[i].min) 
                    return batteryStates[i].label
            }
            return "󰂑 "
        } else return ""
    }
    function getWiFiLabel(p) {
        if (networkDevState === 2) {
            for (let i = 0; i < wifiStates.length; i++) {
                if (p >= wifiStates[i].min) {
                    return wifiStates[i].label
                }
            }
            return "󰖩 "
        } else return "󰤮 "
    }
    function getWifiLabelColor(p) {
        if (networkDevState === 2) {
            for (let i = 0; i < wifiStatesColor.length; i++) {
                if (p >= wifiStatesColor[i].min) {
                    return wifiStatesColor[i].label
                }
            }
            return colWhite
        } else return colRed
    }
    function getBatteryLabelColor(p) {
        if (UPower.displayDevice.isLaptopBattery === true) {
            for (let i = 0; i < batteryStatesColor.length; i++) {
                if (p >= batteryStatesColor[i].min) {
                    return batteryStatesColor[i].label
                }
            }
            return colWhite
        } else return colBlack
    }
    function getMemLabelColor(p) {
        for (let i = 0; i < memStatesColor.length; i++) {
            if (p <= memStatesColor[i].max) {
                return memStatesColor[i].label
            }
        }
        return colWhite
    }
    function getCpuLabelColor(p) {
        for (let i = 0; i < cpuStatesColor.length; i++) {
            if (p <= cpuStatesColor[i].max) {
                return cpuStatesColor[i].label
            }
        }
        return colWhite
    }
                



    RowLayout { //left stuff e.g. workspace
        anchors.fill: parent
        anchors.margins: 8
        anchors.topMargin: 3

        Item {
            id: arrow
            Layout.preferredHeight : 17
            Row {
                x: -25
                spacing: -10
                Repeater {
                    model: 8
                    Text { text: ""; color: root.colFg; anchors.leftMargin: 0; anchors.rightMargin: 0;}
                }
            }
            Row {
                x: 20
                spacing: -10
                Repeater {
                    model: 30
                    Text { text: ""; color: root.colMain; anchors.leftMargin: 0; anchors.rightMargin: 0;}
                }
            }
        }
        Text {
            text: "󰣇 " //you can replace this with a nerd font icon to change home menu icon
            color: root.colWhite
            font { family: root.fontFamily; pixelSize: 17; bold: false}
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.color = root.colGrey
                onExited: parent.color = root.colWhite
                onClicked: {
                    menu.running = true
                }
            }
            Process { id: menu; command: ["sh", "-c", "pkill fuzzel || fuzzel"]; running: false; }
        }

        Row {
            //anchors.centerIn: parent
            //anchors.fill: parent
            anchors.leftMargin : 35
            anchors.topMargin : 3

            spacing: 6
            Repeater {
                model: 10
                Text {
                    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    text: index + 1
                    color: isActive ? root.colWhite : (ws ? root.colGrey : root.colFg)
                    font { family: root.fontFamily; pixelSize: 13; bold: true }
                    readonly property int wsId: index + 1
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Hyprland.dispatch(`hl.dsp.focus({workspace = '${wsId}'})`);
                    }
                }  
            }
        }
        Item { Layout.fillWidth : true;}
    }
    RowLayout {
        anchors.fill: parent
        Item { Layout.fillWidth : true;}
        Text {
            id: clock
            text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
            color: root.colWhite
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
            Timer { interval: 1000; running: true; repeat: true; onTriggered: {
                    clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
                }
            }
        }
        Item { Layout.fillWidth : true;}
    }
    RowLayout {
        anchors.fill: parent
        Item { Layout.fillWidth : true; Layout.preferredWidth: 0.5}

        Instantiator {
        model: Networking.devices

        delegate: Instantiator {
            model: modelData.networks
            delegate: Item {
                Timer {
                    running: true
                    interval: 500
                    repeat: true
                    onTriggered: {
                        if (networkType === 1) { //if device is disconnected
                            if (modelData.device.state === 4) {
                                wifiLabel = "󰤮 "
                                networkSignalStrength = "0% "
                                networkName = "N/A"
                                networkDevState = 4
                            }
                            if (modelData.device.state === 2) { //if device is connected
                                wifiLabel = getWiFiLabel(Math.round(signalStrength * 100))
                                networkSignalStrength = Math.round(signalStrength * 100) + "% "
                                networkName = modelData.name
                                signalStrength = modelData.signalStrength
                                networkDevState = 2
                            } else { //safeguard
                                wifiLabel = "󰤮 "
                                networkSignalStrength = "0% "
                                networkName = "N/A"
                            }
                        }
                    }
                }
                Component.onCompleted: {
                    running: true
                    if (modelData.device.type === 1) { //if device is a wifi device
                        networkType = 1
                    } else if (modelData.device.type === 2) { //if device is a wired device
                        networkType = 2
                        networkSignalStrength = ""
                    }
                    if (modelData.device.state === 2) { //if device is connected
                        networkName = modelData.name
                        networkDevName = modelData.device.name
                        if (modelData.device.type === 1) {//if device is a wifi device
                            signalStrength = modelData.signalStrength
                            networkSignalStrength = Math.round(signalStrength * 100) + "% "
                        }
                    }
                }
            }
        }
    }
        Process {
            id: cpuProc
            command: ["sh", "-c", "head -1 /proc/stat"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var p = data.trim().split(/\s+/)
                    var idle = parseInt(p[4])+parseInt(p[5])
                    var total = p.slice(1,8).reduce((a,b)=>a+parseInt(b),0)
                    if (lastCpuTotal > 0) {
                        cpuUsage = Math.round(100*(1-(idle-lastCpuIdle)/(total-lastCpuTotal)))
                    }
                    lastCpuTotal = total
                    lastCpuIdle = idle
                }
            }
            Component.onCompleted: running = true
        }
        Process {
            id: memProc
            command: ["sh", "-c", "free | grep Mem"]
            stdout: SplitParser {
                onRead: data => {
                    if (!data) return
                    var parts = data.trim().split(/\s+/)
                    var total = parseInt(parts[1]) || 1
                    var used = parseInt(parts[2]) || 0
                    memUsage = Math.round(Math.round(used) /10000) / 100
                    memCap = Math.round(Math.round(total) /100000) / 10
                }
            }
            Component.onCompleted: running = true
        }
        Process {
            id: kernelProc
            command: ["uname", "-r"]
            stdout: StdioCollector {
                onStreamFinished: {
                    kernelVersion = text.trim()
                }
            }
            Component.onCompleted: running = true
        }
        Text {
            text: "|"
            color: root.colFg
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true;}
        }
        Text {
            text: wifiLabel + networkSignalStrength /*+ " " + networkDevName*/ + networkName
            color: root.wifiLabelColor
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true;}
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: { parent.color = root.colGrey }
                onExited: { parent.color = root.wifiLabelColor }
            }
        }
        Text {
            text: "|"
            color: root.colFg
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true;}
        }
        Text {
            text: " " + cpuUsage + "%"
            color: root.cpuLabelColor
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered:{ parent.color = root.colGrey }
                onExited: { parent.color = root.cpuLabelColor }
            }
        }
        Text {
            text: "|"
            color: root.colFg
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        }
        Text {
            text: " " + memUsage + "GB" + "/" + memCap + "GB" 
            color: root.memLabelColor
            font { family : root.fontFamily; pixelSize: root.fontSize; bold: true }
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered:{ parent.color = root.colGrey }
                onExited: { parent.color = root.memLabelColor }
            }
        }
        Text {
            text: "|"
            color: root.colFg
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true }
        }
        Text {
            id: batMeter
            text: batteryCharging() + getBatLabel(batteryLevel) + batteryLevel + "%"
            color: root.batteryLabelColor
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true;}
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: { parent.color = root.colGrey; }
                onExited: { parent.color = root.batteryLabelColor; }
            }

            Process {id:batteryLowNotif; command: ["notify-send", "Battery low", batteryLevel + "% " + "remaining"]; running: false}
            Process {id:batteryCriticalNotif; command: ["notify-send", "Battery critical", batteryLevel + "% " + "remaining"]; running: false}
            Process {id:batteryVeryCriticalNotif; command: ["notify-send", "Battery very critical", batteryLevel + "% " + "remaining"]; running: false}
            Process {id:batteryChargingNotif; command: ["notify-send", "Detected charger", batteryLevel + "% " + "and charging"]; running: false}

            property bool lowLock: false
            property bool critLock: false
            property bool vCritLock: false
            property bool chargeLock: false

            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: { // Currently experimenting with minimizing the IF statements. If something goes wrong, uncomment the commented IF statements and remove the ELSE statements.
                    //console.log("L " + lowLock + " C " + critLock + " VC " + vCritLock + " B " + batteryLevel)
                    if (batteryLevel < 26) {
                        if (parent.lowLock === false) {
                            batteryLowNotif.running = true
                            parent.lowLock = true
                        }
                    } else parent.lowLock = false
                    //if (batteryLevel > 26) {
                    //    parent.lowLock = false
                    //}
                    if (batteryLevel < 16) {
                        if (parent.critLock === false) {
                            batteryCriticalNotif.running = true
                            parent.critLock = true
                        }
                    } else parent.critLock = false
                    //if (batteryLevel > 16) {
                    //    parent.critLock = false
                    //}
                    if (batteryLevel < 6) {
                        if (parent.vCritLock === false) {
                            batteryVeryCriticalNotif.running = true
                            parent.vCritLock = true
                        }
                    } else parent.vCritLock = false
                    //if (batteryLevel > 6) {
                    //    parent.vCritLock = false
                    //}
                    if (batteryIsCharging === true) {
                        if (parent.chargeLock === false) {
                            batteryChargingNotif.running = true
                            parent.chargeLock = true
                        }
                    } else parent.chargeLock = false

                }
            }
        }
        Text {
            text: "|"
            color : root.colFg
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true;}
        }
        Text {
            text: " " + kernelVersion
            color: root.colWhite
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true;}
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered:{ parent.color = root.colGrey; }
                onExited: { parent.color = root.colWhite }
            }
        }
        Text {
            text: "|"
            color: root.colFg
            font { family: root.fontFamily; pixelSize: root.fontSize; bold: true;}
        }
        /*Text {
            text: "󰐥"
            color: root.colWhite
            font { family: root.fontFamily; pixelSize: root.fontSize+2; bold: true;}
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                //onClicked: {testpopup.visible = true}
                onEntered: { parent.color = colGrey }
                onExited: { parent.color= colWhite }
            }
        }*/
        Timer {
            interval: 500
            running: true
            repeat: true
            onTriggered: {
                cpuProc.running = true
                memProc.running = true
                batteryLevel = Math.round(UPower.displayDevice.percentage * 100)
                
                if (UPower.displayDevice.state === UPowerDeviceState.Charging) {
                    batteryIsCharging = true
                } else {
                    batteryIsCharging = false
                }
            }
        }
    }
    PanelWindow {
        id: taskbar
        anchors.right: true
        anchors.top: false
        anchors.bottom: true
        anchors.left: true
        implicitWidth: 3
        implicitHeight: 20
        visible: false // Currently work in progress
        color: root.colMain
        Item { Layout.fillHeight: true }
    }
}
