import SwiftUI

import DataFeature
import Firebase
import PomodoroTimerFeature

@main
struct PomodoroApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            DataView()
//            TimerView()
        }
    }
}
