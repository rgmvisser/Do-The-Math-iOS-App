//
//  NetworkManager.m
//  dothemath
//
//  Created by Rogier Slag on 04/12/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "NetworkManager.h"
#import <RestKit/RestKit.h>

@implementation NetworkManager


- (BOOL) checkNetworkAccessWithDismiss:(BOOL)userInteractionRequired dismissViewController:(BOOL)dismissViewController viewController:(UIViewController*)vc
{
    RKReachabilityObserver* observer = [RKReachabilityObserver reachabilityObserverForHost:@"google.com"];
    // Let the run-loop execute so reachability can be determined
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    NSString* errorMessage;
    
    if ([observer isNetworkReachable]) {
        DLog(@"We have network access! Huzzah!");
        if ([observer isConnectionRequired]) {
            DLog(@"Network is available if we open a connection...");
        }
        if (RKReachabilityReachableViaWiFi == [observer networkStatus]) {
            DLog(@"Online via WiFi!");
        } else if (RKReachabilityReachableViaWWAN == [observer networkStatus]) {
            DLog(@"Online via 3G or Edge...");
        }
        return YES;
    } else {
        DLog(@"No network access.");
    }
    
    if ( userInteractionRequired ) {
        errorMessage = NSLocalizedString(@"NETWORK_UNAVAILABLE_NO_ACTION", @"Because the netwerk is unavailable this action cannot be completed");
    } else {
        errorMessage = NSLocalizedString(@"NETWORK_UNAVAILABLE_ACTION", @"Because the netwerk is unavailable this action cannot be completed");
    }
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Dothemath" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    /*if ( dismissViewController ) {
        [vc networkUnavailable];
    }*/
    return NO;
}
@end
