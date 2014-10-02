//
//  FriendsViewController.h
//  Do The Math
//
//  Created by Rogier Slag on 9/18/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestKit/RKObjectLoader.h"
#import "DTMTableViewController.h"
#import <iAd/iAd.h>

@interface FriendsViewController : DTMTableViewController <RKObjectLoaderDelegate,UIActionSheetDelegate>

@end
