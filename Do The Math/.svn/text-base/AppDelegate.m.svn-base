//
//  AppDelegate.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "AppDelegate.h"

#import <FacebookSDK/FacebookSDK.h>
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "LoginViewController.h"
#import <HockeySDK/HockeySDK.h>
#import "HomeViewController.h"
#import "DynamicImageLoader.h"
#import "Appearance.h"
#import "MappingManager.h"
#import "User+Functions.h"
#import "ConnectionManager.h"
#import "RankManager.h"
#import "SettingManager.h"
#import "Flurry.h"
#import "AchievementManager.h"
#import "DTMInAppPurchase.h"
#import "Appirater.h"
#import "PremiumVersionViewController.h"
#import "FriendController.h"
#define REMOTE_SERVER @"https://api.dothemathgame.com/" //productie



@interface AppDelegate() <BITHockeyManagerDelegate, BITUpdateManagerDelegate, BITCrashManagerDelegate> {}
@end

@implementation AppDelegate
NSString *const FBSessionStateChangedNotification = @"com.innocattic.dothemath:FBSessionStateChangedNotification";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    RKLogConfigureByName("RestKit", RKLogLevelOff);
    RKLogConfigureByName("RestKit/*", RKLogLevelOff);

    RKLogConfigureByName("RestKit/Network", RKLogLevelTrace);

    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelOff);
    RKLogConfigureByName("RestKit/CoreData", RKLogLevelOff);
    
    
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *versionStr = [NSString stringWithFormat:@"%@ (%@)",
                            [appInfo objectForKey:@"CFBundleShortVersionString"],
                            [appInfo objectForKey:@"CFBundleVersion"]];
    DLog(@"Version: %@",versionStr);
    
    [Flurry setAppVersion:versionStr];
    [Flurry setDebugLogEnabled:NO];
    [Flurry startSession:@"QTTNVKJH6HCSDCMBRNDW"];
   
    [DTMInAppPurchase sharedInstance];
    //@TODO: Dit eventueel ook via settings op server
    [Appirater setAppId:@"588734364"];
    [Appirater setDaysUntilPrompt:2];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setSignificantEventsUntilPrompt:-1];
    [Appirater setTimeBeforeReminding:3];
    [Appirater setDebug:NO];
    
    /**
     * Making an object manager for core data
     */
    RKObjectManager* manager = [RKObjectManager objectManagerWithBaseURL:[NSURL URLWithString:REMOTE_SERVER]];
    [RKObjectManager setSharedManager:manager];
    RKManagedObjectStore *store = [RKManagedObjectStore objectStoreWithStoreFilename:@"CoreData.sqlite"];
    [RKObjectManager sharedManager].objectStore = store;
    //[RKObjectManager sharedManager].objectStore.cacheStrategy = [RKInMemoryManagedObjectCache new];
    [RKObjectManager sharedManager].acceptMIMEType = RKMIMETypeJSON;
    [RKObjectManager sharedManager].serializationMIMEType = RKMIMETypeJSON;
    [RKClient sharedClient].requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    [RKObjectManager sharedManager].requestQueue.showsNetworkActivityIndicatorWhenBusy = YES;
    [RKClient sharedClient].authenticationType = RKRequestAuthenticationTypeHTTPBasic;
    //[RKClient sharedClient].timeoutInterval = 20.0;
    //set mapping and routing objects
    [MappingManager setObjectMapping:store];
    [MappingManager setRouting];
    
    
    //check if there is a user in de core data, if so, set the current user
    NSFetchRequest *userFetch = [User fetchRequest];
    [userFetch setReturnsObjectsAsFaults:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id != 0"];
    [userFetch setPredicate:predicate];
    NSArray* users = [User objectsWithFetchRequest:userFetch];
    DLog(@"# of users found: %d: %@",[users count],users);
    
    if([users count] > 0)
    {
        User *user = [users objectAtIndex:0];
        DLog(@"%@",user);
        [User setUser:user];
        [RKObjectManager sharedManager].client.username = @"token";
        [RKObjectManager sharedManager].client.password = user.token;
        [[FriendController shared] getFriendsWithdelegate:nil];
 
    }
    
    
    //check if app is launched from push notification
    if (launchOptions != nil) {
		NSDictionary* notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (notification != nil) {
			[[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            
            //setting badge from notification
            int badge = [[[notification objectForKey:@"aps"] objectForKey:@"badge"] intValue];
            [application setApplicationIconBadgeNumber:badge];
            DLog(@"Launched from push notification: %@", notification);
        }
	}
    
    [self initHockeyApp];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSessionWithAllowLoginUI:NO];
    }
    
    //[[VersionManager shared] initVersionManager];
    [[ConnectionManager shared] initVersionManager];    
    [Appearance setDefaultAppearance];
    [[RankManager shared] initialize];
    [[SettingManager shared] initialize];
    [PremiumVersionViewController getProducts];
    
    
    
    // Uncomment this to follow coredata saves
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coreDataSaved:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    
    
    [Appirater appLaunched:YES];
    
    return YES;
}

/* Follow coredata inserts,updates and deletes */
-(void)coreDataSaved:(NSNotification *)notification{
    DLog(@"Notificatie: %@",notification);
}


/*
 * Message called when push notification is pushed, when in app
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
	DLog(@"Notificatie: %@", [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
    //clear notifications from center
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    //setting badge from notification
    int badge = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] intValue];
    [application setApplicationIconBadgeNumber:badge];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    NSArray* vcs = navigationController.viewControllers;
    __block BOOL userIsInGame = NO;
    [vcs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[HomeViewController class]]) {
            HomeViewController *hvc = (HomeViewController *)obj;
            [hvc refresh];
        }
        if ( [obj isKindOfClass:[GameViewController class]]) {
            userIsInGame = YES;
        }

    }];
    
    if ( !userIsInGame && [[userInfo objectForKey:@"message"] boolValue]) {
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NOTIFICATION", @"Notification message title")  message:[NSString stringWithFormat:@"%@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]] delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil] show];
    }
    
    if ( [userInfo objectForKey:@"match_id"]) {
        int gameId = [[userInfo objectForKey:@"match_id"] intValue];
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:[NSString stringWithFormat:@"com.innovattic.dothemath.push.match.%d",gameId] object:nil]];
        DLog(@"com.innovattic.dothemath.push.match.%d",gameId);
    }
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
	DLog(@"My token is: %@", deviceToken);
    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceToken"]; //if the token needs to be sended every time
    NSData *currentToken = [[NSUserDefaults standardUserDefaults] dataForKey:@"deviceToken"];

    if(![currentToken isEqualToData:deviceToken]) {
        NSString* newToken = [deviceToken description];
        newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
        newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        [[RKClient sharedClient] put:[NSString stringWithFormat:@"/user/%@/device/",[User currentUser].id] usingBlock:^(RKRequest *request) {            
          
            // Convert the NS Dictionary into Params
           // RKParams *params = [RKParams paramsWithDictionary:[NSMutableDictionary dictionaryWithObject:newToken forKey:@"deviceToken"]];
            
            [request setHTTPBodyString:[NSString stringWithFormat:@"{ \"deviceToken\" : \"%@\", \"os\" : \"ios\"}",newToken]];
            
            //request.params = params;
            request.onDidLoadResponse = ^(RKResponse *response) {
                if(response.statusCode == 200) {
                    DLog(@"Device token send! :%@",response);
                    [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"deviceToken"];
                } else {
                    DLog(@"Failed to send devicetoken:%@",response);
                }
            };
            
            request.onDidFailLoadWithError = ^(NSError *error) {
                DLog(@"Failed to send devicetoken, error:%@",error);
            };
        }];
    }    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
    if ( error.code != 3010 ) { //3010 is simulator, which doesnt support push notifications
        DLog(@"Failed to get token, error: %@", error);
    }	
}


/**
 * Request to server failed
 */
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error {
    DLog(@"Match fetching fail: %@",error.localizedDescription);
}
/**
 * Request to server success
 */
-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects {}

/**
 * Facebook connection handler for user sessions
 */

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}


/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                //DLog(@"User session found");
            }
            break;
        case FBSessionStateClosed:
            //DLog(@"FB: State closed");
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            //DLog(@"FB: FBSessionStateClosedLoginFailed");
            break;
        default:
            //DLog(@"FB: unkown state");
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        [[[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil] show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (void) openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    //NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
    [FBSession openActiveSessionWithPublishPermissions:nil defaultAudience:FBSessionDefaultAudienceEveryone allowLoginUI:allowLoginUI completionHandler:^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

/*
 * Closes a user session (connected through Facebook)
 */
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}

#pragma mark - BITUpdateManagerDelegate
- (NSString *)customDeviceIdentifierForUpdateManager:(BITUpdateManager *)updateManager {
#ifndef CONFIGURATION_AppStore
    if ([[UIDevice currentDevice] respondsToSelector:@selector(uniqueIdentifier)])
        return [[UIDevice currentDevice] performSelector:@selector(uniqueIdentifier)];
#endif
    return nil;
}

/**
 * Init the hockey app
 */

-(void)initHockeyApp {

    [[BITHockeyManager sharedHockeyManager] configureWithBetaIdentifier:@"1813ff0049befad103903360f47363c5"
                                                         liveIdentifier:@"5aed07169121ceb48cf191a18cf6145d"
                                                               delegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // Doesn't fire when receiving a call
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    DLog(@"Foreground!");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"needToRefresh" object:nil];
    
    [Appirater appEnteredForeground:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // this means the user switched back to this app without completing
    // a login in Safari/Facebook App
    if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
        [FBSession.activeSession close]; // so we close our session and start over
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [FBSession.activeSession close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
