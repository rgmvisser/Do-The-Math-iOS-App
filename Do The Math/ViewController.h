//
//  ViewController.h
//  Do The Math
//
//  Created by Innovattic 1 on 9/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>
#import "User.h"
#import "AppDelegate.h"

@interface ViewController : UIViewController <RKObjectLoaderDelegate>


-(void) loadUser:(User *)user;

@end
