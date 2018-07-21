
#import "FXDimportEssential.h"
#import "FXDOperationQueue.h"

#define scaleSceneDismissingOffset	0.275


@protocol FXDsceneWithCells
@required
- (void)registerMainCellNib;
- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView;
- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section;

@end

@interface FXDsceneScroll : UIViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate> {

	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;
	
	NSDictionary *_cellTitleDictionary;
	NSDictionary *_cellSubTitleDictionary;
	NSArray *_itemCounts;
	
	NSMutableArray *_mainDataSource;
	NSFetchedResultsController *_mainResultsController;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_cellOperationDictionary;
	
	UIScrollView *_mainScrollview;
}

@property (nonatomic) BOOL didStartAutoScrollingToTop;

@property (nonatomic) BOOL shouldDismissingByPullingDown;
@property (nonatomic) BOOL didStartDismissingByPullingDown;

@property (nonatomic) CGFloat offsetYdismissingController;

@property (strong, nullable, nonatomic) UINib *mainCellNib;
@property (strong, nullable, nonatomic) NSString *mainCellIdentifier;

@property (strong, nonatomic) NSArray *itemCounts;
@property (strong, nonatomic) NSDictionary *cellTitleDictionary;
@property (strong, nonatomic) NSDictionary *cellSubTitleDictionary;

@property (strong, nonatomic) NSMutableArray *mainDataSource;
@property (strong, nonatomic) NSFetchedResultsController *mainResultsController;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *cellOperationDictionary;


@property (strong, nullable, nonatomic) IBOutlet UIScrollView *mainScrollview;

- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView;

@end
