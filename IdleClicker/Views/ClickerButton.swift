import SwiftUI

struct ClickerButton: View {
    @Binding var scale: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                // Outer glow
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.yellow.opacity(0.4), Color.clear],
                            center: .center,
                            startRadius: 60,
                            endRadius: 120
                        )
                    )
                    .frame(width: 240, height: 240)

                // Main coin
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.yellow, Color.orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 180, height: 180)
                    .shadow(color: .orange.opacity(0.5), radius: 10, x: 0, y: 5)

                // Inner circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.orange, Color.yellow.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)

                // Dollar sign
                Text("$")
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .orange.opacity(0.5), radius: 2, x: 1, y: 2)
            }
            .scaleEffect(scale)
        }
        .buttonStyle(PlainButtonStyle())
        .sensoryFeedback(.impact(flexibility: .soft), trigger: scale)
    }
}

#Preview {
    ClickerButton(scale: .constant(1.0)) {
        print("Tapped!")
    }
}
