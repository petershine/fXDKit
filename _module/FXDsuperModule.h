//
//  FXDsuperModule.h
//
//
//  Created by petershine on 4/18/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

@import Foundation;
@import UIKit;


//MARK: Subclass should implement its own sharedInstance
@protocol FXDprotocolShared <NSObject>
@required
+ (instancetype)sharedInstance;
@end


@interface FXDsuperModule : NSObject

#pragma mark - Initialization

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end
