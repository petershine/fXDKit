

#ifndef FXDKit_FXDimportAdopted_h
#define FXDKit_FXDimportAdopted_h


#ifndef USE_ReactiveCocoa
	#define	USE_ReactiveCocoa	FALSE
#endif

#ifndef USE_AFNetworking
	#define USE_AFNetworking	FALSE
#endif

#ifndef USE_GPUImage
	#define USE_GPUImage	FALSE
#endif


#if USE_ReactiveCocoa	//https://github.com/ReactiveCocoa/ReactiveCocoa
	#import <ReactiveCocoa.h>
	#import <RACEXTScope.h>
#endif

#if USE_AFNetworking	//https://github.com/AFNetworking/AFNetworking
	#import <AFNetworking.h>
	#import <UIKit+AFNetworking.h>
#endif

#if USE_GPUImage	//https://github.com/BradLarson/GPUImage
	#import <GPUImage.h>
#endif



#endif
