

#import "FXDimportCore.h"

@import UIKit;
@import Foundation;


@interface FXDStoryboardSegue : UIStoryboardSegue
@end


@interface UIStoryboardSegue (Essential)
- (NSDictionary*)fullDescription;

- (BOOL)shouldUseNavigationPush;

- (id)mainContainerOfClass:(Class)class;

@end


#pragma mark - Subclass
@interface FXDsegueEmbedding : FXDStoryboardSegue
@end
