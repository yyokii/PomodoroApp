import CoreGraphics

import APIClient
import ComposableArchitecture
import SwiftHelper

// MARK: Statistics

struct StatisticsState: Equatable {}

public enum StatisticsAction: Equatable {}

struct StatisticsEnvironment {
    var apiClient: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let statisticsReducer = Reducer<StatisticsState, StatisticsAction, StatisticsEnvironment> { state, action, environment in
        .none
}

// MARK: History

struct HistoryState: Equatable {
    var tasks: [TaskViewData] = []
    var dateItems: [DateItemViewData] = Date().daysOfWeek
        .map{
            .init(with: $0)
        }
}

extension HistoryState {
    struct DateItemViewData: Equatable, Identifiable {
        let id = UUID()

        /// Original Date
        let date: Date

        let dayOfWeek: String
        let day: String
        let isToday: Bool

        init(with date: Date) {
            self.date = date
            dayOfWeek = date.toString(format: .weekDay)
            day = date.toString(format: .day)

            let now = Date()
            let nowDateComponent = Calendar.appCalendar.dateComponents([.year, .month, .day], from: now)
            let targetDateComponent = Calendar.appCalendar.dateComponents([.year, .month, .day], from: date)
            isToday = nowDateComponent == targetDateComponent
        }
    }

    struct TaskViewData: Equatable {
        let startTime: String
        let endTime: String
        let taskHeight: CGFloat
        let category: String?
        let name: String?
    }
}

public enum HistoryAction: Equatable {
    case selectData
}

struct HistoryEnvironment {
    var apiClient: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let historyReducer = Reducer<HistoryState, HistoryAction, HistoryEnvironment> { state, action, environment in

    switch action {
    case .selectData:
        return .none
    }
}

// MARK: MyData

public struct MyDataState: Equatable {
    var historyState = HistoryState()
    var statisticsState = StatisticsState()

    public init() {}
}

public enum MyDataAction: Equatable {
    case history(HistoryAction)
    case statistics(StatisticsAction)
}

public struct MyDataEnvironment {
    var apiClient: FirebaseAPIClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(apiClient: FirebaseAPIClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.apiClient = apiClient
        self.mainQueue = mainQueue
    }
}

public let myDataReducer: Reducer<MyDataState, MyDataAction, MyDataEnvironment> = .combine(
    historyReducer.pullback(
        state: \MyDataState.historyState,
        action: /MyDataAction.history,
        environment: { environment in
            HistoryEnvironment(apiClient: FirebaseAPIClient.live,
                               mainQueue: environment.mainQueue)
        }
    ),
    statisticsReducer.pullback(
        state: \MyDataState.statisticsState,
        action: /MyDataAction.statistics,
        environment: { environment in
            StatisticsEnvironment(apiClient: FirebaseAPIClient.live,
                                  mainQueue: environment.mainQueue)
        }
    ),
    .init { state, action, environment in
    .none
    }
)

