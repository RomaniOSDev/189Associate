import SwiftUI

struct DeckEditorView: View {
    @StateObject private var viewModel: DeckEditorViewModel
    @EnvironmentObject private var themeManager: ThemeManager

    init(viewModel: DeckEditorViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            GradientBackground()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppDesign.sectionSpacing) {
                    VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                        SectionHeaderView(title: "Deck Info")
                        AppTextField(placeholder: "Deck name", text: $viewModel.name, icon: "folder.fill")
                        AppTextField(placeholder: "Icon emoji", text: $viewModel.icon, icon: "face.smiling")
                    }

                    VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                        SectionHeaderView(title: "Add Word", subtitle: "Min 3 associations, comma-separated")
                        AppTextField(placeholder: "Word", text: $viewModel.newWordText, icon: "textformat")
                        AppTextField(
                            placeholder: "Associations (comma separated)",
                            text: $viewModel.newAssociations,
                            icon: "list.bullet"
                        )

                        Picker("Difficulty", selection: $viewModel.selectedDifficulty) {
                            ForEach(Difficulty.allCases, id: \.self) { d in
                                Text(d.displayName).tag(d)
                            }
                        }
                        .pickerStyle(.segmented)

                        Button {
                            viewModel.addWord()
                        } label: {
                            Label("Add Word", systemImage: "plus.circle.fill")
                                .font(.headline)
                                .foregroundColor(themeManager.accentColor)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .glassCard(isSelected: true, cornerRadius: AppDesign.cornerRadiusSmall)
                        }
                        .buttonStyle(PressableCellStyle())
                    }

                    if !viewModel.words.isEmpty {
                        VStack(alignment: .leading, spacing: AppDesign.itemSpacing) {
                            SectionHeaderView(
                                title: "Words",
                                trailing: "\(viewModel.words.count)"
                            )
                            ForEach(viewModel.words) { word in
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text(word.text)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Text(word.difficulty.displayName)
                                            .font(.caption2)
                                            .foregroundColor(themeManager.accentColor)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(themeManager.accentColor.opacity(0.12))
                                            .clipShape(Capsule())
                                    }
                                    Text(word.associations.joined(separator: " • "))
                                        .font(.caption)
                                        .foregroundColor(.appTextSecondary)
                                        .lineLimit(2)
                                }
                                .padding(AppDesign.cellPadding)
                                .glassCard(cornerRadius: AppDesign.cornerRadiusSmall)
                            }
                        }
                    }

                    AnimatedButton(
                        title: "Save Deck",
                        icon: "💾",
                        isEnabled: viewModel.canSave,
                        action: viewModel.save
                    )
                }
                .padding(AppDesign.horizontalPadding)
                .padding(.vertical, 8)
            }
        }
        .appNavigationBar(
            title: viewModel.isEditing ? "Edit Deck" : "New Deck",
            onBack: viewModel.goBack
        )
    }
}
