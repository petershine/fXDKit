
@import UIKit;
@import Foundation;


@interface NSString (Essential)
+ (NSString*)uniqueKeyFrom:(Float64)doubleValue;
+ (NSString*)uniqueFilenameWithWithPrefix:(NSString*)prefix forType:(CFStringRef)type;
+ (NSString*)filenameWithWithPrefix:(NSString*)prefix withUniqueKey:(NSString*)uniqueKey forType:(CFStringRef)type;

- (NSString*)leftAlignedParagraph;

- (NSString*)stringByCompressingWhitespaceTo:(NSString*)seperator;

@end
