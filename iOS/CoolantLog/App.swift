import SwiftUI

@main
struct CoolantLogApp: App {
    @StateObject private var store = Store()
    @StateObject private var purchases = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(purchases)
                .task {
                    await purchases.refreshEntitlements()
                    store.isProUnlocked = purchases.isPro
                }
                .onChange(of: purchases.isPro) { _, newValue in
                    store.isProUnlocked = newValue
                }
        }
    }
}
