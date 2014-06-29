//
//  FXDsuperPushManager.h
//
//
//  Created by petershine on 4/30/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef urbanairshipDevelopmentKey
#endif

#ifndef urbanairshipDevelopmentSecret
#endif

#ifndef urbanairshipProductionKey
#warning //TODO: Define urbanairshipProductionKey
#endif

#ifndef urbanairshipProductionSecret
#warning //TODO: Define urbanairshipProductionSecret
#endif


#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "UALocationService.h"


#import "FXDsuperManager.h"
@interface FXDsuperPushManager : FXDsuperManager

#pragma mark - Initialization

#pragma mark - Public
- (void)preparePushManager;

- (void)updateMainAlias:(NSString*)aliasString;
- (void)activateLocationReporting;


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
