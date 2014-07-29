
@import CoreData;

#import "FXDKit.h"


@interface FXDManagedDocument : UIManagedDocument {
	NSManagedObjectModel *_manuallyInitializedModel;
}

@property (strong, nonatomic) NSManagedObjectModel *manuallyInitializedModel;

@end
