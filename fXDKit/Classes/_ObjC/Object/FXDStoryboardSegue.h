
#import <fXDObjC/FXDimportEssential.h>


@interface FXDStoryboardSegue : UIStoryboardSegue
@end


@interface UIStoryboardSegue (Essential)

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL shouldUseNavigationPush;

- (id)mainContainerOfClass:(Class)class;

@end


#pragma mark - Subclass
@interface FXDsegueEmbedding : FXDStoryboardSegue
@end
