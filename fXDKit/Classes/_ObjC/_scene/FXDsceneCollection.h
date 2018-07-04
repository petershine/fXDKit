
#import "FXDimportEssential.h"


#import "FXDsceneTable.h"
@interface FXDsceneCollection : FXDsceneTable <FXDprotocolTableScene, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *mainCollectionview;

@end
