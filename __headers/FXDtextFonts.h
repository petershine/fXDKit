//
//  FXDtextFonts.h
//
//
//  Created by petershine on 3/16/12.
//  Copyright (c) 2012 Ensight. All rights reserved.
//

// Font
#define fontSystem15	[UIFont systemFontOfSize:15.0]
#define fontSystem12	[UIFont systemFontOfSize:12.0]
#define fontSystem5		[UIFont systemFontOfSize:5.0]

#define fontSystemBold22	[UIFont boldSystemFontOfSize:22.0]
#define fontSystemBold20	[UIFont boldSystemFontOfSize:20.0]
#define fontSystemBold17	[UIFont boldSystemFontOfSize:17.0]
#define fontSystemBold15	[UIFont boldSystemFontOfSize:15.0]
#define fontSystemBold14	[UIFont boldSystemFontOfSize:14.0]
#define fontSystemBold13	[UIFont boldSystemFontOfSize:13.0]
#define fontSystemBold12	[UIFont boldSystemFontOfSize:12.0]


// Color
#define UIColorFromRGB(rgbValue)	[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define colorDarkBrown		UIColorFromRGB(0x4f1e00)
#define colorDarkOrange		UIColorFromRGB(0xef6307)
#define colorLightOrange	UIColorFromRGB(0xff7e00)