//
//  VersionManager.m
//  dothemath
//
//  Created by Rogier Slag on 04/12/2012.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "VersionManager.h"
#import "Restkit/RKNotifications.h"
#import "Restkit/RKResponse.h"
#import "SBJson.h"


@implementation VersionManager

static VersionManager *_shared = nil;

+(VersionManager *)shared 
{
    if(!_shared)
    {
        _shared = [[VersionManager alloc] init];
    }
    return _shared;
}

-(void)initVersionManager
{
    [self registerNotifications];
}

-(void) displayError:(NSString*)serverError {
    UIAlertView* alert;
    if ( [serverError isEqualToString:@"PLEASE_UPDATE"]) {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"PLEASE_UPDATE", @"Your app version is no longer supported. Please update the app through the App Store") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
        
    }
    [alert show];
}
//listen to the responses restkit gets
-(void)registerNotifications
{
    /*
     // Post the notification
     NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.response
     forKey:RKRequestDidLoadResponseNotificationUserInfoResponseKey];
     [[NSNotificationCenter defaultCenter] postNotificationName:RKRequestDidLoadResponseNotification
     object:self
     userInfo:userInfo];
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoadResponse:) name:RKRequestDidLoadResponseNotification object:nil];
    
}

-(void)didLoadResponse:(NSNotification *)notification
{
    
    RKResponse *response = [notification.userInfo objectForKey:RKRequestDidLoadResponseNotificationUserInfoResponseKey];
    if(response.statusCode == 412)
    {
        NSDictionary *responseBody = [response.bodyAsString JSONValue];
        NSString *message = [responseBody objectForKey:@"message"];
        [self displayError:message];        
    }
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
