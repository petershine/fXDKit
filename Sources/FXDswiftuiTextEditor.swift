

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


public class FXDobservableTextEditor: ObservableObject {
	@FocusState var focusedEditor: Int?
	@State var editorsVStackHeight: CGFloat = 0.0

	@State var editedParagraph_0: String = ""
	@State var editedParagraph_1: String = ""
	@State var editedText: String = ""

	var finishedEditing: ((String, String, String) -> Void)?

	public init(focusedEditor: Int? = 0,
				editorsVStackHeight: CGFloat = 0.0,
				editedParagraph_0: String,
				editedParagraph_1: String,
				editedText: String = "",
				finishedEditing: ((String, String, String) -> Void)?) {
		
		self.focusedEditor = focusedEditor
		self.editorsVStackHeight = editorsVStackHeight
		self.editedParagraph_0 = editedParagraph_0
		self.editedParagraph_1 = editedParagraph_1
		self.editedText = editedText
		self.finishedEditing = finishedEditing
	}
}


public struct FXDswiftuiTextEditor: View {
	@Environment(\.dismiss) private var dismiss

	@ObservedObject var observable: FXDobservableTextEditor

	public init(observable: FXDobservableTextEditor? = nil) {
		self.observable = observable ?? FXDobservableTextEditor(editedParagraph_0: "", editedParagraph_1: "", finishedEditing: nil)
	}

	public var body: some View {
		GeometryReader { outerGeometry in
			ZStack {
				Color(.black)
					.opacity(0.75)
					.ignoresSafeArea()

				VStack {
					TextEditor(text: observable.$editedParagraph_0)
						.frame(height: self.height(for: 0))
						.focused(observable.$focusedEditor, equals: 0)
						.modifier(FXDTextEditorModifier())

					TextEditor(text: observable.$editedParagraph_1)
						.frame(height: self.height(for: 1))
						.focused(observable.$focusedEditor, equals: 1)
						.modifier(FXDTextEditorModifier())

					TextEditor(text: observable.$editedText)
						.frame(height: self.height(for: 2))
						.focused(observable.$focusedEditor, equals: 2)
						.modifier(FXDTextEditorModifier())
				}
				.onAppear {
					observable.editorsVStackHeight = outerGeometry.size.height
				}
				.onChange(of: outerGeometry.size.height) {
					(oldValue, newValue) in
					observable.editorsVStackHeight = newValue
				}
				.animation(.easeInOut(duration: 0.2), value: observable.focusedEditor)

				VStack {
					Spacer()

					HStack {
						Spacer()

						FXDswiftuiButton(
							systemImageName: "pencil.and.list.clipboard",
							action: {
								observable.finishedEditing?(
									observable.editedParagraph_0,
									observable.editedParagraph_1,
									observable.editedText)
								dismiss()
							})
					}
				}
				.padding()
			}
			.onAppear {
				observable.focusedEditor = 0
			}
		}
	}


	private func height(for editorIndex: Int) -> CGFloat {
		if let focusedEditor = observable.focusedEditor,
			focusedEditor == editorIndex {
			return (observable.editorsVStackHeight * 0.45)
		} else {
			return (observable.editorsVStackHeight * 0.20)
		}
	}
}
