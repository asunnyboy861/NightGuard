import StoreKit
import SwiftUI

@MainActor
final class StoreManager: ObservableObject {

    @Published var products: [Product] = []
    @Published var purchasedProductIDs: Set<String> = []
    @Published var isPremium: Bool = false

    private var transactionListener: Task<Void, Never>?

    init() {
        transactionListener = listenForTransactions()
        Task { await loadProducts() }
    }

    deinit {
        transactionListener?.cancel()
    }

    func loadProducts() async {
        do {
            let storeProducts = try await Product.products(for: NightGuardProduct.allCases.map { $0.rawValue })
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {
            print("Failed to load products: \(error)")
        }
    }

    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePremiumStatus(transaction)
            await transaction.finish()
            return transaction

        case .userCancelled:
            return nil

        case .pending:
            return nil

        @unknown default:
            return nil
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePremiumStatusFromAppStore()
        } catch {
            print("Failed to restore purchases: \(error)")
        }
    }

    private func checkVerified<T>(_ verification: VerificationResult<T>) throws -> T {
        switch verification {
        case .unverified(_, let error):
            throw error
        case .verified(let safe):
            return safe
        }
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task(priority: .background) { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updatePremiumStatus(transaction)
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }

    private func updatePremiumStatus(_ transaction: StoreKit.Transaction) {
        purchasedProductIDs.insert(transaction.productID)
        isPremium = true

        UserDefaults.standard.set(true, forKey: AppGroupKeys.isPremium)
        UserDefaults.standard.set(transaction.productID, forKey: AppGroupKeys.premiumProductID)
    }

    private func updatePremiumStatusFromAppStore() async {
        for product in NightGuardProduct.allCases {
            if let result = await StoreKit.Transaction.currentEntitlement(for: product.rawValue) {
                if case .verified(let transaction) = result {
                    updatePremiumStatus(transaction)
                    return
                }
            }
        }
        isPremium = false
    }
}
