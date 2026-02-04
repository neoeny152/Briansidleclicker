import SwiftUI

struct MainGameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @State private var coinScale: CGFloat = 1.0
    @State private var showingFloatingNumbers: [FloatingNumber] = []

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [Color.orange.opacity(0.3), Color.yellow.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                // Coin display
                VStack(spacing: 8) {
                    Text(FormattingUtils.formatNumber(gameViewModel.gameState.coins))
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.orange, .yellow],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("coins")
                        .font(.title3)
                        .foregroundColor(.secondary)

                    HStack(spacing: 20) {
                        VStack {
                            Text(FormattingUtils.formatNumber(gameViewModel.effectiveCoinsPerClick))
                                .font(.headline)
                            Text("per click")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Divider()
                            .frame(height: 30)

                        VStack {
                            Text(FormattingUtils.formatNumber(gameViewModel.gameState.coinsPerSecond))
                                .font(.headline)
                            Text("per second")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 8)
                }
                .padding()

                Spacer()

                // Main clicker button
                ClickerButton(scale: $coinScale) {
                    gameViewModel.tap()
                    triggerTapAnimation()
                    spawnFloatingNumber()
                }

                Spacer()

                // Quick stats
                HStack {
                    StatBubble(title: "Clicks", value: "\(gameViewModel.gameState.totalClicks)")
                    StatBubble(title: "Earned", value: FormattingUtils.formatNumber(gameViewModel.gameState.totalCoinsEarned))
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }

            // Floating numbers
            ForEach(showingFloatingNumbers) { floatingNumber in
                FloatingNumberView(number: floatingNumber)
            }
        }
        .onDisappear {
            gameViewModel.saveGame()
        }
    }

    private func triggerTapAnimation() {
        withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
            coinScale = 0.9
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                coinScale = 1.0
            }
        }
    }

    private func spawnFloatingNumber() {
        let number = FloatingNumber(
            value: gameViewModel.effectiveCoinsPerClick,
            x: CGFloat.random(in: 120...280),
            y: 350
        )
        showingFloatingNumbers.append(number)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showingFloatingNumbers.removeAll { $0.id == number.id }
        }
    }
}

struct StatBubble: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(.systemBackground).opacity(0.8))
        .cornerRadius(12)
    }
}

struct FloatingNumber: Identifiable {
    let id = UUID()
    let value: Double
    let x: CGFloat
    let y: CGFloat
}

struct FloatingNumberView: View {
    let number: FloatingNumber
    @State private var offset: CGFloat = 0
    @State private var opacity: Double = 1

    var body: some View {
        Text("+\(FormattingUtils.formatNumber(number.value))")
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .foregroundColor(.orange)
            .position(x: number.x, y: number.y + offset)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    offset = -100
                    opacity = 0
                }
            }
    }
}

#Preview {
    MainGameView()
        .environmentObject(GameViewModel())
}
