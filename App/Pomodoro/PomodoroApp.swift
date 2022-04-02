//
//  PomodoroApp.swift
//  Pomodoro
//
//  Created by Higashihara Yoki on 2022/03/30.
//

import SwiftUI

import TimerFeature
import DataFeature

@main
struct PomodoroApp: App {
    var body: some Scene {
        WindowGroup {
            DataView()
//            TimerView()
        }
    }
}
