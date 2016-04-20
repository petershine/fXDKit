//
//  FXDAlertController.m
//  PopToo2016
//
//  Created by petershine on 6/24/15.
//  Copyright © 2015 fXceed. All rights reserved.
//

#import "FXDAlertController.h"


@implementation FXDActionSheet

- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObject(_alertCallback);
	_alertCallback = nil;
}

#pragma mark - Initialization
- (instancetype)initWithTitle:(NSString *)title withButtonTitleArray:(NSArray*)buttonTitleArray cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback {	FXDLog_DEFAULT;

	self = [super initWithTitle:title
					   delegate:nil
			  cancelButtonTitle:cancelButtonTitle
		 destructiveButtonTitle:destructiveButtonTitle
			  otherButtonTitles:nil];

	if (self) {
		self.delegate = self;
		self.alertCallback = alertCallback;
	}

	return self;
}

#pragma mark - Delegate
- (void)actionSheet:(FXDActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (actionSheet.alertCallback) {
		actionSheet.alertCallback(actionSheet, buttonIndex);
	}
}

@end


@implementation FXDAlertView

- (void)dealloc {	FXDLog_DEFAULT;
	FXDLogObject(_alertCallback);
	_alertCallback = nil;
}

#pragma mark - Initialization
- (instancetype)initWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback {

	//NOTE: Assume this is the condition for simple alerting without choice
	if (cancelButtonTitle == nil) {
		cancelButtonTitle = NSLocalizedString(@"OK", nil);
	}

	self = [super
			initWithTitle:title
			message:message
			delegate:nil
			cancelButtonTitle:cancelButtonTitle
			otherButtonTitles:nil];

	if (self) {
		self.delegate = self;
		self.alertCallback = alertCallback;
	}

	return self;
}

#pragma mark - Delegate
- (void)alertView:(FXDAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

	if (alertView.alertCallback) {
		alertView.alertCallback(alertView, buttonIndex);
	}
}

@end


@implementation FXDAlertAction : UIAlertAction
@end


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
+ (instancetype)showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback {

	//NOTE: Assume this is the condition for simple alerting without choice
	if (cancelButtonTitle == nil) {
		cancelButtonTitle = NSLocalizedString(@"OK", nil);
	}


	FXDAlertController *alertController =
	[[self class]
	 alertControllerWithTitle:title
	 message:message
	 preferredStyle:UIAlertControllerStyleAlert];


	FXDAlertAction *cancelAction =
	[FXDAlertAction
	 actionWithTitle:cancelButtonTitle
	 style:UIAlertActionStyleCancel
	 handler:^(UIAlertAction * _Nonnull action) {
		 if (alertCallback) {
			 alertCallback(alertController, 0);
		 }
	 }];

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
