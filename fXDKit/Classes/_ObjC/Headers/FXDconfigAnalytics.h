

#ifndef FXDKit_FXDconfigAnalytics_h
#define FXDKit_FXDconfigAnalytics_h


#ifndef USE_Crashlytics
	#define USE_Crashlytics	FALSE
#endif

#if USE_Crashlytics
	#import <Fabric/Fabric.h>
	#import <Crashlytics/Crashlytics.h>

#else
#endif


#endif
