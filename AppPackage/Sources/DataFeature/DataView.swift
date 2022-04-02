import SwiftUI

public struct DataView: View {
    @StateObject var vm = DataViewModel()

    let items: [String] = ["task1", "task2", "task3", "task4"]
    public init(){}

    public var body: some View {
        VStack() {
            HStack {
                ForEach(vm.dateItems) { viewData in
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

struct DayView: View {
    let viewData: DateItemViewData

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
        DataView()

        TimeLineItemView(height: 100)
    }
}
#endif
