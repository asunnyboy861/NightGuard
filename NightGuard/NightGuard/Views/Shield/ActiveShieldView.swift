import SwiftUI

struct ActiveShieldView: View {

    @ObservedObject var shutdown = SimulatedShutdown.shared

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.indigo.opacity(0.6))

                Text("NightGuard Active")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.8))

                Text(shutdown.remainingTime)
                    .font(.system(size: 48, weight: .light, design: .monospaced))
                    .foregroundStyle(.white.opacity(0.5))

                Text("remaining until wake time")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.3))

                Spacer()

                Text("Your phone is protecting your sleep.")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.2))
                    .padding(.bottom, 32)
            }
        }
    }
}
