

@import UIKit;
@import Foundation;


@interface NSMetadataQuery (Essential)
- (BOOL)isQueryResultsTransferring;
@end


@interface NSMetadataItem (Essential)
- (Float64)transferPercentage;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;
@end
