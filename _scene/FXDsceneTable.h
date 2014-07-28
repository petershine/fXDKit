
#import "FXDKit.h"


#import "FXDsceneScroll.h"
@interface FXDsceneTable : FXDsceneScroll <UITableViewDataSource, UITableViewDelegate>

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
