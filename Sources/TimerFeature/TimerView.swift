import SwiftUI

public struct TimerView: View {
    @StateObject var vm = TimerViewModel()

    public init() {}

    public var body: some View {
        VStack {
            Text("State: \(vm.pomodoroState.name)")
            Text(vm.timerText)
                .padding()

            switch vm.timerState {
            case .start:
                Button("Stop") {
                    vm.toggleTimerState()
                }
            case .stop:
                Button("Start") {
                    vm.toggleTimerState()
                }
            }
        }
        .onAppear {
            vm.startTimer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
.previewInterfaceOrientation(.portrait)
    }
}
