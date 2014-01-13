//
//  FXDconfigAdopted.h
//
//
//  Created by petershine on 1/13/14.
//  Copyright (c) 2014 fXceed. All rights reserved.
//

#ifndef PopToo_FXDconfigAdopted_h
#define PopToo_FXDconfigAdopted_h


#ifndef USE_AFNetworking
	#define USE_AFNetworking	1
#endif

#ifndef USE_UAAppReviewManager
	#define	USE_UAAppReviewManager	1
#endif

#if USE_AFNetworking
	#import "AFNetworking.h"
	#import "UIKit+AFNetworking.h"
#endif

#if USE_UAAppReviewManager
	#import "UAAppReviewManager.h"
#endif


#endif
