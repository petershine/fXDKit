
#import <fXDObjC/FXDimportEssential.h>

typedef NS_ENUM(NSInteger, SectionPosition) {
	single,
	top,
	middle,
	bottom
};


@interface FXDTableViewCell : UITableViewCell
@property (nonatomic) SectionPosition positionCase;

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
