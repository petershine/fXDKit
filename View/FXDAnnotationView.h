
#import "FXDimportCore.h"


@import MapKit;

@interface MKAnnotationView (Essential)
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDefaultImage:(UIImage*)defaultImage shouldChangeOffset:(BOOL)shouldChangeOffset;

- (void)animateCustomDropAfterDelay:(NSTimeInterval)delay fromOffset:(CGPoint)offset;

@end
