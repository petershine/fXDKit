//
//  FXDStoryboardSegue.h
//
//
//  Created by petershine on 5/27/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDStoryboardSegue : UIStoryboardSegue

// Properties


#pragma mark - Public


//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface UIStoryboardSegue (Added)
- (NSDictionary*)fullDescription;

- (BOOL)shouldUseNavigationPush;

@end


#pragma mark - Subclass
@interface FXDsegueTransition : FXDStoryboardSegue
@end
