import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Item {
  id: root
  property var shell: null
  property var manifest: null
  property bool opened: false
  property string result: ""

  function open() { opened = true }
  function close() { opened = false }

  Process {
    id: exportProcess
    stdout: StdioCollector { waitForEnd: true; onStreamFinished: root.result = String(text).trim() }
    stderr: StdioCollector { waitForEnd: true; onStreamFinished: if (String(text).trim()) root.result = String(text).trim() }
    onExited: function(code) { if (code !== 0 && root.result === "") root.result = "Export failed (exit " + code + ")" }
  }

  PanelWindow {
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    Rectangle {
      anchors.fill: parent
      color: "#99000000"
      MouseArea { anchors.fill: parent; onClicked: root.close() }
    }
    Rectangle {
      width: 520; height: 280
      anchors.centerIn: parent
      radius: 12
      color: "#25252b"
      border.color: "#555560"
      Column {
        anchors.fill: parent; anchors.margins: 24; spacing: 14
        Text { text: "Omarchy plugin backup"; color: "white"; font.pixelSize: 22 }
        Text { width: parent.width; wrapMode: Text.Wrap; color: "#d0d0d5"; text: "Export saves Git sources, exact commits, and your shell layout. It never exports credentials. Restore from a terminal using bin/restore-plugins." }
        Button {
          text: exportProcess.running ? "Exporting…" : "Export to current folder"
          enabled: !exportProcess.running
          onClicked: {
            root.result = ""
            exportProcess.command = ["sh", "-lc", "~/.config/omarchy/plugins/" + root.manifest.id + "/bin/export-plugins --output ."]
            exportProcess.running = true
          }
        }
        Text { width: parent.width; wrapMode: Text.Wrap; color: "#9cd6a4"; text: root.result }
        Button { text: "Close"; onClicked: root.close() }
      }
    }
  }
}
