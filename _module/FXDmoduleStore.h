
#define userdefaultObjVerifiedReceipt	@"VerifiedReceiptObjKey"

#import "FXDKit.h"


@import StoreKit;

@interface FXDmoduleStore : FXDsuperModule <SKProductsRequestDelegate> {
	BOOL _didPurchasePremiumUpgrade;
	NSArray *_productIdentifiers;
}

@property (nonatomic) BOOL didPurchasePremiumUpgrade;
@property (strong, nonatomic) NSArray *productIdentifiers;


- (void)prepareStoreManager;

- (void)verifyAppStoreReceiptWithValidationURL:(NSURL*)validationURL withFinishCallback:(FXDcallbackFinish)finishCallback;

- (void)logAboutReceiptDictionary:(NSDictionary*)receiptDictionary;

@end
