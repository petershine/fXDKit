//
//  FXDAnnotationView.h
//
//
//  Created by petershine on 5/11/12.
//  Copyright (c) 2012 fXceed. All rights reserved.
//

@import MapKit;


@interface FXDAnnotation : MKPointAnnotation
@property (strong, nonatomic) id addedObj;
@end


@interface FXDAnnotationView : MKAnnotationView

// IBOutlets

#pragma mark - IBActions

#pragma mark - Public

//MARK: - Observer implementation

//MARK: - Delegate implementation

@end


#pragma mark - Category
@interface MKAnnotationView (Essential)
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier withDefaultImage:(UIImage*)defaultImage shouldChangeOffset:(BOOL)shouldChangeOffset;

- (void)animateCustomDropAfterDelay:(NSTimeInterval)delay fromOffset:(CGPoint)offset;

@end
