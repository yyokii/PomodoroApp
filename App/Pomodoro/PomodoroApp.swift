import SwiftUI

import DataFeature
import Firebase
import TimerFeature

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
