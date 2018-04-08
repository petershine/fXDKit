
#import "FXDimportEssential.h"

typedef NS_ENUM(NSInteger, FILE_KIND_TYPE) {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie
};


@interface NSURL (Essential)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary *fullResourceValues;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *unicodeAbsoluteString;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *attributeModificationDate;

@property (NS_NONATOMIC_IOSONLY, readonly) FILE_KIND_TYPE fileKindType;

- (NSString*)followingPathAfterPathComponent:(NSString*)pathComponent;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *followingPathInDocuments;

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *fileSizeString;

+ (BOOL)validateURL:(NSString*)candidate;
+ (BOOL)isHTTPcompatible:(NSString*)candidate;

+ (NSURL*)evaluatedURLforPath:(NSString*)requestPath;
@end
