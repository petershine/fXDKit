

@import StoreKit;

#define userdefaultObjVerifiedReceipt	@"VerifiedReceiptObjKey"

#define validationURLSandbox	[NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"]
#define validationURLProduction	[NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"]


#import "FXDimportAdopted.h"


#import "FXDsuperModule.h"
@interface FXDmoduleStore : FXDsuperModule <SKProductsRequestDelegate> {
	BOOL _didPurchasePremiumUpgrade;
	NSArray *_productIdentifiers;
}

@property (nonatomic) BOOL didPurchasePremiumUpgrade;
@property (strong, nonatomic) NSArray *productIdentifiers;


- (void)prepareStoreManager;

- (void)verifyAppStoreReceiptWithValidationURL:(NSURL*)validationURL withFinishCallback:(FXDcallbackFinish)finishCallback;
- (void)verifyReceiptURL:(NSURL*)receiptURL withValidationURL:(NSURL*)validationURL withCallback:(FXDcallbackFinish)finishCallback;

- (void)logAboutReceiptDictionary:(NSDictionary*)receiptDictionary;

@end
