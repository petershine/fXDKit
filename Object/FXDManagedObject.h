
#import "FXDKit.h"


@import CoreData;


@interface FXDManagedObject : NSManagedObject
@end


@interface NSManagedObject (Essential)
- (void)setValuesForKeysWithDictionary:(NSDictionary*)keyedValues dateFormatter:(NSDateFormatter*)dateFormatter;

@end
