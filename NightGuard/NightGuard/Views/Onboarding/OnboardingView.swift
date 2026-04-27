import SwiftUI
import FamilyControls

struct OnboardingView: View {

    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
        ZStack {
            LinearGradient(
                colors: viewModel.pages[viewModel.currentPage].gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: viewModel.currentPage)

            VStack(spacing: 40) {
                Spacer()

                Image(systemName: viewModel.pages[viewModel.currentPage].iconName)
                    .font(.system(size: 80))
                    .foregroundStyle(.white)
                    .shadow(radius: 10)

                VStack(spacing: 12) {
                    Text(viewModel.pages[viewModel.currentPage].title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text(viewModel.pages[viewModel.currentPage].subtitle)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.85))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                if viewModel.shouldShowAuthorization && !viewModel.hasAuthorized {
                    Button {
                        Task {
                            do {
                                try await ShieldManager.shared.requestAuthorization()
                                viewModel.hasAuthorized = true
                            } catch {
                                print("Authorization failed: \(error)")
                            }
                        }
                    } label: {
                        Text("Grant Screen Time Access")
                            .font(.headline)
                            .foregroundStyle(.indigo)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(.white)
                            .clipShape(Capsule())
                    }
                }

                Spacer()

                HStack(spacing: 16) {
                    if viewModel.currentPage > 0 {
                        Button("Back") {
                            viewModel.previousPage()
                        }
                        .foregroundStyle(.white)
                    }

                    Spacer()

                    Button(viewModel.isLastPage ? "Get Started" : "Next") {
                        if viewModel.isLastPage {
                            viewModel.completeOnboarding()
                        } else {
                            viewModel.nextPage()
                        }
                    }
                    .font(.headline)
                    .foregroundStyle(.indigo)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(.white)
                    .clipShape(Capsule())
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)

                PageControl(numberOfPages: viewModel.pages.count, currentPage: viewModel.currentPage)
                    .padding(.bottom, 16)
            }
        }
    }
}

struct PageControl: View {
    let numberOfPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                    .frame(width: 8, height: 8)
            }
        }
    }
}
