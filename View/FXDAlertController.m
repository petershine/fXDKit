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
+ (instancetype)showAlertWithTitle:(NSString*)title message:(NSString*)message cancelButtonTitle:(NSString*)cancelButtonTitle withAlertCallback:(FXDcallbackAlert)alertCallback {

	__block FXDAlertView *alertView = nil;

	[[NSOperationQueue mainQueue]
	 addOperationWithBlock:^{

		 alertView = [[[self class] alloc]
					  initWithTitle:title
					  message:message
					  cancelButtonTitle:cancelButtonTitle
					  withAlertCallback:alertCallback];

		 [alertView show];
	 }];

	return alertView;
}

#pragma mark -
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


@implementation FXDAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
