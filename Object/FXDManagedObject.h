
@import CoreData;

#import "FXDKit.h"


@interface NSManagedObject (Essential)
- (void)setValuesForKeysWithDictionary:(NSDictionary*)keyedValues dateFormatter:(NSDateFormatter*)dateFormatter;

@end
