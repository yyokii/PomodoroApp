import SwiftUI

public struct TimerView: View {
    @StateObject var vm = TimerViewModel()

    public init() {}

    public var body: some View {
        VStack {
            Text("\(vm.currentTimerSettings.intervalMinutesSecond)")
                .padding()
        }
    }
}

struct SliderView: View {
    @State private var value: Double = 0

    var body: some View {
        Slider(value: $value)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
.previewInterfaceOrientation(.portrait)
    }
}
