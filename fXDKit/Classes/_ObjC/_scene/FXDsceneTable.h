
#import "FXDimportEssential.h"
#import "FXDTableViewCell.h"

#import "FXDsceneScroll.h"


@protocol FXDprotocolTableScene <FXDprotocolScrollScene>
@end

@interface FXDsceneTable : FXDsceneScroll <FXDprotocolScrollScene, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *mainTableview;


- (void)initializeTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;
- (void)configureTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (void)configureSectionPostionTypeForTableCell:(FXDTableViewCell*)cell forIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)backgroundImageForTableCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)selectedBackgroundImageForTableCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIImage*)mainImageForTableCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIImage*)highlightedMainImageForTableCellAtIndexPath:(NSIndexPath*)indexPath;
- (UIView*)accessoryViewForTableCellAtIndexPath:(NSIndexPath*)indexPath;

- (UIView*)sectionDividerViewForWidth:(CGFloat)width andHeight:(CGFloat)height;

@end
