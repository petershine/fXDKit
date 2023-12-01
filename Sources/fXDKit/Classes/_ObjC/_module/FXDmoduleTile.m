

#import "FXDmoduleTile.h"


@implementation FXDmoduleTile

- (void)prepareTileModule {

	CGRect tileCGRect = [self tileCGRectForMinimumDimension:dimensionMinimumTile];
	MKMapRect tileMapRect = [self tileMapRectForMinimumDiagonalDistance:distanceDiagonalSatelliteMinimum];

	FXDLog_DEFAULT
	FXDLog(@"%@ %@", _Object(MKStringFromMapRect(tileMapRect)), _Rect(tileCGRect));

	CLLocationDistance diagonalDistance = MKMetersBetweenMapPoints(MKMapPointMake(0, 0),
																   MKMapPointMake(tileMapRect.size.width,
																				  tileMapRect.size.height));
	FXDLogVariable(diagonalDistance);
	if (diagonalDistance) {}

	self.tileMapRect = tileMapRect;


	NSInteger multiplier = [UIScreen mainScreen].bounds.size.width/tileCGRect.size.width;
	FXDLogVariable(multiplier);

	Float64 aspectRatio = [UIScreen mainScreen].bounds.size.height/[UIScreen mainScreen].bounds.size.width;
	FXDLogVariable(aspectRatio);

	self.screenMapRect = MKMapRectMake(0,
									   0,
									   tileMapRect.size.width*multiplier,
									   tileMapRect.size.width*multiplier*aspectRatio);

	FXDLogObject(MKStringFromMapRect(self.screenMapRect));
}

#pragma mark -
- (CGRect)tileCGRectForMinimumDimension:(CGFloat)minimumDimension {	FXDLog_DEFAULT
	Float64 dividedBy = 1.0;

	CGRect tileCGRect = [UIScreen mainScreen].bounds;
	FXDLog(@"%f: %@", dividedBy, _Rect(tileCGRect));

	do {
		dividedBy += 1.0;

		if ((NSUInteger)[UIScreen mainScreen].bounds.size.width % (NSUInteger)dividedBy != 0) {
			continue;
		}


		tileCGRect = [UIScreen mainScreen].bounds;
		tileCGRect.size.width /= dividedBy;
		tileCGRect.size.height /= dividedBy;

		FXDLog(@"%lu: %@", (unsigned long)dividedBy, _Rect(tileCGRect));

	} while (tileCGRect.size.width > minimumDimension && dividedBy < 100.0);

	return tileCGRect;
}

- (MKMapRect)tileMapRectForMinimumDiagonalDistance:(CLLocationDistance)minimumDiagonalDistance {	FXDLog_DEFAULT
	Float64 dividedBy = 1.0;

	MKMapRect tileMapRect = MKMapRectWorld;

	CLLocationDistance diagonalDistance = MKMetersBetweenMapPoints(MKMapPointMake(0, 0),
																   MKMapPointMake(tileMapRect.size.width,
																				  tileMapRect.size.height));

	FXDLog(@"%lux%lu: %@ %@", (unsigned long)dividedBy, (unsigned long)dividedBy, MKStringFromMapSize(tileMapRect.size), _Variable(diagonalDistance));

	do {
		dividedBy += 1.0;

		if ((NSUInteger)MKMapRectWorld.size.width % (NSUInteger)dividedBy != 0) {
			continue;
		}


		tileMapRect = MKMapRectWorld;
		tileMapRect.size.width /= dividedBy;
		tileMapRect.size.height /= dividedBy;

		diagonalDistance = MKMetersBetweenMapPoints(MKMapPointMake(0, 0),
													MKMapPointMake(tileMapRect.size.width,
																   tileMapRect.size.height));

		FXDLog(@"%lux%lu = %lu: %@ %@", (unsigned long)dividedBy, (unsigned long)dividedBy, (unsigned long)(dividedBy*dividedBy), MKStringFromMapSize(tileMapRect.size), _Variable(diagonalDistance));

	} while ((NSUInteger)diagonalDistance > minimumDiagonalDistance);

	return tileMapRect;
}
@end
