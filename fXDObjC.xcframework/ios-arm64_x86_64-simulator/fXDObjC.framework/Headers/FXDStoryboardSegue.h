
#import <fXDObjC/FXDimportEssential.h>


@interface FXDStoryboardSegue : UIStoryboardSegue
@end


@interface UIStoryboardSegue (Essential)

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL shouldUseNavigationPush;

- (id)mainContainerOfClass:(Class)classObject;	//"id" is utilized to avoid "Cast from 'FXDsegueCover?' to unrelated type failure"

@end


#pragma mark - Subclass
@interface FXDsegueEmbedding : FXDStoryboardSegue
@end
