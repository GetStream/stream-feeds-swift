//
// Copyright © 2026 Stream.io Inc. All rights reserved.
//

import StreamCore
import StreamFeeds
import SwiftUI

public struct CreatePollView: View {
    private let colors = Colors.shared
        
    @StateObject var viewModel: CreatePollViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @Environment(\.editMode) var editMode
    
    @State private var listId = UUID()
    
    var onDismiss: () -> Void
    
    public init(feed: Feed, onDismiss: @escaping () -> Void) {
        _viewModel = StateObject(
            wrappedValue: CreatePollViewModel(feed: feed)
        )
        self.onDismiss = onDismiss
    }
                
    public var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Question")
                        .modifier(ListRowModifier())
                        .padding(.bottom, 4)
                    TextField("Ask a question", text: $viewModel.question)
                        .modifier(CreatePollItemModifier())
                }
                .modifier(ListRowModifier())
                                
                Text("Options")
                    .modifier(ListRowModifier())
                    .padding(.bottom, -16)
                
                ForEach(viewModel.options.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            if viewModel.showsOptionError(for: index) {
                                Text("Duplicate option")
                                    .foregroundColor(Color(colors.alert))
                                    .font(.caption)
                                    .transition(.opacity)
                            }
                            TextField("Add option", text: Binding(
                                get: { viewModel.options[index] },
                                set: { newValue in
                                    viewModel.options[index] = newValue
                                    // Check if the current text field is the last one
                                    if index == viewModel.options.count - 1,
                                       !newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                        // Add a new text field
                                        withAnimation {
                                            viewModel.options.append("")
                                        }
                                    }
                                }
                            ))
                        }
                        Spacer()
                        if index < viewModel.options.count - 1 {
                            Image(systemName: "equal")
                                .foregroundColor(Color(colors.textLowEmphasis))
                        }
                    }
                    .padding(.vertical, viewModel.showsOptionError(for: index) ? -8 : 0)
                    .modifier(CreatePollItemModifier())
                    .moveDisabled(index == viewModel.options.count - 1)
                    .animation(.easeIn, value: viewModel.optionsErrorIndices)
                }
                .onMove(perform: move)
                .onDelete { indices in
                    // Allow deletion of any text field
                    viewModel.options.remove(atOffsets: indices)
                }
                .modifier(ListRowModifier())
                                
                if viewModel.multipleAnswersShown {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Multiple Answers", isOn: $viewModel.multipleAnswers)
                        if viewModel.multipleAnswers {
                            HStack(alignment: .textFieldToggle) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Insert number from 1 to 10")
                                        .foregroundColor(Color(colors.alert))
                                        .font(.caption)
                                        .offset(y: viewModel.showsMaxVotesError ? 0 : 6)
                                        .opacity(viewModel.showsMaxVotesError ? 1 : 0)
                                        .animation(.easeIn, value: viewModel.showsMaxVotesError)
                                    TextField("Max votes per person", text: $viewModel.maxVotes)
                                        .alignmentGuide(.textFieldToggle, computeValue: { $0[VerticalAlignment.center] })
                                        .disabled(!viewModel.maxVotesEnabled)
                                }
                                .accessibilityElement(children: .combine)
                                if viewModel.maxVotesShown {
                                    Toggle("", isOn: $viewModel.maxVotesEnabled)
                                        .alignmentGuide(.textFieldToggle, computeValue: { $0[VerticalAlignment.center] })
                                        .frame(width: 64)
                                }
                            }
                            .padding(.top, 8)
                        }
                    }
                    .modifier(CreatePollItemModifier())
                    .padding(.top, 16)
                }
                
                if viewModel.anonymousPollShown {
                    Toggle("Anonymous Poll", isOn: $viewModel.anonymousPoll)
                        .modifier(CreatePollItemModifier())
                }
                
                if viewModel.suggestAnOptionShown {
                    Toggle("Suggest Option", isOn: $viewModel.suggestAnOption)
                        .modifier(CreatePollItemModifier())
                }
                
                if viewModel.addCommentsShown {
                    Toggle("Add Comment", isOn: $viewModel.allowComments)
                        .modifier(CreatePollItemModifier())
                }
                
                Spacer()
                    .modifier(ListRowModifier())
            }
            .background(Color(colors.background).ignoresSafeArea())
            .listStyle(.plain)
            .id(listId)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        if viewModel.canShowDiscardConfirmation {
                            viewModel.discardConfirmationShown = true
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text("Cancel")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Create Poll")
                        .bold()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.createPoll {
                            Task { @MainActor in
                                presentationMode.wrappedValue.dismiss()
                                onDismiss()
                            }
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(colors.tintColor)
                    }
                    .disabled(!viewModel.canCreatePoll)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .actionSheet(isPresented: $viewModel.discardConfirmationShown) {
                ActionSheet(
                    title: Text("Discard Poll"),
                    buttons: [
                        .destructive(Text("Discard Changes")) {
                            presentationMode.wrappedValue.dismiss()
                        },
                        .cancel(Text("Keep Editing"))
                    ]
                )
            }
            .alert(isPresented: $viewModel.errorShown) {
                Alert.defaultErrorAlert
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.options.move(fromOffsets: source, toOffset: destination)
        listId = UUID()
    }
}

struct CreatePollItemModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(ListRowModifier())
            .withPollsBackground()
            .padding(.vertical, -4)
    }
}

struct ListRowModifier: ViewModifier {
    let colors = Colors.shared

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content
                .listRowSeparator(.hidden)
                .listRowBackground(Color(colors.background))
        } else {
            content
        }
    }
}

private extension VerticalAlignment {
    private struct TextFieldToggleAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }

    /// Alignment for a text field with extra text and a toggle.
    static let textFieldToggle = VerticalAlignment(
        TextFieldToggleAlignment.self
    )
}

extension Alert {
    public static var defaultErrorAlert: Alert {
        Alert(
            title: Text("Error"),
            message: Text("There was an error, please try again."),
            dismissButton: .cancel(Text("OK"))
        )
    }
}
