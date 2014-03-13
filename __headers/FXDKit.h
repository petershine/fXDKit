//
//  FXDKit.h
//
//
//  Created by petershine on 12/28/11.
//  Copyright (c) 2011 fXceed. All rights reserved.
//

#ifndef FXDKit_FXDKit_h
#define FXDKit_FXDKit_h

#import <objc/runtime.h>
#import <stdarg.h>
#import <sys/utsname.h>

#import <Availability.h>
#import <TargetConditionals.h>

@import Foundation;
@import UIKit;

@import SystemConfiguration;
@import MobileCoreServices;

@import CoreData;
@import QuartzCore;
@import ImageIO;


// Headers
#import "FXDconfigAnalytics.h"
#import "FXDconfigDeveloper.h"

#import "FXDenumTypes.h"
#import "FXDnumericalValues.h"
#import "FXDlocalizedStrings.h"
#import "FXDimageNames.h"

#import "FXDmacroEssential.h"


// Adopted
#import "FXDconfigAdopted.h"


// Objects
#import "FXDObject.h"

#import "FXDError.h"

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

#import "FXDManagedDocument.h"

#import "FXDManagedObject.h"
#import "FXDFetchedResultsController.h"
#import "FXDManagedObjectContext.h"

#import "FXDFileManager.h"

#import "FXDMetadataQuery.h"

#import	"FXDIndexPath.h"

#import "FXDBarButtonItem.h"


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

#import "FXDPopoverBackgroundView.h"


// ViewControllers
#import "FXDViewController.h"
#import "FXDNavigationController.h"
#import "FXDPopoverController.h"
#import "FXDPageViewController.h"


// Global controllers
#import "FXDResponder.h"

#import "FXDsuperContainer.h"

#import "FXDsuperGlobalManager.h"
#import "FXDsuperLaunchController.h"


#endif