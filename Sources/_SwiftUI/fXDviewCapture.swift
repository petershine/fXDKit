

import fXDObjC

import SwiftUI
import UIKit
import Foundation


public struct fXDviewCapture: View, UIViewControllerRepresentable {
	public init() {

	}
	
	public func makeUIViewController(context: Context) -> FXDCaptureController {
		return FXDCaptureController(nibName: nil, bundle: nil)
	}

	public func updateUIViewController(_ uiViewController: FXDCaptureController, context: Context) {
	}
}


open class FXDCaptureController: UIViewController, @unchecked Sendable {
	nonisolated fileprivate lazy var fxdCaptureModule: FXDmoduleCapture? = {
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
