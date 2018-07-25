
#import "FXDimportEssential.h"
#import "FXDOperationQueue.h"

#define scaleSceneDismissingOffset	0.275


@protocol FXDsceneWithCells
@required
@property (strong, nullable, nonatomic, readonly) NSString *mainCellIdentifier;
@property (strong, nullable, nonatomic, readonly) UINib *mainCellNib;
@property (strong, nonatomic, readonly) NSArray *itemCounts;
- (void)registerMainCellNib;
- (NSInteger)numberOfSectionsForScrollView:(UIScrollView*)scrollView;
- (NSInteger)numberOfItemsForScrollView:(UIScrollView*)scrollView atSection:(NSInteger)section;
@end

@interface FXDsceneScroll : UIViewController <UIScrollViewDelegate> {
	
	NSMutableArray *_mainDataSource;
	
	NSOperationQueue *_cellOperationQueue;
	NSMutableDictionary *_cellOperationDictionary;
}

@property (nonatomic) BOOL didStartAutoScrollingToTop;

@property (nonatomic) BOOL shouldDismissingByPullingDown;
@property (nonatomic) BOOL didStartDismissingByPullingDown;

@property (nonatomic) CGFloat offsetYdismissingController;

@property (strong, nonatomic) NSMutableArray *mainDataSource;

@property (strong, nonatomic) NSOperationQueue *cellOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *cellOperationDictionary;


@property (strong, nullable, nonatomic) IBOutlet UIScrollView *mainScrollview;

- (void)dismissByPullingDownScrollView:(UIScrollView*)scrollView;

@end
