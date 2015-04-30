
@import UIKit;
@import Foundation;


typedef NS_ENUM(NSInteger, FILE_KIND_TYPE) {
	fileKindUndefined,
	fileKindImage,
	fileKindDocument,
	fileKindAudio,
	fileKindMovie
};


@interface NSURL (Essential)
- (NSDictionary*)resourceValuesForUbiquitousItemKeysWithError:(NSError**)error;
- (NSDictionary*)fullResourceValues;

- (NSString*)unicodeAbsoluteString;
- (NSDate*)attributeModificationDate;

- (FILE_KIND_TYPE)fileKindType;

- (NSString*)followingPathAfterPathComponent:(NSString*)pathComponent;
- (NSString*)followingPathInDocuments;

- (NSString*)fileSizeString;

+ (BOOL)validateURL:(NSString*)candidate;
+ (BOOL)isHTTPcompatible:(NSString*)candidate;

@end
