//
//  LoginViewController.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/13/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import "User+Functions.h"
#import "AppDelegate.h"
#import "Appearance.h"
#import <FacebookSDK/FacebookSDK.h>
#import <RestKit/RestKit.h>
#import "Flurry.h"
#import "LoginTextButton.h"
#import "LoadingView.h"
#import "FriendController.h"
@interface LoginViewController () <UITextFieldDelegate>
{
    BOOL _isEditing;
    BOOL _createViewOpen;
    BOOL _loginViewOpen;
    User *_user;
    LoadingView *_loadingView;
}
- (IBAction)faceBookLogin:(id)sender;
- (IBAction)newUserLogin:(id)sender;
- (IBAction)existingUserLogin:(id)sender;
- (IBAction)showLoginFields:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *existingUserButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIView *createUserView;
@property (weak, nonatomic) IBOutlet UIButton *createUserButton;
@property (weak, nonatomic) IBOutlet UITextField *createUsernameField;


@end

@implementation LoginViewController 



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
    _user = [User object];
    _isEditing = NO;
    _loginViewOpen = NO;
    _createViewOpen = NO;
    //Register for facebook events
    self.backgroundImageView.image = [UIImage imageNamed:@"common_background.jpg"];
    
    [self.facebookButton setTitle:NSLocalizedString(@"LOGIN_WITH", @"Login with facebook button") forState:UIControlStateNormal];
    [self.existingUserButton setTitle:NSLocalizedString(@"LOGIN_EXISTING_USER", @"Login existing user button") forState:UIControlStateNormal];
    [self.createUserButton setTitle:NSLocalizedString(@"NEW_USER", @"Maak nieuwe gebruiker aan met username") forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"LOGIN", @"Login button") forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:NSLocalizedString(@"FORGOT_PASSWORD", @"Forgot password button") forState:UIControlStateNormal];
    [self.usernameTextField setPlaceholder:NSLocalizedString(@"USERNAME", @"Username textfield")];
    [self.passwordTextField setPlaceholder:NSLocalizedString(@"PASSWORD", @"Password textfield")];
    [self.createUsernameField setPlaceholder:NSLocalizedString(@"USERNAME", @"Username textfield")];
    
    [Appearance setLabelFont:self.facebookButton.titleLabel];
    [Appearance setLabelFont:self.loginButton.titleLabel];
    [Appearance setLabelFont:self.existingUserButton.titleLabel];
    [Appearance setLabelFont:self.forgotPasswordButton.titleLabel];
    [Appearance setLabelFont:self.createUserButton.titleLabel];
    [Appearance setTextFieldFont:self.usernameTextField];
    [Appearance setTextFieldFont:self.passwordTextField];
    [Appearance setTextFieldFont:self.createUsernameField];
    // Create gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeKeyboard)];
    
    // Set required taps and number of touches
    [tap setNumberOfTouchesRequired:1];
    tap.cancelsTouchesInView = NO;
    // Add the gesture to the view
    //[[self view] addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self removeKeyboard];
}

- (void)viewDidUnload
{
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setActivityIndicator:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setBackgroundImageView:nil];
    [self setFacebookButton:nil];
    [self setLoginView:nil];
    [self setExistingUserButton:nil];
    [self setLoginButton:nil];
    [self setForgotPasswordButton:nil];
    [self setLogoImageView:nil];
    [self setCreateUserView:nil];
    [self setCreateUserButton:nil];
    [self setCreateUsernameField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark - private methods

/**
 * Login button clicked, switch to facebook for authentication
 */
- (IBAction)faceBookLogin:(id)sender {
    [Flurry logEvent:@"Login with Facebook"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // The user has initiated a login, so call the openSession method
    // and show the login UX if necessary.
    // If the user is authenticated, log out when the button is clicked.
    // If the user is not authenticated, log in when the button is clicked.
    //DLog(@"Facebook login");
    if (FBSession.activeSession.isOpen) {
        [appDelegate closeSession];        
        
    } else {
        // The user has initiated a login, so call the openSession method
        // and show the login UX if necessary.
        [appDelegate openSessionWithAllowLoginUI:YES];
        
    }   

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    _isEditing = NO;
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    CGRect frame = self.view.frame;
    
    if(!_isEditing)
    {
        if(textField == self.createUsernameField)
        {
            frame.origin.y += 180;
        }else{
            frame.origin.y += 150;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
        }];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.view.frame;
    if(!_isEditing)
    {
        if(textField == self.createUsernameField)
        {
            frame.origin.y -= 180;
        }else{
            frame.origin.y -= 150;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = frame;
        }];
        _isEditing = YES;
    }
}

-(void)removeKeyboard
{
    if(_isEditing)
    {
        _isEditing = NO;
        [self.passwordTextField resignFirstResponder];
        [self.usernameTextField resignFirstResponder];
        [self.createUsernameField resignFirstResponder];
    }
}


/**
 * Show the field for a new username
 */
- (void) collapseNewUser
{
    if(_createViewOpen) // close
    {
        CGRect createUserButtonFrame = self.createUserButton.frame;
        createUserButtonFrame.origin.y = 0;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.createUserButton.frame = createUserButtonFrame;
            [self.createUserButton setTitle:NSLocalizedString(@"NEW_USER", @"Maak nieuwe gebruiker aan met username") forState:UIControlStateNormal];
            
        }];
        _createViewOpen = NO;
    }else{ //open
        CGRect fieldsFrame = self.createUserView.frame;
        CGRect createUserButtonFrame = self.createUserButton.frame;
        createUserButtonFrame.origin.y = fieldsFrame.size.height - createUserButtonFrame.size.height;
        
        [UIView animateWithDuration:0.4 animations:^{
            self.createUserButton.frame = createUserButtonFrame;
            [self.createUserButton setTitle:NSLocalizedString(@"MAKE_USER", @"Maak nieuwe gebruiker aan met username") forState:UIControlStateNormal];
            
        }];
        _createViewOpen = YES;
    }
}

- (void) collapseLoginUser
{

    if(_loginViewOpen)
    {
        CGRect fieldsFrame = self.loginView.frame;
        CGRect startingFrame = CGRectMake(0,0,0,0);
        self.loginView.frame = startingFrame;
        CGRect newExistingButtonFrame = self.existingUserButton.frame;
        newExistingButtonFrame.origin.y += 79;
        [self.loginView setHidden:YES];
        CGRect newFaceBookFrame = self.facebookButton.frame;
        newFaceBookFrame.origin.y += 79;
        CGRect newNewUserFrame = self.createUserView.frame;
        newNewUserFrame.origin.y -= 78;
        CGRect newLogoFrame = self.logoImageView.frame;
        newLogoFrame.origin.y += 45;
        [UIView animateWithDuration:0.4 animations:^{
            self.loginView.frame = fieldsFrame;
            self.existingUserButton.frame = newExistingButtonFrame;
            self.facebookButton.frame =  newFaceBookFrame;
            self.createUserView.frame = newNewUserFrame;
            self.logoImageView.frame = newLogoFrame;
            
        }];
        _loginViewOpen = NO;
    }else{
        
        CGRect fieldsFrame = self.loginView.frame;
        CGRect startingFrame = CGRectMake(fieldsFrame.origin.x, fieldsFrame.origin.y + (fieldsFrame.size.height/2), fieldsFrame.size.width, 0.0);
        self.loginView.frame = startingFrame;
        CGRect newExistingButtonFrame = self.existingUserButton.frame;
        newExistingButtonFrame.origin.y -= 79;
        [self.loginView setHidden:NO];
        CGRect newFaceBookFrame = self.facebookButton.frame;
        newFaceBookFrame.origin.y -= 79;
        CGRect newNewUserFrame = self.createUserView.frame;
        newNewUserFrame.origin.y += 78;
        CGRect newLogoFrame = self.logoImageView.frame;
        newLogoFrame.origin.y -= 45;
        [UIView animateWithDuration:0.4 animations:^{
            self.loginView.frame = fieldsFrame;
            self.existingUserButton.frame = newExistingButtonFrame;
            self.facebookButton.frame =  newFaceBookFrame;
            self.createUserView.frame = newNewUserFrame;
            self.logoImageView.frame = newLogoFrame;
            
        }];
        _loginViewOpen = YES;
    }
}

/**
 * New user clicked, request new user from server
 */
- (IBAction)newUserLogin:(id)sender {
    [Flurry logEvent:@"Login with new user"];
    
    if(_loginViewOpen)
    {
        [self collapseLoginUser];
    }
    if(!_createViewOpen)
    {
        [self collapseNewUser];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @"Ok"), nil];
        NSString *username = self.createUsernameField.text;
        
        if([username isEqualToString:@""])
        {
            alert.message = NSLocalizedString(@"NO_USERNAME_ENTERED", @"No username filled in");
            [alert show];
            return;
        }else if ([username length] > 17)
        {
            alert.message = NSLocalizedString(@"USERNAME_MAX_17", @"Username can have max 17 characters");
            [alert show];
            return;
        }
                
        
        _user.username = username;
        _user.language = [_user getPrefferedLanguage];
        _user.token = nil;
        _user.facebook_id = nil;
        _user.password = nil;
        [[RKObjectManager sharedManager] postObject:_user usingBlock:^(RKObjectLoader *loader) {
            loader.targetObject = _user;
            loader.onDidLoadResponse = ^(RKResponse *response){
                 
                 //User already exists
                 if([response statusCode] == 421)
                 {
                     UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle:NSLocalizedString(@"OOPS",@"oeps")
                                           message:NSLocalizedString(@"USERNAME_EXISTS", @"Username already exists")
                                           delegate:nil
                                           cancelButtonTitle:NSLocalizedString(@"OK", @"Button OK")
                                           otherButtonTitles:nil];
                     [alert show];
                 }
             };
            loader.onDidLoadObjects = ^(NSArray *objects){
                DLog(@"Obects: %@",objects);
                 User *user = [objects objectAtIndex:0];
                 //Set the user token for authentication
                 [RKObjectManager sharedManager].client.username = @"token";
                 [RKObjectManager sharedManager].client.password = user.token;
                 //set the current user loged in
                 [User setUser:user];
                 //user succesfully logged in, dismiss vc
                [self dismissLogin];
             };
            
            loader.onDidFailWithError = ^(NSError *error){
                [self hideLoadingView];
                /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FAILED_TO_CREATE_USER", @"Failed to create user") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button OK") otherButtonTitles:nil];
                [alert show];*/
            };
             
             
             
             
         }];
    }
    
          
}

- (IBAction)showLoginFields:(id)sender {
    if(_createViewOpen)
    {
        [self collapseNewUser];
    }
    [self collapseLoginUser];
    
    
}

/**
 * Forgot password
 */
- (IBAction)forgotPassword:(id)sender {
    
    if(![self.usernameTextField.text isEqualToString:@""])
    {
        DLog(@"Send username for forgotten password");
        RKClient *client = [RKClient sharedClient];
        NSString *url = [NSString stringWithFormat:@"/user/%@/requestPassword/",[self.usernameTextField.text stringByAddingPercentEscapesUsingEncoding:
                                                                                 NSASCIIStringEncoding]];
        [self showLoadingView];
        [client post:url usingBlock:^(RKRequest *request) {
                request.onDidLoadResponse = ^(RKResponse *response) {
                if(response.statusCode == 200)
                {
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FORGOT_PASSWORD",@"Forgot password alert title") message:NSLocalizedString(@"E_MAIL_SEND",@"Er is een e-mail verstuurd met een nieuw password.")  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"Ok")  otherButtonTitles:nil] show];
                }
                else{
                    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FORGOT_PASSWORD",@"Forgot password alert title") message:NSLocalizedString(@"NO_EMAIL_FOUND",@"Voor deze gebruiker is er geen e-mail adres bekend.")  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"Ok")  otherButtonTitles:nil] show];
                }
                //DLog(@"Response: %@",response);
                    
                    [self hideLoadingView];
            };
            
            request.onDidFailLoadWithError = ^(NSError *error) {
                DLog(@"Failed to retrieve password:%@",error);
                [self hideLoadingView];
            };
            
            
        }];
    }else{
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"FORGOT_PASSWORD",@"Forgot password alert title") message:NSLocalizedString(@"FILL_IN_USERNAME",@"Vul je username in.")  delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",@"Ok")  otherButtonTitles:nil] show];
        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField == self.createUsernameField || textField == self.usernameTextField)
    {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered]));
    }
    return YES;
}



/**
 * Existing user clicked, check username and password on the server
 */
- (IBAction)existingUserLogin:(id)sender {
    [Flurry logEvent:@"Login with existing user"];
    
    [RKObjectManager sharedManager].client.username = self.usernameTextField.text;
    [RKObjectManager sharedManager].client.password = self.passwordTextField.text;
    _user.password = self.passwordTextField.text;
    _user.token = nil;
    _user.language = nil;
    _user.facebook_id = nil;
    _user.username = nil;
    [[RKObjectManager sharedManager] getObject:_user delegate:self];

}




#pragma mark - events

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    DLog(@"Obects2: %@",objects);
    User *user = [objects objectAtIndex:0];
    //Set the user token for authentication
    [RKObjectManager sharedManager].client.username = @"token";
    [RKObjectManager sharedManager].client.password = user.token;
    //set the current user loged in
    [User setUser:user];
    //user succesfully logged in, dismiss vc
    [self dismissLogin];
}




-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    //DLog(@"Response:%@",response);
}

/*
 * In case something went wrong (like authentication or server availibility)
 */
- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    [self hideLoadingView];
    //if username and password dont match
    if(error.code == -1012)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"INVALID CREDENTIALS", @"Wrong username/password!") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button OK") otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR", @"error") message:NSLocalizedString(@"LOGIN_ERROR", @"Error while logging in") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button OK") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        [self showLoadingView];
        //DLog(@"FB: Logged in");
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //DLog(@"Succes FB user get");
                 NSString *token = FBSession.activeSession.accessTokenData.accessToken;
                 //set the facebook token for new user
                 _user.token = token;
                 _user.language = [_user getPrefferedLanguage];
                 _user.facebook_id = user.id;
                 _user.password = nil;
                 _user.username = nil;
                 
                 [[RKObjectManager sharedManager] postObject:_user delegate:self];
             }
             else{
                 DLog(@"Error, getting user, %@",error);
             }
         }];
        
        
    } else {
        
        DLog(@"FB: Logged out in");
        
    }
}

-(void)showLoadingView
{
    if(!_loadingView)
    {
        _loadingView = [[LoadingView alloc] initInView:self.view];
    }
    //[_loadingView setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:_loadingView];
}

-(void)hideLoadingView
{
    if(!_loadingView)
    {
        _loadingView = [[LoadingView alloc] initInView:self.view];
    }
    [_loadingView removeFromSuperview];
}

-(void)dismissLogin
{
    [self hideLoadingView];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"needToRefresh" object:self];
        [[FriendController shared] getFriendsWithdelegate:nil];
    }];
}

@end
