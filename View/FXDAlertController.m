

#import "FXDAlertController.h"


@implementation FXDAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
+ (_Nonnull instancetype)simpleAlertWithTitle:(nullable NSString*)title message:(nullable NSString*)message cancelButtonTitle:(nullable NSString*)cancelButtonTitle withAlertHandler:(void (^ __nullable)(UIAlertAction *_Nonnull action))alertHandler {

	//MARK: Assume this is the condition for simple alerting without choice
	if (cancelButtonTitle == nil) {
		cancelButtonTitle = NSLocalizedString(@"OK", nil);
	}

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
														   style:UIAlertActionStyleCancel
														 handler:alertHandler];


	FXDAlertController *alertController = [[self class] alertControllerWithTitle:title
																		 message:message
																  preferredStyle:UIAlertControllerStyleAlert];

	[alertController addAction:cancelAction];


	UIWindow *currentWindow = (UIWindow*)[UIApplication sharedApplication].windows.lastObject;
	FXDLogObject(currentWindow);

	UIViewController *rootScene = currentWindow.rootViewController;
	FXDLogObject(rootScene);

	[rootScene
	 presentViewController:alertController
	 animated:YES
	 completion:nil];

	return alertController;
}

@end
