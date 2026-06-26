import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            if coordinator.showsOnboarding {
                OnboardingView(viewModel: coordinator.onboardingViewModel)
            } else {
                mainApp
            }
        }
        .environmentObject(coordinator.themeManager)
        .preferredColorScheme(.dark)
        .tint(.appAccent)
        .animation(.easeInOut(duration: 0.35), value: coordinator.showsOnboarding)
    }

    private var mainApp: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(viewModel: coordinator.homeViewModel)
                .navigationDestination(for: AppRoute.self) { route in
                    coordinator.view(for: route)
                }
        }
    }
}

#Preview {
    ContentView()
}
