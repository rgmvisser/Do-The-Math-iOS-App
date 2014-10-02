//
//  AppDelegate.h
//  Do The Math
//
//  Created by Innovattic 1 on 9/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RestKit/RestKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,RKObjectLoaderDelegate>

@property (strong, nonatomic) UIWindow *window;

// Load Facebook integration tools
extern NSString *const FBSessionStateChangedNotification;
- (void) openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
