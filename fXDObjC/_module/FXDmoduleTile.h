
#import <fXDObjC/FXDimportEssential.h>


//MARK: distance value is x10 of real meters
#define distanceDiagonalTenthKilo	1190.0
#define distanceDiagonalFirstKilo	148.0

#define dimensionMinimumTile	32.0
#define distanceDiagonalSatelliteMinimum	37.0


@interface FXDmoduleTile : NSObject

@property (nonatomic) MKMapRect tileMapRect;
@property (nonatomic) MKMapRect screenMapRect;


- (void)prepareTileModule;

- (CGRect)tileCGRectForMinimumDimension:(CGFloat)minimumDimension;
- (MKMapRect)tileMapRectForMinimumDiagonalDistance:(CLLocationDistance)minimumDiagonalDistance;

@end
