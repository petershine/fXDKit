

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

	@FocusState var focusedEditor: Int?
	@State var editorsVStackHeight: CGFloat = 0.0

	var finishedEditing: ((String, String) -> Void)?


	public init(shouldPresentPromptEditor: Binding<Bool>,
				editedParagraph_0: String,
				editedParagraph_1: String,
				focusedEditor: Int? = 0,
				editorsVStackHeight: CGFloat = 0.0,
				finishedEditing: ((String, String) -> Void)? = nil) {
		
		_shouldPresentPromptEditor = shouldPresentPromptEditor

		self.editedParagraph_0 = editedParagraph_0
		self.editedParagraph_1 = editedParagraph_1

		self.focusedEditor = focusedEditor
		self.editorsVStackHeight = editorsVStackHeight

		self.finishedEditing = finishedEditing
	}


	public var body: some View {
		ZStack {
			Color(.black)
				.opacity(0.75)
				.ignoresSafeArea()

			GeometryReader { outerGeometry in
				VStack {
					TextEditor(text: $editedParagraph_0)
						.frame(height: self.height(for: 0))
						.focused($focusedEditor, equals: 0)
						.modifier(FXDTextEditorModifier())

					TextEditor(text: $editedParagraph_1)
						.frame(height: self.height(for: 1))
						.focused($focusedEditor, equals: 1)
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
			}

			VStack {
				Spacer()

				HStack {
					Spacer()

					FXDswiftuiButton(
						systemImageName: "checkmark.circle",
						foregroundStyle: .white,
						action: {
							finishedEditing?(editedParagraph_0, editedParagraph_1)
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


	private func height(for editorIndex: Int) -> CGFloat {
		if let focusedEditor = focusedEditor,
			focusedEditor == editorIndex {
			return (editorsVStackHeight * 0.45)
		} else {
			return (editorsVStackHeight * 0.20)
		}
	}
}
