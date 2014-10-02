//
//  ConnectionManager.m
//  dothemath
//
//  Created by Innovattic 1 on 12/5/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "ConnectionManager.h"
#import <RestKit/RestKit.h>
#import "SBJson.h"

#define STATUS_UPDATE  412
#define STATUS_MAINTENANCE  503

@interface ConnectionManager()
{
    BOOL _isReachable;
}

@end

@implementation ConnectionManager

static ConnectionManager *_shared = nil;

+(ConnectionManager *)shared
{
    if(!_shared)
    {
        _shared = [[ConnectionManager alloc] init];
    }
    return _shared;
}

-(void)initVersionManager
{
    [self registerNotifications];
    _isReachable = YES;
}


/**
 * Show the user a message if the user needs to update the app
 */
-(void) displayError:(NSString*)serverError {
    UIAlertView* alert;
    if ( [serverError isEqualToString:@"PLEASE_UPDATE"]) {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"PLEASE_UPDATE", @"Your app version is no longer supported. Please update the app through the App Store") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
        
    }else if ([serverError isEqualToString:@"MAINTENANCE"])
    {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"MAINTENANCE", @"Do the Math has temporary maintenance we will be back in a few minutes") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
    }
    
    [alert show];
}


//listen to the responses restkit gets
-(void)registerNotifications
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadResponse:) name:RKRequestDidLoadResponseNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailLoadResponse:) name:RKRequestDidFailWithErrorNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeReachability:) name:RKReachabilityDidChangeNotification object:nil];  
    
}

/**
 * If the response code is 412, the user should update his app
 */
-(void)didLoadResponse:(NSNotification *)notification
{
    RKResponse *response = [notification.userInfo objectForKey:RKRequestDidLoadResponseNotificationUserInfoResponseKey];
    if(response.statusCode == STATUS_UPDATE) // please update
    {
        NSDictionary *responseBody = [response.bodyAsString JSONValue];
        NSString *message = [responseBody objectForKey:@"message"];
        [self displayError:message];
    }
    
    if(response.statusCode == STATUS_MAINTENANCE) //maintenance
    {
        [self displayError:@"MAINTENANCE"];        
    }
}

/**
 * if the app failed to load the respone given from the server
 */
-(void)didFailLoadResponse:(NSNotification *)notification
{
    
    NSError *errorMessage = [notification.userInfo objectForKey:RKRequestDidFailWithErrorNotificationUserInfoErrorKey];
    DLog(@"Fail loading: %@",errorMessage);
    
    if(![[RKClient sharedClient].reachabilityObserver isNetworkReachable] && _isReachable) //check if there is internet available
    {
        _isReachable = NO;
        //only show this message once if there is no internet
        //[[[UIAlertView alloc] initWithTitle:@"Dothemath" message:NSLocalizedString(@"NO_INTERNET", @"Alert when app detects there is no internet.") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
    
}

/**
 * Keep track of the availablity of internet signal
 */
-(void)didChangeReachability:(NSNotification *)notification
{
    
    NSNumber *reachability = [notification.userInfo objectForKey:RKReachabilityFlagsUserInfoKey];
    DLog(@"Reachability changed: %d",[reachability intValue]);
    if([[RKClient sharedClient].reachabilityObserver isNetworkReachable])
    {
        _isReachable = YES;
    }
    
}

-(BOOL)isReachable{
    return [[RKClient sharedClient].reachabilityObserver isNetworkReachable];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
