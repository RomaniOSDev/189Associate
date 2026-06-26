import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: OnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            VStack(spacing: 0) {
                headerBar

                TabView(selection: $viewModel.currentPage) {
                    ForEach(viewModel.pages) { page in
                        OnboardingPageView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.28), value: viewModel.currentPage)

                pageIndicator
                    .padding(.top, 8)

                footerActions
                    .padding(.horizontal, AppDesign.horizontalPadding)
                    .padding(.top, AppDesign.sectionSpacing)
                    .padding(.bottom, 32)
            }
        }
        .preferredColorScheme(.dark)
    }

    private var headerBar: some View {
        HStack {
            if viewModel.currentPage > 0 {
                Button(action: viewModel.back) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.appAccent)
                }
            } else {
                Color.clear.frame(width: 60, height: 20)
            }

            Spacer()

            if !viewModel.isLastPage {
                Button("Skip", action: viewModel.skip)
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.appTextSecondary)
            }
        }
        .padding(.horizontal, AppDesign.horizontalPadding)
        .padding(.top, 12)
        .padding(.bottom, 4)
    }

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.pages) { page in
                Capsule()
                    .fill(
                        page.id == viewModel.currentPage
                            ? themeManager.accentColor
                            : Color.white.opacity(0.18)
                    )
                    .frame(
                        width: page.id == viewModel.currentPage ? 24 : 8,
                        height: 8
                    )
                    .animation(.easeInOut(duration: 0.22), value: viewModel.currentPage)
            }
        }
    }

    private var footerActions: some View {
        AnimatedButton(
            title: viewModel.primaryButtonTitle,
            icon: viewModel.isLastPage ? "🚀" : nil,
            action: viewModel.next
        )
    }
}

// MARK: - Page

private struct OnboardingPageView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let page: OnboardingPage

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppDesign.sectionSpacing) {
                ZStack(alignment: .bottomLeading) {
                    Image(page.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .clipped()

                    LinearGradient(
                        colors: [.clear, Color.black.opacity(0.7)],
                        startPoint: .center,
                        endPoint: .bottom
                    )

                    HStack(spacing: 10) {
                        Text(page.icon)
                            .font(.title)
                        Text(page.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(18)
                }
                .clipShape(RoundedRectangle(cornerRadius: AppDesign.cornerRadius, style: .continuous))
                .topInnerHighlight(cornerRadius: AppDesign.cornerRadius)
                .depthShadow(elevation: .floating, accentColor: themeManager.accentColor, accentGlow: true)
                .padding(.horizontal, AppDesign.horizontalPadding)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundColor(.appTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppDesign.horizontalPadding + 4)

                VStack(spacing: AppDesign.itemSpacing) {
                    ForEach(page.highlights, id: \.self) { highlight in
                        OnboardingHighlightRow(text: highlight)
                    }
                }
                .padding(.horizontal, AppDesign.horizontalPadding)
            }
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
    }
}

private struct OnboardingHighlightRow: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let text: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            themeManager.accentColor.lightened(by: 0.1),
                            themeManager.accentColor
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .font(.title3)

            Text(text)
                .font(.subheadline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer(minLength: 0)
        }
        .padding(AppDesign.cellPadding)
        .glassCard(elevation: .raised, cornerRadius: AppDesign.cornerRadiusSmall)
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel(onComplete: {}))
        .environmentObject(ThemeManager())
}
