//
//  FXDsuperManager.h
//
//
//  Created by petershine on 4/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@protocol FXDsuperManagerProtocol <NSObject>
@required
+ (instancetype)sharedInstance;
@end


@interface FXDsuperManager : FXDObject <FXDsuperManagerProtocol>

#pragma mark - Initialization

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
