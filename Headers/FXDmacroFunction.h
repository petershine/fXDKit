

#ifndef FXDKit_FXDmacroFunction_h
#define FXDKit_FXDmacroFunction_h


#ifndef GlobalModule
	#warning //TODO: Must define app's own GlobalModule
	#define GlobalModule	((<#FXDmoduleGlobal#>*)[<#FXDmoduleGlobal#> sharedInstance])
#endif

#ifndef application_AppStoreID
	#define application_AppStoreID	@""
#endif

#ifndef application_ContactEmail
	#define application_ContactEmail	@"app@company.com"
#endif


#define application_BundleIdentifier	[NSBundle mainBundle].bundleIdentifier
#define application_BundleName			[NSBundle mainBundle].infoDictionary[@"CFBundleName"]
#define application_BundleVersion		[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]
#define application_DisplayName			[NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"]


#define iosVersion8	8.0

#define SYSTEM_VERSION_sameOrHigher(versionNumber)	([UIDevice currentDevice].systemVersion.floatValue >= versionNumber)


#define IMPLEMENTATION_sharedInstance	static dispatch_once_t once;\
										static id _sharedInstance = nil;\
										dispatch_once(&once,^{FXDLog_SEPARATE;\
											_sharedInstance = [[[self class] alloc] init];\
											FXDLogObject(_sharedInstance);\
										});\
										return _sharedInstance


#ifndef pathcomponentDocuments
	#define pathcomponentDocuments @"Documents/"
#endif

#ifndef pathcomponentCaches
	#define pathcomponentCaches	@"Caches/"
#endif

#define appSearhPath_Document	(NSString*)[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define appSearhPath_Caches		(NSString*)[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define appDirectory_Document	(NSURL*)[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]
#define appDirectory_Caches		(NSURL*)[[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject]

#define temporaryPathFor(folderName)	[NSTemporaryDirectory() stringByAppendingPathComponent:folderName]
#define cachedPathFor(folderName)		[appSearhPath_Caches stringByAppendingPathComponent:folderName]
#define documentPathFor(folderName)		[appSearhPath_Document stringByAppendingPathComponent:folderName]



#define NSIndexPathMake(section, row)	[NSIndexPath indexPathForRow:row inSection:section]


#define ValueOfTime(timeStruct)		[NSValue valueWithCMTime:timeStruct]
#define ValueOfTimeRange(timeRange)	[NSValue valueWithCMTimeRange:timeRange]

#define CMTimeForMediaSeconds(mediaSeconds)	CMTimeMakeWithSeconds(mediaSeconds, doubleOneMillion)


#define degreeAngleForRadian(radian)	(radian*180.0/M_PI)
#define radianAngleForDegree(degree)	(degree*M_PI/180.0)


#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)

static inline CGAffineTransform CGAffineTransformMakeShear(CGFloat shearX, CGFloat shearY) {
	return CGAffineTransformMake(1.f, shearY, shearX, 1.f, 0.f, 0.f);
}

static inline CGAffineTransform CGAffineTransformShear(CGAffineTransform transform, CGFloat shearX, CGFloat shearY) {
	CGAffineTransform sheared = CGAffineTransformMakeShear(shearX, shearY);
	return CGAffineTransformConcat(transform, sheared);
}

static inline CGFloat CGAffineTransformGetDeltaX(CGAffineTransform transform) {
	return transform.tx;
};

static inline CGFloat CGAffineTransformGetDeltaY(CGAffineTransform transform) {
	return transform.ty;
};

static inline CGFloat CGAffineTransformGetScaleX(CGAffineTransform transform) {
	return sqrtf( (transform.a * transform.a) + (transform.c * transform.c) );
};

static inline CGFloat CGAffineTransformGetScaleY(CGAffineTransform transform) {
	return sqrtf( (transform.b * transform.b) + (transform.d * transform.d) );
};

static inline CGFloat CGAffineTransformGetShearX(CGAffineTransform transform) {
	return transform.b;
};

static inline CGFloat CGAffineTransformGetShearY(CGAffineTransform transform) {
	return transform.c;
};

static inline CGFloat CGPointAngleBetweenPoints(CGPoint first, CGPoint second) {
	CGFloat dy = second.y - first.y;
	CGFloat dx = second.x - first.x;
	return atan2f(dy, dx);
}

static inline CGFloat CGAffineTransformGetRotation(CGAffineTransform transform) {
	// No exact way to get rotation out without knowing order of all previous operations
	// So, we'll cheat. We'll apply the transformation to two points and then determine the
	// angle betwen those two points

	CGPoint testPoint1 = CGPointMake(-100.f, 0.f);
	CGPoint testPoint2 = CGPointMake(100.f, 0.f);
	CGPoint transformed1 = CGPointApplyAffineTransform(testPoint1, transform);
	CGPoint transformed2 = CGPointApplyAffineTransform(testPoint2, transform);
	return CGPointAngleBetweenPoints(transformed1, transformed2);
}


#endif