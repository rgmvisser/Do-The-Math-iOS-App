//
//  FriendsInviteEmailViewController.m
//  dothemath
//
//  Created by Rogier Slag on 04/01/2013.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "FriendsInviteEmailViewController.h"
#import "Appearance.h"
#import <RestKit/RestKit.h>
#import "Flurry.h"

@interface FriendsInviteEmailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *promotionalText;
@property (weak, nonatomic) IBOutlet UILabel *disclaimer;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle;
@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@end

@implementation FriendsInviteEmailViewController

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
    [self setTitle:NSLocalizedString(@"E_MAIL_INVITE", @"E-mail invite title")];
    
    
    [self.headerTitle setText:NSLocalizedString(@"E_MAIL_INVITE_TITLE",@"Start playing with more friends now!")];
    [self.promotionalText setText:NSLocalizedString(@"E_MAIL_INVITE_PROMOTIONAL",@"Like Do The Math so much you want to continue playing with some of your friends? Why not invite them? They will receive a link where they can download the game, along with your username.")];
    [self.disclaimer setText:NSLocalizedString(@"E_MAIL_INVITE_DISCLAIMER",@"The E-mail address will not be used for anything else than sending the invite.")];
    [self.emailTextField setPlaceholder:NSLocalizedString(@"E_MAIL_ADDRESS", @"E-mail address placeholder")];
    [self.inviteButton setTitle:NSLocalizedString(@"INVITE", @"E-mail invite button") forState:UIControlStateNormal];
    
	// Do any additional setup after loading the view.
    [self.backgroundImage setImage:[UIImage imageNamed:@"common_background.jpg"]];
    [Appearance setLabelFont:self.disclaimer];
    [Appearance setLabelFont:self.promotionalText];
    [Appearance setLabelFont:self.headerTitle];
    [Appearance setTextFieldFont:self.emailTextField];
    [Appearance setLabelFont:self.inviteButton.titleLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [self setBackgroundImage:nil];
    [self setPromotionalText:nil];
    [self setDisclaimer:nil];
    [self setEmailTextField:nil];
    [self setHeaderTitle:nil];
    [self setInviteButton:nil];
    [super viewDidUnload];
}

- (IBAction)inviteButtonClicked:(id)sender {
    // Do a request to the API
    // /friend/mail POST
    // { email: $email$ }
    
    RKClient *client = [RKClient sharedClient];
    //user id is saved in the tag of the button
    [client post:@"/friend/mail/" usingBlock:^(RKRequest *request) {
        RKParams* params = [RKParams params];
        [params setData:[self.emailTextField.text dataUsingEncoding:NSUTF8StringEncoding] forParam:@"email"];
        request.params = params;
        request.onDidLoadResponse = ^(RKResponse *response) {
            if(response.statusCode == 200)
            {
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INVITE", @"Invite title") message:NSLocalizedString(@"E_MAIL_INVITE_SEND", @"E-mail invite is send successfully") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil] show];
                
            }
            else{
                [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INVITE", @"Invite title") message:NSLocalizedString(@"E_MAIL_INVITE_NOT_SENT", @"E-mail invite not sent") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil] show];
                DLog(@"Failed to send mail:%@",response.failureErrorDescription);
            }
        };
        
        request.onDidFailLoadWithError = ^(NSError *error) {
            DLog(@"Request failed:%@",error);
        };
        
    }];
}
@end
