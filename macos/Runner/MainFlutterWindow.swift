import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    super.awakeFromNib()

    let flutterViewController = FlutterViewController()
    self.contentViewController = flutterViewController
    self.minSize = NSSize(width: 1280, height: 720)
    self.setFrame(
      NSRect(origin: .zero, size: NSSize(width: 1280, height: 720)),
      display: true
    )
    self.center()

    RegisterGeneratedPlugins(registry: flutterViewController)
  }
}
