//
//  PostToFacebookViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 2/28/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "PostToFacebookViewController.h"
#import <RestKit/RestKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User+Functions.h"
#import "AchievementManager.h"
@interface PostToFacebookViewController ()
{
    NSDictionary<FBGraphUser> *_facebookFriend;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UITextField *commentField;

@end

@implementation PostToFacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.backgroundImage setImage:[UIImage imageNamed:@"common_background.jpg"]];
	// Do any additional setup after loading the view.
}

-(void)setFaceBookFriend:(NSDictionary<FBGraphUser> *)facebookFriend
{
    _facebookFriend = facebookFriend;
}

+(void)inviteFBFriend:(NSDictionary<FBGraphUser> *)facebookFriend sender:(UIViewController *)sender
{
    
 
    if(![PostToFacebookViewController isFBUser]) return;
    if(![PostToFacebookViewController loggedIn]) return;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   facebookFriend.id, @"to",
                                   NSLocalizedString(@"FB_SHARE_TITLE", @"Facebook share on wall title"), @"name",
                                   [NSString stringWithFormat:NSLocalizedString(@"FB_FRIEND_INVITE_MESSAGE", @"Facebook friend invite message"),[[User currentUser] username]], @"caption",
                                   @"http://www.dothemathgame.com", @"link",
                                   @"http://s3-eu-west-1.amazonaws.com/dothemathgame-avatars/fb.png", @"picture",
                                   nil];
    [FBWebDialogs presentFeedDialogModallyWithSession:FBSession.activeSession parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            /* handle failure */
            DLog(@"Fail!! %@",error);
        } else {
            DLog(@"Result: %@",resultURL);
            if (result == FBWebDialogResultDialogCompleted && [resultURL.absoluteString rangeOfString:@"request="].location != NSNotFound) {
                /* handle success */
                [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"FB_FRIEND_INVITED", @"Facebook friend is invited") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil] show];
                [[AchievementManager shared] faceBookInvite];
            } else {
                DLog(@"User canceled invite");
                /* handle user cancel */
            }
        }
    }];
    
    
    
}

+(void)shareScoreOnFacebook:(NSString *)message sender:(UIViewController *)sender
{
    if(![PostToFacebookViewController isFBUser]) return;
    if(![PostToFacebookViewController loggedIn]) return;

     NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
     NSLocalizedString(@"FB_SHARE_TITLE", @"Facebook share on wall title"), @"name",
     message, @"caption",
     @"http://www.dothemathgame.com", @"link",
     @"http://s3-eu-west-1.amazonaws.com/dothemathgame-avatars/fb.png", @"picture",
     nil];

    [FBWebDialogs presentFeedDialogModallyWithSession:FBSession.activeSession parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            /* handle failure */
            DLog(@"Fail!! %@",error);
        } else {
            DLog(@"Result: %@",resultURL);

            if (result == FBWebDialogResultDialogCompleted && [resultURL.absoluteString rangeOfString:@"post_id="].location != NSNotFound ) {
                /* handle success */
                [[[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"FB_SHARE_SUCCESSFULL", @"Message is shared on own wall") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Ok") otherButtonTitles:nil] show];
                [[AchievementManager shared] faceBookShare];
            } else {
                DLog(@"User canceled invite");
                /* handle user cancel */
            }
        }
    }];
    
}

+(BOOL)loggedIn
{
    if(![FBSession.activeSession isOpen])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"NOT_CONNECTED_FACEBOOK", @"Current user is not connected to facebook, please connect") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
        [alert show];
        return NO;
    }else{
        return YES;
    }
    
}
+(BOOL)isFBUser
{
    if(![[User currentUser] isFacebookUser])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DO_THE_MATH", @"Do the math titile") message:NSLocalizedString(@"NO_FACEBOOK_USER", @"Current user is not a facebook user, please connect") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK")  otherButtonTitles: nil];
        [alert show];
        return NO;
    }else{
        return YES;
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackgroundImage:nil];
    [self setCommentField:nil];
    [super viewDidUnload];
}
@end
