import SwiftUI

import MyDataFeature
import Firebase
import PomodoroTimerFeature

@main
struct PomodoroApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
//            DataView()
//            TimerView()
        }
    }
}
