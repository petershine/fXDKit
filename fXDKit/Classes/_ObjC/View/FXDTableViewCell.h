
#import "FXDimportEssential.h"

typedef NS_ENUM(NSInteger, SectionPlacement) {
	SectionPlacementOne,
	SectionPlacementTop,
	SectionPlacementMiddle,
	SectionPlacementBottom
};


@interface FXDTableViewCell : UITableViewCell
@property (nonatomic) SectionPlacement sectionPositionCase;

@property (strong, nonatomic) id addedObj;


@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageview;


- (void)customizeBackgroundWithImage:(UIImage*)image withHighlightedImage:(UIImage*)highlightedImage;

@end


@interface UITableViewCell (Essential)
- (void)customizeWithMainImage:(UIImage*)mainImage withHighlightedMainImage:(UIImage*)highlightedMainImage;

- (void)modifySizeOfCellSubview:(UIView*)cellSubview;
- (void)modifyOriginXofCellSubview:(UIView*)cellSubview;
- (void)modifyOriginYofCellSubview:(UIView*)cellSubview;

@end