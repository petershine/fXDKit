
#import "FXDKit.h"


#ifndef scaleSceneDismissingOffset
	#define scaleSceneDismissingOffset	0.275
#endif


@interface FXDsceneScroll : FXDViewController <UIScrollViewDelegate, NSFetchedResultsControllerDelegate> {

	NSString *_mainCellIdentifier;
	UINib *_mainCellNib;
	
	NSDictionary *_cellTitleDictionary;
	NSDictionary *_cellSubTitleDictionary;
	NSArray *_itemCounts;
	
	NSMutableArray *_mainDataSource;
	NSFetchedResultsController *_mainResultsController;
	
	FXDOperationQueue *_cellOperationQueue;
	
	UIScrollView *_mainScrollview;
}

@property (nonatomic) BOOL didStartAutoScrollingToTop;

@property (nonatomic) BOOL shouldDismissingByPullingDown;
@property (nonatomic) BOOL didStartDismissingByPullingDown;

@property (nonatomic) CGFloat offsetYdismissingController;

@property (strong, nonatomic) UINib *mainCellNib;
@property (strong, nonatomic) NSString *mainCellIdentifier;

@property (strong, nonatomic) NSArray *itemCounts;
@property (strong, nonatomic) NSDictionary *cellTitleDictionary;
@property (strong, nonatomic) NSDictionary *cellSubTitleDictionary;

@property (strong, nonatomic) NSMutableArray *mainDataSource;
@property (strong, nonatomic) NSFetchedResultsController *mainResultsController;

@property (strong, nonatomic) FXDOperationQueue *cellOperationQueue;

// IBOutlets
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollview;


- (void)registerMainCellNib;

- (BOOL)cancelQueuedCellOperationAtIndexPath:(NSIndexPath*)indexPath orRowIndex:(NSInteger)rowIndex;

- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView;
- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section;

- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView;

@end
