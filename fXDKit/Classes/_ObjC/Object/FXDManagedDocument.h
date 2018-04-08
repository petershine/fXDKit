
#import "FXDimportEssential.h"


@interface FXDManagedDocument : UIManagedDocument {
	NSManagedObjectModel *_manuallyInitializedModel;
}

@property (strong, nonatomic) NSManagedObjectModel *manuallyInitializedModel;

@end
