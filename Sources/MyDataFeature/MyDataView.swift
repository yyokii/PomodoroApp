import SwiftUI

import APIClient
import ComposableArchitecture

public struct MyDataView: View {
    public var store: Store<MyDataState, MyDataAction>

    public init(store: Store<MyDataState, MyDataAction>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            Group {
                HistoryView(store: historyStore)
            }
        }
    }
}

extension MyDataView {
    private var statisticsStore: Store<StatisticsState, StatisticsAction> {
        return store.scope(
            state: { $0.statisticsState },
            action: MyDataAction.statistics
        )
    }

    private var historyStore: Store<HistoryState, HistoryAction> {
        return store.scope(
            state: { $0.historyState },
            action: MyDataAction.history
        )
    }
}

struct HistoryView: View {
    var store: Store<HistoryState, HistoryAction>

    let items: [String] = ["task1", "task2", "task3", "task4"]

    var body: some View {
      WithViewStore(store) { viewStore in
          VStack {
              HStack {
                  ForEach(viewStore.dateItems) { viewData in
                      DayView(viewData: viewData)
                  }
              }
              ScrollView {
                  VStack {
                      ForEach(0..<items.count) { index in
                          TimeLineItemView(height: 200)
                      }
                  }
                  .padding()
              }
          }
      }
    }
}

struct DayView: View {
    let viewData: HistoryState.DateItemViewData

    var body: some View {
        ZStack {
            if viewData.isToday {
                Color.red
            }

            VStack {
                Text(viewData.dayOfWeek)

                Text(viewData.day)
            }
        }
        .frame(width: 45, height: 45)
    }
}

struct TimeLineItemView: View {
    let height: CGFloat

    var body: some View {
        HStack {
            VStack {
                Text("9:00")
                Text("11:00")
                    .padding(.top, height - 40)
            }

            ZStack(alignment: .top) {
                Color.blue
                    .frame(width: 100, height: height)
                    .cornerRadius(10)

                Text("Work")
                    .padding()
            }
        }
    }
}

#if DEBUG
struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        MyDataView(store: .init(initialState: .init(),
                                reducer: myDataReducer,
                                environment: .init(apiClient: FirebaseAPIClient.live,
                                                   mainQueue: DispatchQueue.main.eraseToAnyScheduler())
                               ))
    }
}
#endif
