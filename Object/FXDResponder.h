//
//  FXDResponder.h
//
//
//  Created by petershine on 1/13/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@class FXDAlertView;


@interface FXDResponder : UIResponder <UIApplicationDelegate>

//MARK: To prevent app being affected when state is being changed during launching
@property (nonatomic) BOOL isAppLaunching;
@property (nonatomic) BOOL didFinishLaunching;

@property (strong, nonatomic) UIWindow *window;

@end
