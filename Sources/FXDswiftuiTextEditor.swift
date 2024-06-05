

import SwiftUI


struct FXDTextEditorModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.scrollContentBackground(.hidden)
			.backgroundStyle(.black)
			.foregroundStyle(.white)
			.cornerRadius(10.0)
			.overlay {
				RoundedRectangle(cornerRadius: 10.0)
					.stroke(.black, lineWidth:4.0)
			}
			.padding()
	}
}


public struct FXDswiftuiTextEditor: View {
	@Binding var shouldPresentPromptEditor: Bool

	@State var editedParagraph_0: String
	@State var editedParagraph_1: String
	@State var editedText: String? = nil

	@FocusState var focusedEditor: Int?
	@State var editorsVStackHeight: CGFloat = 0.0

	var finishedEditing: ((String, String, String?) -> Void)?


	public init(shouldPresentPromptEditor: Binding<Bool>,
				editedParagraph_0: String,
				editedParagraph_1: String,
				editedText: String? = nil,
				focusedEditor: Int? = 0,
				editorsVStackHeight: CGFloat = 0.0,
				finishedEditing: ((String, String, String?) -> Void)? = nil) {
		
		_shouldPresentPromptEditor = shouldPresentPromptEditor

		self.editedParagraph_0 = editedParagraph_0
		self.editedParagraph_1 = editedParagraph_1
		self.editedText = editedText

		self.focusedEditor = focusedEditor
		self.editorsVStackHeight = editorsVStackHeight

		self.finishedEditing = finishedEditing
	}


	public var body: some View {
		GeometryReader { outerGeometry in
			ZStack {
				Color(.black)
					.opacity(0.75)
					.ignoresSafeArea()

				VStack {
					TextEditor(text: $editedParagraph_0)
						.frame(height: self.height(for: 0))
						.focused($focusedEditor, equals: 0)
						.modifier(FXDTextEditorModifier())

					TextEditor(text: $editedParagraph_1)
						.frame(height: self.height(for: 1))
						.focused($focusedEditor, equals: 1)
						.modifier(FXDTextEditorModifier())

					TextEditor(text: Binding.constant(editedText ?? ""))
						.frame(height: self.height(for: 2))
						.focused($focusedEditor, equals: 2)
						.modifier(FXDTextEditorModifier())
				}
				.onAppear {
					editorsVStackHeight = outerGeometry.size.height
				}
				.onChange(of: outerGeometry.size.height) {
					(oldValue, newValue) in
					editorsVStackHeight = newValue
				}
				.animation(.easeInOut(duration: 0.2), value: focusedEditor)

				VStack {
					Spacer()

					HStack {
						Spacer()

						FXDswiftuiButton(
							systemImageName: "pencil.and.list.clipboard",
							foregroundStyle: .white,
							action: {
								finishedEditing?(editedParagraph_0, editedParagraph_1, editedText)
								shouldPresentPromptEditor = false
							})
					}
				}
				.padding()
			}
			.onAppear {
				focusedEditor = 0
			}
		}
	}


	private func height(for editorIndex: Int) -> CGFloat {
		if let focusedEditor = focusedEditor,
			focusedEditor == editorIndex {
			return (editorsVStackHeight * 0.45)
		} else {
			return (editorsVStackHeight * 0.20)
		}
	}
}
