import SwiftUI

extension View {
    func appNavigationBar(title: String, backTitle: String = "Back", onBack: (() -> Void)? = nil) -> some View {
        navigationBarBackButtonHidden(true)
            .toolbar {
                if let onBack {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: onBack) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                Text(backTitle)
                            }
                            .font(.subheadline.weight(.semibold))
                            .foregroundColor(.appAccent)
                        }
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
    }

    func appScreen() -> some View {
        toolbar(.hidden, for: .navigationBar)
    }
}
