import Cocoa
import SwiftUI

import AppFeature
import ComposableArchitecture
import Firebase
import PomodoroTimerFeature
import Settings
import SwiftHelper

let pomodoroAppStore: Store<AppState, AppAction> = .init(
    initialState: AppState(),
    reducer: appReducer,
    environment: .init(
        apiClient: .live,
        userDefaults: .live(),
        mainQueue: DispatchQueue.main.eraseToAnyScheduler()
    )
)

var settingsStore: Store<SettingsState, SettingsAction> {
    return pomodoroAppStore.scope(
        state: { $0.settings },
        action: AppAction.settings
    )
}

class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        FirebaseApp.configure()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(notified(notification:)),
                                               name: .pomodoroModeChanged,
                                               object: nil)
        // ポップオーバーの中にSwiftUIビューを設定
        let contentView = AppView(
            store: pomodoroAppStore
        )
        // ポップオーバーを設定
        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: contentView)
        self.popover = popover
        // ステータスバーアイコンを設定
        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))
        guard let button = self.statusBarItem.button else { return }
        button.image = NSImage(systemSymbolName: "stopwatch.fill", accessibilityDescription: nil)
        button.action = #selector(showHidePopover(_:))
    }

    @objc private func showHidePopover(_ sender: AnyObject?) {
        guard let button = self.statusBarItem.button else { return }
        if self.popover.isShown {
            self.popover.performClose(sender)
        } else {
            self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            self.popover.contentViewController?.view.window?.becomeKey()
        }
    }

    @objc private func notified(notification: Notification) {
        let mode: PomodoroTimerState.PomodoroMode.Mode = notification.userInfo![Notification.Name.UserInfoKey.pomodoroMode] as! PomodoroTimerState.PomodoroMode.Mode

        switch mode {
        case .working:
            statusBarItem.button!.image = NSImage(systemSymbolName: "stopwatch.fill", accessibilityDescription: nil)

        case .shortBreak:
            statusBarItem.button!.image = NSImage(systemSymbolName: "moon.zzz.fill", accessibilityDescription: nil)

        case .longBreak:
            statusBarItem.button!.image = NSImage(systemSymbolName: "zzz", accessibilityDescription: nil)
        }
    }
}


