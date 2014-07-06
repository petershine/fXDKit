

#import "FXDKit.h"


#ifndef urbanairshipDevelopmentKey
	#warning //TODO: Define urbanairshipDevelopmentKey
	#define urbanairshipDevelopmentKey	@""
#endif

#ifndef urbanairshipDevelopmentSecret
	#warning //TODO: Define urbanairshipDevelopmentSecret
	#define urbanairshipDevelopmentSecret	@""
#endif

#ifndef urbanairshipProductionKey
	#warning //TODO: Define urbanairshipProductionKey
	#define urbanairshipProductionKey	@""
#endif

#ifndef urbanairshipProductionSecret
	#warning //TODO: Define urbanairshipProductionSecret
	#define urbanairshipProductionSecret	@""
#endif


#import "UAirship.h"
#import "UAConfig.h"
#import "UAPush.h"
#import "UALocationService.h"


@interface FXDmodulePush : FXDsuperModule


- (void)preparePushManager;

- (void)updateMainAlias:(NSString*)aliasString;
- (void)activateLocationReporting;


@end
