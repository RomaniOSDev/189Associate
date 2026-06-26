import SwiftUI
import UniformTypeIdentifiers

struct MyDecksView: View {
    @StateObject private var viewModel: MyDecksViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showImporter = false
    @State private var shareURL: URL?

    init(viewModel: MyDecksViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            if viewModel.decks.isEmpty {
                EmptyStateView(
                    icon: "📚",
                    title: "No Decks Yet",
                    message: "Create custom word decks for study, teams, or fun topics.",
                    buttonTitle: "Create Deck",
                    action: viewModel.createDeck
                )
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppDesign.itemSpacing) {
                        SectionHeaderView(
                            title: "Your Decks",
                            subtitle: "Tap to play • swipe for options",
                            trailing: "\(viewModel.decks.count)"
                        )

                        ForEach(viewModel.decks) { deck in
                            DeckCell(
                                deck: deck,
                                onTap: { viewModel.editDeck(deck) },
                                onEdit: { viewModel.editDeck(deck) },
                                onShare: { shareURL = viewModel.exportDeck(deck) },
                                onDelete: { viewModel.deleteDeck(deck) }
                            )
                        }
                    }
                    .padding(AppDesign.horizontalPadding)
                    .padding(.vertical, 8)
                }
            }
        }
        .appNavigationBar(title: "My Decks", onBack: viewModel.goBack)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button("Create Deck", action: viewModel.createDeck)
                    Button("Import JSON") { showImporter = true }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(themeManager.accentColor)
                }
            }
        }
        .fileImporter(
            isPresented: $showImporter,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            if case let .success(urls) = result, let url = urls.first {
                viewModel.importDeck(from: url)
            }
        }
        .sheet(isPresented: Binding(
            get: { shareURL != nil },
            set: { if !$0 { shareURL = nil } }
        )) {
            if let shareURL {
                ShareSheet(items: [shareURL])
            }
        }
        .alert("Import Failed", isPresented: $viewModel.showImportError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Could not read the deck file. Use a valid JSON export.")
        }
        .onAppear { viewModel.load() }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
