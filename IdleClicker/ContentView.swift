import SwiftUI

struct ContentView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            MainGameView()
                .tabItem {
                    Label("Click", systemImage: "hand.tap.fill")
                }
                .tag(0)

            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "cart.fill")
                }
                .tag(1)

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(2)
        }
        .tint(.orange)
    }
}

#Preview {
    ContentView()
        .environmentObject(GameViewModel())
}
