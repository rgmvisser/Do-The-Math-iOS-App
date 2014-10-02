//
//  UserSettingsViewController.m
//  Do The Math
//
//  Created by Innovattic 1 on 9/17/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "UserSettingsViewController.h"
#import <RestKit/RestKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "User+Functions.h"
#import "UIImageView+dynamicLoad.h"
#import "ImageManipulator.h"
#import "User.h"
#import "Game+Functions.h"
#import "Friend+Functions.h"
#import "AppDelegate.h"
#import "Flurry.h"
#import "Appearance.h"
#import "SoundController.h"
#import "RankManager.h"
#import "UIAlertView+BlockExtensions.h"
#import "DTMInAppPurchase.h"
#import "Flurry.h"
#import "FriendController.h"
#import "BadgeManager.h"
#define AVATAR_WIDTH 200
#define AVATAR_HEIGHT 200

@interface UserSettingsViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>
{
    BOOL _avatarChanged;
    NSString *_oldtoken;
}

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *connectToFacebookButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTexField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordCheckTextField;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIButton *selectImage;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankExperienceLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

//- (IBAction)saveProfile;
- (IBAction)connectToFacebook:(id)sender;
- (IBAction)selectAvatar:(id)sender;
- (BOOL) passwordsMatch;

@end

@implementation UserSettingsViewController
@synthesize connectToFacebookButton = _connectToFacebookButton;
@synthesize usernameTexField = _usernameTexField;
@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize passwordCheckTextField = _passwordCheckTextField;
@synthesize scrollView = _scrollView;
@synthesize contentView = _contentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
   
    [super viewDidAppear:animated];
//    self.navigationItem.backBarButtonItem = self.backButton;
    self.navigationItem.leftBarButtonItem = self.backButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //style everything
    [self.backgroundImage setImage:[UIImage imageNamed:@"common_background.jpg"]];
    User *user = [User currentUser];
    

    [self setTitle:NSLocalizedString(@"USER_SETTINGSS",@"User settings title")];
    [self.backButton setTitle:NSLocalizedString(@"SAVE",@"Save button")];
    [self.rankLabel setText:NSLocalizedString(@"RANK",@"Rank: label")];
    [self.selectImage setTitle:NSLocalizedString(@"SELECT_IMAGE",@"Select image button") forState:UIControlStateNormal];
    [self.logoutButton setTitle:NSLocalizedString(@"LOGOUT",@"Logout button") forState:UIControlStateNormal];
    [self.connectToFacebookButton setTitle:NSLocalizedString(@"CONECT_WITH",@"Connect with facebook button") forState:UIControlStateNormal];
    [self.usernameTexField setPlaceholder:NSLocalizedString(@"USERNAME",@"Username textfield")];
    [self.emailTextField setPlaceholder:NSLocalizedString(@"EMAIL",@"E-mail textfield")];
    [self.passwordTextField setPlaceholder:NSLocalizedString(@"PASSWORD",@"Password textfield")];
    [self.passwordCheckTextField setPlaceholder:NSLocalizedString(@"RETYPE_PASSWORD",@"Re-type password textfield")];    
    [self.rankExperienceLabel setText:[NSString stringWithFormat:@"%@ %@",user.experience,NSLocalizedString(@"POINTS",@"Points")]];
    
    
    [Appearance setTextFieldFont:self.usernameTexField];
    [Appearance setTextFieldFont:self.emailTextField];
    [Appearance setTextFieldFont:self.passwordTextField];
    [Appearance setTextFieldFont:self.passwordCheckTextField];
    [Appearance setStyleButton:self.selectImage];
    [Appearance setLabelFont:self.connectToFacebookButton.titleLabel];
    [Appearance setLabelFont:self.rankLabel];
    [Appearance setLabelFont:self.rankExperienceLabel];
    [Appearance setLabelFont:self.rankNameLabel];
    [Appearance setLabelFont:self.logoutButton.titleLabel];
    
    
    _avatarChanged = NO;
    
    [self.usernameTexField setText:user.username];
    [self.emailTextField setText:user.email];
    [self.avatarImageView setDynamicImage:user.id avatarId:user.avatar];
    [self.rankNameLabel setText:[user getRankName]];
    
    self.scrollView.contentSize = self.contentView.frame.size;
    
    // if already a facebook user, no connection is needed
    if([user isFacebookUser])
    {
        [self.connectToFacebookButton setHidden:YES];
    }
    
    //register for facebook events
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    
	// Do any additional setup after loading the view.
    [Flurry logEvent:@"Settings profile opened"];
    
}

- (BOOL) passwordsMatch
{
    BOOL success= YES;
    
    if ( ![self.passwordTextField.text isEqualToString:@""] &&
         ![self.passwordTextField.text isEqualToString:self.passwordCheckTextField.text]) {
        
        self.passwordCheckTextField.text = @"";
            self.passwordTextField.text = @"";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"PASSWORD_DONT_MATCH", @"Passwords don't match") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"Button OK") otherButtonTitles:nil];
            [alert show];
        success = NO;
    }
    return success;
}

- (BOOL) correctUsername{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", @"Ok"), nil];
    if([self.usernameTexField.text isEqualToString:@""])
    {
        alert.message = NSLocalizedString(@"NO_USERNAME_ENTERED", @"No username filled in");
        [alert show];
        return NO;
    }else if ([self.usernameTexField.text length] > 17)
    {
        alert.message = NSLocalizedString(@"USERNAME_MAX_17", @"Username can have max 17 characters");
        [alert show];
        return NO;
    }else{
        return YES;
    }
    
    
}

- (IBAction)checkDataAndSave:(id)sender {
    void (^saveProfile)(NSString*,NSString*,NSString*,BOOL,UIImage*) = ^(
                                                                         NSString *username,
                                                                         NSString *password,
                                                                         NSString *email,
                                                                         BOOL avatarChanged,
                                                                         UIImage* avatar){
        DLog(@"Saving profile data");
        User *user = [User currentUser];
        user.username = username;
        user.password = password;
        user.email = email;
        user.language = [user getPrefferedLanguage];
        
        if(avatarChanged)
        {
            avatarChanged = NO;
            [user newAvatar:avatar];
            
        }
        
        //update to the server
        [[RKObjectManager sharedManager] putObject:user delegate:nil];
    };
    
    if ([self passwordsMatch]) {
        
        if([self correctUsername])
        {
            saveProfile(self.usernameTexField.text,
                        self.passwordTextField.text,
                        self.emailTextField.text,
                        _avatarChanged,
                        _avatarImageView.image);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


- (void)viewDidUnload
{
    [self setUsernameTexField:nil];
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setPasswordCheckTextField:nil];
    [self setConnectToFacebookButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setScrollView:nil];
    [self setContentView:nil];
    [self setAvatarImageView:nil];
    [self setBackButton:nil];
    [self setBackgroundImage:nil];
    [self setSelectImage:nil];
    [self setRankLabel:nil];
    [self setRankNameLabel:nil];
    [self setRankExperienceLabel:nil];
    [self setLogoutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Events
/**
 * User wants to link there account to a facebook account
 */
- (IBAction)connectToFacebook:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //open facebook UI to login
    [appDelegate openSessionWithAllowLoginUI:YES];    
}

/**
 * Face session has changed, if logged in, connect the facebook token with the user
 */
- (void)sessionStateChanged:(NSNotification*)notification {
    _oldtoken = [User currentUser].token;
    if (FBSession.activeSession.isOpen) {
        DLog(@"FB: Logged in");
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSString *token = FBSession.activeSession.accessTokenData.accessToken;
                 if ( ![User currentUser]) {
                     return;
                 }
                 User *currentUser = [User currentUser];
                 //set the facebook token for existing user
                 currentUser.token = token;
                 currentUser.facebook_id = user.id;
                 //update the user
                 [[RKObjectManager sharedManager] putObject:currentUser delegate:self];
             }
         }];
        
    } else {
        DLog(@"FB: Logged out in");
        
    }
}


/**
 * Request to update user failed
 */
-(void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    DLog(@"UserSettings error update: %@",error);
}
/**
 * Request to update user success
 */
-(void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{    
    User *user = [User currentUser];
    DLog(@"User settings updated,%@",user);
    if([user isFacebookUser])
    {
        //Set the token, in case a facebook token is given and hide connect button
        [RKObjectManager sharedManager].client.password = user.token;
        [self.connectToFacebookButton setHidden:YES];
    } 
}

/**
 * Check the response of the request
 * @TODO: username is saved, even when it already exists. Old username must be placed back.
 */
-(void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response
{
    DLog(@"Response:%d",[response statusCode]);
    //User already exists
    if([response statusCode] == 421)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"ERROR",@"error")
                              message:NSLocalizedString(@"USERNAME_EXISTS", @"Username already exists")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button OK")
                              otherButtonTitles:nil];
        [alert show];        
    }else if([response statusCode] == 421){
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"ERROR",@"error")
                              message:NSLocalizedString(@"FB_USERNAME_EXISTS", @"Facebook user already exists when trying to connect to facebook")
                              delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK", @"Button OK")
                              otherButtonTitles:nil];
        [[User currentUser] setFacebook_id:@""];
        [[User currentUser] setToken:_oldtoken];
        
        [alert show];
    }
}

- (IBAction)selectAvatar:(id)sender {
    
    UIActionSheet *imageTypePicker = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"SOURCE_TYPE", @"Choose between photo library and camera") delegate:self cancelButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"CAMERA", @"Camera in picker"),NSLocalizedString(@"PHOTO_LIBRARY", @"Photo library in picker"), nil];
    [self hideKeyboard];
    [imageTypePicker showInView:self.view];

}

-(void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex != 2)
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        if(buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [imagePicker setAllowsEditing:YES];
        imagePicker.delegate = self;
        [self presentModalViewController:imagePicker animated:YES];

    }
}




-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissModalViewControllerAnimated:YES];
    UIImage *pickedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
    //resize image
    CGSize newSize = CGSizeMake(AVATAR_WIDTH, AVATAR_HEIGHT);

    UIGraphicsBeginImageContext(newSize);
    [pickedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    resizedImage = [ImageManipulator makeRoundCornerImage:resizedImage :CORNER_SIZE :CORNER_SIZE];
    
    
    //Make sure image is correct size
    DLog(@"Image picked: height:%f width:%f",resizedImage.size.width,resizedImage.size.height);
    [self.avatarImageView setImage:resizedImage];
    _avatarChanged = YES;
}



-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [self dismissModalViewControllerAnimated:YES];
}

#pragma mark Keyboard functions

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    
    if(textField == self.usernameTexField)
    {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefghijklmnopqrstuvwABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return (([string isEqualToString:filtered]));
    }
    return YES;
}


- (void)keyboardWillHide:(NSNotification *)notification
{
    [self showKeyboard:NO notification:notification];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    [self showKeyboard:YES notification:notification];
}

-(void)showKeyboard:(BOOL)show notification:(NSNotification *)notification
{
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    CGSize keyboardSize = keyboardFrame.size;
    
    CGRect newFrame =  self.scrollView.frame;
    if(show)
    {
        newFrame.size.height -= keyboardSize.height;
    }else{
        newFrame.size.height += keyboardSize.height;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    // animate the frame, otherwise you can see black
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    self.scrollView.frame = newFrame;
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

 -(void)hideKeyboard{
     [self.usernameTexField resignFirstResponder];
     [self.emailTextField resignFirstResponder];
     [self.passwordCheckTextField resignFirstResponder];
     [self.passwordTextField resignFirstResponder];
 }

- (IBAction)destroyUserSession:(id)sender {
    
    UIAlertView *logoutConformation = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"PLEASE_CONFRIM", @"Please confirm") message:NSLocalizedString(@"ARE_YOU_SURE", @"Are your sure you want to log out?") completionBlock:^(NSUInteger buttonIndex, UIAlertView *alertView) {
        if(buttonIndex == 1) {
            
            [[RKClient sharedClient] post:@"user/me/logout" usingBlock:^(RKRequest *request) {
                
            }];
            NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
            //Delete all coredata information
            NSFetchRequest *userFetch = [User fetchRequest];
            //[userFetch setReturnsObjectsAsFaults:NO];
            NSArray* users = [User objectsWithFetchRequest:userFetch];
            //DLog(@"Users to delete: %@",users);
            for (User *user in users) {
                [context deleteObject:user];
            }
            NSFetchRequest *gameFetch = [Game fetchRequest];
            //[gameFetch setReturnsObjectsAsFaults:NO];
            NSArray* games = [Game objectsWithFetchRequest:gameFetch];
            //DLog(@"Games to delete: %@",games);
            for (Game *game in games) {
                [context deleteObject:game];
            }
            NSFetchRequest *friendFetch = [Friend fetchRequest];
            //[friendFetch setReturnsObjectsAsFaults:NO];
            NSArray* friends = [Friend objectsWithFetchRequest:friendFetch];
            //DLog(@"Friends to delete: %@",friends);
            for (Friend *friend in friends) {
                [context deleteObject:friend];
            }
            NSError *error;
            [context save:&error];
            
            [[FBSession activeSession] closeAndClearTokenInformation];
            [[RKClient sharedClient].requestCache invalidateAll];
            [[NSManagedObjectContext contextForCurrentThread] reset];
            //Reset all nsuserdefaults
            /*NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
            [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];*/
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"deviceToken"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"achievements"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"settings_updated"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ranks_updated"];            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:SOUND_EFFECT];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:PREMIUM];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:FRIEND_INVITES];
            [[BadgeManager shared] set:0];
            
            [User setUser:nil];
            
            
            [self.navigationController popToRootViewControllerAnimated:TRUE];
        }
    }cancelButtonTitle:NSLocalizedString(@"NO", @"No") otherButtonTitles:NSLocalizedString(@"YES", @"Yes"),nil];
    
    [logoutConformation show];
    
}
@end
