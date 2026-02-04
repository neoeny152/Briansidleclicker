import SwiftUI

struct GeneratorRowView: View {
    let generator: Generator
    let owned: Int
    let canAfford: Bool
    let onBuy: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(canAfford ? Color.orange.opacity(0.2) : Color.gray.opacity(0.1))
                    .frame(width: 50, height: 50)

                Image(systemName: generator.icon)
                    .font(.title2)
                    .foregroundColor(canAfford ? .orange : .gray)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(generator.name)
                        .font(.headline)

                    if owned > 0 {
                        Text("x\(owned)")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.orange.opacity(0.2))
                            .cornerRadius(8)
                    }
                }

                Text(generator.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.caption)
                        .foregroundColor(.green)
                    Text("\(FormattingUtils.formatNumber(generator.baseProduction))/s each")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            // Buy button
            Button(action: onBuy) {
                VStack(spacing: 2) {
                    Text(FormattingUtils.formatNumber(generator.price(forQuantity: owned)))
                        .font(.subheadline.bold())
                    Text("coins")
                        .font(.caption2)
                }
                .foregroundColor(canAfford ? .white : .gray)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(canAfford ? Color.orange : Color.gray.opacity(0.3))
                .cornerRadius(10)
            }
            .disabled(!canAfford)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
}

#Preview {
    VStack {
        GeneratorRowView(
            generator: Generator.allGenerators[0],
            owned: 5,
            canAfford: true,
            onBuy: {}
        )
        GeneratorRowView(
            generator: Generator.allGenerators[1],
            owned: 0,
            canAfford: false,
            onBuy: {}
        )
    }
    .padding()
}
