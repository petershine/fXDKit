
#import "FXDKit.h"


@interface FXDNumber : NSNumber
@end


@interface NSNumber (Essential)
- (NSString*)byteUnitFormatted;
- (NSString*)timerUnitFormatted;

@end
