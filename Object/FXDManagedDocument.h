
#import "FXDimportCore.h"

@import CoreData;


@interface FXDManagedDocument : UIManagedDocument {
	NSManagedObjectModel *_manuallyInitializedModel;
}

@property (strong, nonatomic) NSManagedObjectModel *manuallyInitializedModel;

@end
