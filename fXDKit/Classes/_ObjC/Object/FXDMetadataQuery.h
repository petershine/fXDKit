
#import <fXDObjC/FXDimportEssential.h>


@interface NSMetadataQuery (Essential)
@property (NS_NONATOMIC_IOSONLY, getter=isQueryResultsTransferring, readonly) BOOL queryResultsTransferring;
@end


@interface NSMetadataItem (Essential)
@property (NS_NONATOMIC_IOSONLY, readonly) Float64 transferPercentage;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *unicodeAbsoluteString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *attributeModificationDate;
@end
