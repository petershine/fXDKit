
#import "FXDKit.h"


#import "FXDsceneTable.h"
@interface FXDsceneCollection : FXDsceneTable <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

// IBOutlets
@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionview;

@end
