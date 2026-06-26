import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0

    let pages = OnboardingPage.pages
    private let onComplete: () -> Void

    var isLastPage: Bool {
        currentPage == pages.count - 1
    }

    var primaryButtonTitle: String {
        isLastPage ? "Get Started" : "Continue"
    }

    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }

    func next() {
        if isLastPage {
            complete()
        } else {
            currentPage += 1
        }
    }

    func back() {
        guard currentPage > 0 else { return }
        currentPage -= 1
    }

    func skip() {
        complete()
    }

    func complete() {
        UserDefaults.standard.set(true, forKey: StorageKeys.onboardingCompleted)
        onComplete()
    }
}
