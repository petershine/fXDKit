//
//  FXDsuperLaunchImageController.h
//
//
//  Created by petershine on 12/17/12.
//  Copyright (c) 2012 fXceed All rights reserved.
//

#ifndef imageDefaulLaunch
	#define imageDefaulLaunch	@"Default"
#endif

#ifndef imageDefaulLaunch568h
	#define imageDefaulLaunch568h	@"Default-568h"
#endif


@interface FXDsuperLaunchController : FXDViewController
// Properties

// IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *imageviewDefault;


#pragma mark - Segues

#pragma mark - IBActions

#pragma mark - Public
- (void)dismissLaunchControllerWithDidFinishBlock:(FXDblockDidFinish)didFinishBlock;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
