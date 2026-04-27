import SwiftUI
import StoreKit

struct PaywallView: View {

    @EnvironmentObject var storeManager: StoreManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProductID: String?
    @State private var isPurchasing = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.indigo, Color.purple, Color.pink.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 28) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.yellow)
                            .shadow(color: .yellow.opacity(0.5), radius: 10)

                        Text("Unlock NightGuard Premium")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)

                        VStack(alignment: .leading, spacing: 16) {
                            FeatureRow(icon: "shield.fill", text: "Unlimited app blocking")
                            FeatureRow(icon: "lock.shield.fill", text: "Hard Lock mode")
                            FeatureRow(icon: "moon.zzz.fill", text: "Simulated shutdown")
                            FeatureRow(icon: "person.2.fill", text: "Accountability partner")
                            FeatureRow(icon: "mic.fill", text: "Siri voice control")
                            FeatureRow(icon: "chart.bar.fill", text: "Full sleep statistics")
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(storeManager.products, id: \.id) { product in
                                ProductRow(
                                    product: product,
                                    isSelected: selectedProductID == product.id,
                                    onSelect: { selectedProductID = product.id }
                                )
                            }
                        }
                        .padding(.horizontal)

                        Button {
                            purchaseSelectedProduct()
                        } label: {
                            if isPurchasing {
                                ProgressView()
                                    .progressViewStyle(.circular)
                                    .tint(.indigo)
                            } else {
                                Text("Subscribe")
                                    .fontWeight(.bold)
                            }
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.white)
                        .foregroundStyle(.indigo)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        .disabled(isPurchasing || selectedProductID == nil)

                        Button("Restore Purchases") {
                            Task { await storeManager.restorePurchases() }
                        }
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))

                        Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless it is canceled at least 24 hours before the end of the current period.")
                            .font(.caption2)
                            .foregroundStyle(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.vertical, 32)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundStyle(.white)
                }
            }
        }
    }

    private func purchaseSelectedProduct() {
        guard let productID = selectedProductID,
              let product = storeManager.products.first(where: { $0.id == productID }) else { return }

        isPurchasing = true
        Task {
            do {
                _ = try await storeManager.purchase(product)
                dismiss()
            } catch {
                print("Purchase failed: \(error)")
            }
            isPurchasing = false
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.yellow)
                .frame(width: 24)

            Text(text)
                .foregroundStyle(.white)

            Spacer()
        }
        .font(.subheadline)
    }
}

struct ProductRow: View {
    let product: Product
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(product.displayName)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(product.description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                Text(product.displayPrice)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                if product.subscription?.subscriptionPeriod.value == 12 {
                    Text("Best Value")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.yellow)
                        .foregroundStyle(.black)
                        .clipShape(Capsule())
                }

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(isSelected ? .yellow : .white.opacity(0.5))
            }
            .padding()
            .background(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}
