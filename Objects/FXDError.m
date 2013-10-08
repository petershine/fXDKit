//
//  FXDError.m
//
//
//  Created by petershine on 10/8/13.
//  Copyright (c) 2013 fXceed. All rights reserved.
//

#import "FXDError.h"

@implementation FXDError
@end


@implementation NSError (Added)
- (NSDictionary*)essentialParameters {
	NSDictionary *parameters =
	@{
	  @"localizedDescription": (([self localizedDescription]) ? [self localizedDescription]:@""),
	  @"domain":	(([self domain]) ? [self domain]:@""),
	  @"code":	@([self code]),
	  @"userInfo":	(([self userInfo]) ? [self userInfo]:@"")
	  };

	return parameters;
}
@end
