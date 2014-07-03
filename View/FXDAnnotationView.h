
#import "FXDKit.h"


@import MapKit;


@interface FXDAnnotation : MKPointAnnotation
@property (strong, nonatomic) id addedObj;
@end


@interface FXDAnnotationView : MKAnnotationView
@end


@interface MKAnnotationView (Essential)
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDefaultImage:(UIImage*)defaultImage shouldChangeOffset:(BOOL)shouldChangeOffset;

- (void)animateCustomDropAfterDelay:(NSTimeInterval)delay fromOffset:(CGPoint)offset;

@end
