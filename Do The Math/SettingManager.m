//
//  SettingManager.m
//  dothemath
//
//  Created by Innovattic 1 on 3/7/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "SettingManager.h"
#import <RestKit/RestKit.h>
#import "SBJson.h"

@interface SettingManager()
{
    NSDictionary *_settings;
}
@end

@implementation SettingManager

static SettingManager *_manager = nil;


/**
 * Singelton init function
 */
+(SettingManager *)shared
{
    if(!_manager)
    {
        _manager = [[SettingManager alloc] init];
        //update if the ranks are updated
        [_manager setSettings];
    }
    return _manager;
}

-(void)initialize
{
    
}

/**
 * Set the settings from the NSUserdefaults
 */
-(void)setSettings
{
    if(!_settings)
    {
        _settings = [[NSDictionary alloc] init];
    }
    NSDictionary *settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"settings"];
    if(settings) //if the ranks are found
    {
        _settings = settings;
    }
    [self updateSettings];
}



-(void)updateSettings {
    NSDate *last_update;
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"settings_updated"]) {
        last_update = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"settings_updated"];
    } else {
        last_update = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    }
    DLog(@"Time update: %f",[last_update timeIntervalSinceNow]);
    //als settings nog niet gezet zijn of als het meer dan een uur geleden is.
    if((int)[last_update timeIntervalSinceNow] < -60*60 || [_settings count] < 1) {
        [[RKClient sharedClient] get:@"/settings" usingBlock:^(RKRequest *request) {
            request.onDidLoadResponse =  ^(RKResponse *response){
                if(response.statusCode == 200) {
                    NSDictionary *settings = [response.bodyAsString JSONValue];
                    _settings = settings;
                    //DLog(@"Settings: %@",settings);
                    [[NSUserDefaults standardUserDefaults] setObject:settings forKey:@"settings"];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"settings_updated"];
                } else {
                    DLog(@"Failed to get settings:%@",response);
                }
            };
        }];
    }
}

#pragma mark setting methods

-(int)gameExpiration
{
    if(_settings)
    {
        int exp = [[_settings objectForKey:@"game_max_duration"] integerValue];
        return exp;
    }
    else
    {
        return -1;
    }
}


@end
