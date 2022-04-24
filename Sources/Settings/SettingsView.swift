import SwiftUI

public struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }

    public init() {}

    public var body: some View {
        TabView {
            Text("General")
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .navigationTitle("ParentTitle")
                .navigationSubtitle("General")
            Text("Advanced")
                .tabItem {
                    Label("Advanced", systemImage: "star")
                }
                .navigationTitle("ParentTitle")
                .navigationSubtitle("Advanced")
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}
