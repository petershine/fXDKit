

extension UIWindow {
	@objc public class func newWindow(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIWindow? {	fxd_log()
		guard nibName == nil else {
			let newWindow: UIWindow? = self.view(fromNibName: nibName!, owner: owner) as! UIWindow?
			return newWindow
		}

		
		let screenBounds = UIScreen.main.bounds
		fxdPrint("screenBounds: \(screenBounds)")
		fxdPrint("UIScreen.main.nativeBounds: \(UIScreen.main.nativeBounds)")
		fxdPrint("UIScreen.main.nativeScale: \(UIScreen.main.nativeScale)")

		let newWindow: UIWindow? = self.init(frame: screenBounds)
		newWindow?.autoresizesSubviews = true

		return newWindow
	}

    @objc public func configure(rootScene: UIViewController?, shouldAnimate: Bool, willBecomeBlock: () -> Void, didBecomeBlock: () -> Void, finishCallback: FXDcallback) {    fxd_log()

        /*
        //MARK: fade in and replace rootViewController. DO NOT USE addChildViewController
        if (shouldAnimate == NO) {
            if (willBecomeBlock) {
                willBecomeBlock();
            }

            self.rootViewController = rootScene;

            if (didBecomeBlock) {
                didBecomeBlock();
            }

            if (finishCallback) {
                finishCallback(_cmd, YES, nil);
            }
            return;
        }


        UIViewController *previousRootScene = self.rootViewController;

        if (willBecomeBlock) {
            willBecomeBlock();
        }

        self.rootViewController = rootScene;

        [self addSubview:previousRootScene.view];


        if (didBecomeBlock) {
            didBecomeBlock();
        }

        if ([previousRootScene isKindOfClass:NSClassFromString(@"FXDsceneLaunching")]) {

            [previousRootScene
                dismissFadingOutWithCallback:^(BOOL finished, id _Nullable responseObj) {
                FXDLogBOOL(finished);

                [previousRootScene.view removeFromSuperview];

                if (finishCallback) {
                finishCallback(_cmd, finished, responseObj);
                }
                }];

            return;
        }


        [UIView
            animateWithDuration:durationOneSecond
            delay:0.0
            options:UIViewAnimationOptionCurveEaseIn
            animations:^{
            previousRootScene.view.alpha = 0.0;
            }
            completion:^(BOOL didFinish) {

            [previousRootScene.view removeFromSuperview];

            if (finishCallback) {
            finishCallback(_cmd, YES, nil);
            }
            }];*/
    }
}
