
#import "FXDimportCore.h"

@import CoreData;


@interface NSManagedObject (Essential)
- (void)setValuesForKeysWithDictionary:(NSDictionary*)keyedValues dateFormatter:(NSDateFormatter*)dateFormatter;

@end
