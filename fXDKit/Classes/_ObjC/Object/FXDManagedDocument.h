

#import "FXDimportCore.h"

@import UIKit;
@import Foundation;

@import CoreData;


@interface FXDManagedDocument : UIManagedDocument {
	NSManagedObjectModel *_manuallyInitializedModel;
}

@property (strong, nonatomic) NSManagedObjectModel *manuallyInitializedModel;

@end