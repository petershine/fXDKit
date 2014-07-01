//
//  FXDStoryboardSegue.h
//
//
//  Created by petershine on 5/27/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//


@interface FXDStoryboardSegue : UIStoryboardSegue
@end


#pragma mark - Category
@interface UIStoryboardSegue (Essential)
- (NSDictionary*)fullDescription;

- (BOOL)shouldUseNavigationPush;

- (id)mainContainerOfClass:(Class)class;

@end


#pragma mark - Subclass
@interface FXDsuperEmbedSegue : FXDStoryboardSegue
@end

@interface FXDsuperTransitionSegue : FXDStoryboardSegue
@end
