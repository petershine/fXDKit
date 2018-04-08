
#import "FXDimportEssential.h"
#import "FXDOperationQueue.h"

#define HANGUL_START_CODE   0xAC00
#define HANGUL_END_CODE     0xD79F


#import "FXDsuperModule.h"
@interface FXDmoduleSearch : FXDsuperModule

@property (strong, nonatomic) NSArray *chosung;
@property (strong, nonatomic) NSArray *jungsung;
@property (strong, nonatomic) NSArray *jongsung;

@property (strong, nonatomic) NSMutableArray *searchedObjArray;

@property (strong, nonatomic) NSOperationQueue *searchingOperationQueue;
@property (strong, nonatomic) NSMutableDictionary *searchingOperationDictionary;


- (void)startSearchWithSearchString:(NSString*)searchString withDidFinishBlock:(FXDcallbackFinish)finishCallback;
- (void)cancelSearchWithDidFinishBlock:(FXDcallbackFinish)didFinishBlock;

- (void)deleteSearchedObj:(id)searchedObj;

- (NSPredicate*)predicateWithSearchString:(NSString*)searchString;
- (NSArray*)sortDescriptorsForSearch;

- (BOOL)findSearchString:(NSString*)searchString orChosungString:(NSString*)chosungString usingEncryptionKey:(NSString*)encryptionKey fromEncryptedText:(NSString*)encryptedSourceText;
- (BOOL)searchString:(NSString*)string fromSourceText:(NSString*)sourceText;

- (NSString*)chosungFromNormalKorean:(NSString*)normalKorean;
- (NSString*)jungsungFromNormalKorean:(NSString*)normalKorean;
- (NSString*)jongsungFromNormalKorean:(NSString*)normalKorean;


@end
