//
//  ViewController.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import <RestKit/RestKit.h>
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface ViewController ()
//?
{
    User *_user;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordCheckTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *fbButton;

- (IBAction)updateProfile:(id)sender;
- (IBAction)fbLogin:(id)sender;

@end

@implementation ViewController
@synthesize fbButton;
@synthesize usernameTextField;
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize passwordCheckTextField;
@synthesize updateButton;



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSFetchRequest *userFetch = [User fetchRequest];
    [userFetch setReturnsObjectsAsFaults:NO];
    NSArray* users = [User objectsWithFetchRequest:userFetch];
    DLog(@"Users: %d",[users count]);
    
    if([users count] == 0)
    {
        User *newUser = [User object];
        [[RKObjectManager sharedManager] postObject:newUser delegate:self];
        
    }
    else
    {
        [self loadUser:[users objectAtIndex:0]];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];


    // Check the session for a cached token to show the proper authenticated
    // UI. However, since this is not user intitiated, do not show the login UX.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:NO];
}

-(void)loadUser: (User *) user
{
    //?
    _user = user;
    DLog(@"User: %@",_user);
    usernameTextField.text = _user.username;
    emailTextField.text = _user.email;
}

- (void)viewDidUnload
{
    //?
    
    [self setUsernameTextField:nil];
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setPasswordCheckTextField:nil];
    [self setUpdateButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setFbButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [fbButton setTitle:@"Logout" forState:UIControlStateNormal];
    } else {
        [fbButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}

- (IBAction)updateProfile:(id)sender {
    
    if([passwordTextField.text isEqualToString:passwordCheckTextField.text])
    {
        if([self validateEmail:emailTextField.text] || [emailTextField.text isEqualToString:@""])
        {
            NSString *oldUserName = _user.username;
            NSString *oldPassword = _user.password;
            _user.username = usernameTextField.text;
            if(![passwordTextField.text isEqualToString:@""])
            {
                _user.password = passwordTextField.text;
            }
            _user.email = emailTextField.text;
            [RKObjectManager sharedManager].client.username = oldUserName;
            [RKObjectManager sharedManager].client.password = oldPassword;
            DLog(@"Username: %@, Password: %@", [RKObjectManager sharedManager].client.username, [RKObjectManager sharedManager].client.password );
            
            [[RKObjectManager sharedManager] putObject:_user delegate:self];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Email is not correct" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];           
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Passwords dont match" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    
    
}

- (IBAction)fbLogin:(id)sender {
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
   
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];
      
        
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
        
    }
    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    User *user = [objects objectAtIndex:0];
    DLog(@"User: %@",user);
    [self loadUser:user];
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Rats!" otherButtonTitles:nil];
    [alert show];
}
- (BOOL) validateEmail: (NSString *) email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //	return 0;
    return [emailTest evaluateWithObject:email];
}

@end
