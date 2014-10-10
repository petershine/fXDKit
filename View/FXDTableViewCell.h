
#import "FXDKit.h"


typedef NS_ENUM(NSInteger, SECTION_POSITION_TYPE) {
	sectionPositionOne,
	sectionPositionTop,
	sectionPositionMiddle,
	sectionPositionBottom
};


@interface FXDTableViewCell : UITableViewCell
@property (nonatomic) SECTION_POSITION_TYPE sectionPositionType;

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