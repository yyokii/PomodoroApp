//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Higashihara Yoki on 2022/03/30.
//

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
