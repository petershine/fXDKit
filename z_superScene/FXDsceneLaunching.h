//
//  FXDsceneLaunching.h
//
//
//  Created by petershine on 12/17/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//


@interface FXDsceneLaunching : FXDViewController

// IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *imageviewDefault;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)dismissLaunchSceneWithFinishCallback:(FXDcallbackFinish)finishCallback;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
