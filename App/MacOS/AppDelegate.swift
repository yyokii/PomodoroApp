import Cocoa
import SwiftUI

import AppFeature
import Firebase
import PomodoroTimerFeature

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()

        // ポップオーバーの中にSwiftUIビューを設定
        let contentView = AppView(
            store: .init(
                initialState: AppState(),
                reducer: appReducer,
                environment: .init(
                    apiClient: .live,
                    mainQueue: DispatchQueue.main.eraseToAnyScheduler()
                )
            )
        )
        // ポップオーバーを設定
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 350, height: 500)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        // ステータスバーアイコンを設定
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        guard let button = self.statusBarItem.button else { return }
        button.image = NSImage(systemSymbolName: "checkmark.circle.fill", accessibilityDescription: nil)
        button.action = #selector(showHidePopover(_:))
    }

    @objc func showHidePopover(_ sender: AnyObject?) {
        guard let button = self.statusBarItem.button else { return }
        if self.popover.isShown {
            self.popover.performClose(sender)
        } else {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            self.popover.contentViewController?.view.window?.becomeKey()
        }
    }

}


