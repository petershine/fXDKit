

#import "FXDsuperModule.h"


@implementation FXDsuperModule

#pragma mark - Memory management
- (void)dealloc {	FXDLog_DEFAULT;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Initialization
- (instancetype)init {
	self = [super init];

	if (self) {	FXDLog_DEFAULT;
	}

	return self;
}

@end
