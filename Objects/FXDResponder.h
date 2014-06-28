//
//  FXDResponder.h
//
//
//  Created by petershine on 1/13/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//


@interface FXDResponder : UIResponder <UIApplicationDelegate, NSObjectProtocol>

@property (nonatomic) BOOL isAppLaunching;
@property (nonatomic) BOOL didFinishLaunching;

@property (strong, nonatomic) FXDWindow *window;

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
