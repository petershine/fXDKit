//
//  FXDconfigApp.h
///
//
//  Created by petershine on 7/18/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//


#ifndef application_AppStoreID
	#define application_AppStoreID	000000000
#endif

#ifndef latestSupportedSystemVersion
	#define latestSupportedSystemVersion	6.0
#endif


#if USE_Flurry
	#import "FlurryAnalytics.h"

	#ifndef flurryApplicationKey
		#define flurryApplicationKey	@"MG21RAFW4CXACSJL2JF9"
	#endif

	#define	LOGEVENT(v)			[FlurryAnalytics logEvent:v]
	#define LOGEVENT_DEFAULT	LOGEVENT(strClassSelector)

#else
	#define	LOGEVENT(v)
	#define LOGEVENT_DEFAULT

#endif
