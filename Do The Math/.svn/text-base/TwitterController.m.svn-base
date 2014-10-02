//
//  TwitterController.m
//  dothemath
//
//  Created by Innovattic 1 on 3/7/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "TwitterController.h"
#import <Twitter/Twitter.h>
#import "AchievementManager.h"
#import "User+Functions.h"
#import "Flurry.h"

@interface TwitterController()
{
    NSDictionary *_settings;
}
@end

@implementation TwitterController

static TwitterController *_manager = nil;


/**
 * Singelton init function
 */
+(TwitterController *)shared
{
    if(!_manager)
    {
        _manager = [[TwitterController alloc] init];
        //update if the ranks are updated

    }
    return _manager;
}

-(void)tweetFrom:(UIViewController *)sender tweet:(NSString *)tweet {
    {
        if ([TWTweetComposeViewController canSendTweet])
        {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            if(tweet)//if text is set
            {
                [tweetSheet setInitialText:tweet];
            }
            else{ //default text
                [tweetSheet setInitialText:[NSString stringWithFormat:NSLocalizedString(@"IAM_PLAYING_TWEET", @"I'm playing DTM! #DoTheMathGame www.dothemathgame.com"),[[User currentUser] username]]];
                //[tweetSheet setInitialText:@"I'm playing DTM! #DoTheMathGame"];
            }
            [tweetSheet addURL:[NSURL URLWithString:@"http://www.dothemathgame.com"]];
            TWTweetComposeViewControllerCompletionHandler completionHandler = ^(TWTweetComposeViewControllerResult result) {
                switch (result)
                {
                    case TWTweetComposeViewControllerResultCancelled:
                        DLog(@"Twitter Result: canceled");
                        break;
                    case TWTweetComposeViewControllerResultDone:
                        DLog(@"Twitter Result: sent");
                        [[AchievementManager shared] tweet];
                        [Flurry logEvent:@"Twitter post"];
                        break;
                    default:
                        DLog(@"Twitter Result: default");
                        break;
                }
                [sender dismissModalViewControllerAnimated:YES];
            };
            [tweetSheet setCompletionHandler:completionHandler];
            
            
            
            [sender presentModalViewController:tweetSheet animated:YES];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:NSLocalizedString(@"SORRY", @"Sorry")
                                      message:NSLocalizedString(@"YOU_NEED_TO_CONNECT_TWITTER", @"Please setup a twitter account in settings")
                                      delegate:nil
                                      cancelButtonTitle:@"OK"                                                   
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}

@end
