//
//  FXDsuperManager.h
//
//
//  Created by petershine on 4/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#warning //MARK: Necessary for inheriting sharedInstance initializer
@protocol FXDprotocolInitializer <NSObject>
@required
+ (instancetype)sharedInstance;
@end


@interface FXDsuperManager : FXDObject <FXDprotocolInitializer>

#pragma mark - Initialization

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
