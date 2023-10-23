

import fXDObjC

import SwiftUI
import UIKit
import Foundation


public struct FXDswiftuiCapture: View, UIViewControllerRepresentable {
	public init() {

	}
	
	public func makeUIViewController(context: Context) -> FXDswiftuiCaptureController {
		return FXDswiftuiCaptureController(nibName: nil, bundle: nil)
	}

	public func updateUIViewController(_ uiViewController: FXDswiftuiCaptureController, context: Context) {
	}
}

#Preview {
	FXDswiftuiCapture()
}


open class FXDswiftuiCaptureController: UIViewController {
	fileprivate lazy var fxdCaptureModule: FXDmoduleCapture? = {
		return FXDmoduleCapture()
	}()

	deinit {
		fxdCaptureModule = nil
	}

	open override func viewDidLoad() {
		super.viewDidLoad()

		fxdCaptureModule?.prepareAndStartManager(self.view)
	}
}
