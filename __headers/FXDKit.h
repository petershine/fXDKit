//
//  FXDKit.h
//
//
//  Created by petershine on 12/28/11.
//  Copyright (c) 2011 Ensight. All rights reserved.
//

#define IMPLEMENTATION_sharedInstance	static dispatch_once_t once;static id _sharedInstance = nil;dispatch_once(&once,^{_sharedInstance = [[[self class] alloc] init];});return _sharedInstance


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <stdarg.h>
#import <sys/utsname.h>

#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import <TargetConditionals.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import <MapKit/MapKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


// Headers
#import "FXDconfigDeveloper.h"
#import "FXDconfigApp.h"


#import "FXDenumTypes.h"
#import "FXDnumericalValues.h"
#import "FXDlocalizedStrings.h"
#import "FXDimageNames.h"
#import "FXDtextFonts.h"
#import "FXDobjkeyUserDefaults.h"
#import "FXDnotificationNames.h"


// Objects
#import "FXDObject.h"

#import "FXDString.h"
#import "FXDDate.h"
#import "FXDURL.h"
#import "FXDNumber.h"
#import "FXDBlockOperation.h"

#import "FXDColor.h"
#import "FXDImage.h"

#import "FXDCollectionViewLayout.h"

#import "FXDStoryboardSegue.h"
#import "FXDStoryboard.h"

#import "FXDMediaItem.h"

#import "FXDAnnotation.h"

#import "FXDManagedObject.h"
#import "FXDFetchedResultsController.h"
#import "FXDManagedObjectContext.h"

#import "FXDFileManager.h"

#import "FXDMetadataQuery.h"

#import	"FXDIndexPath.h"


// Views
#import "FXDView.h"

#import "FXDButton.h"
#import "FXDTextView.h"
#import "FXDImageView.h"
#import "FXDTableViewCell.h"
#import "FXDCollectionViewCell.h"
#import "FXDLabel.h"

#import "FXDAlertView.h"
#import "FXDActionSheet.h"

#import "FXDScrollView.h"
#import "FXDCollectionView.h"

#import "FXDWindow.h"

#import "FXDAnnotationView.h"

#import "FXDMapView.h"

#import "FXDPopoverBackgroundView.h"


// ViewControllers
#import "FXDViewController.h"
#import "FXDNavigationController.h"
#import "FXDPopoverController.h"


// Global control
#import "FXDsuperGlobalManager.h"
#import "FXDsuperLaunchImageController.h"
