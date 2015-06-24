

@import UIKit;
@import Foundation;

#import "FXDmacroFunction.h"


@interface NSMetadataQuery (Essential)
- (BOOL)isQueryResultsTransferring;
@end


@interface NSMetadataItem (Essential)
- (Float64)transferPercentage;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;
@end
