//
//  CreditViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 3/26/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "CreditViewController.h"
#import "Appearance.h"
@interface CreditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *developedBy;
@property (weak, nonatomic) IBOutlet UILabel *copyright;
@property (weak, nonatomic) IBOutlet UILabel *fun;
@property (weak, nonatomic) IBOutlet UIButton *dtmUrlbutton;
@property (weak, nonatomic) IBOutlet UIButton *fburlButton;
@property (weak, nonatomic) IBOutlet UILabel *likeOnFB;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation CreditViewController

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
    [self setTitle:NSLocalizedString(@"CREDITS", @"Credits title")];
    [self.background setImage:[UIImage imageNamed:@"common_background.jpg"]];
    [Appearance setLabelFont:self.developedBy];
    [Appearance setStyleButton:self.dtmUrlbutton];
    [Appearance setStyleButton:self.fburlButton];
    [Appearance setLabelFont:self.copyright];
    [Appearance setLabelFont:self.fun];
    [Appearance setLabelFont:self.likeOnFB];
    [Appearance setLabelFont:self.versionLabel];
    
    [self.developedBy setText:NSLocalizedString(@"DEVELOPED_BY", @"A math game developed by Innovattic")];
    [self.copyright setText:NSLocalizedString(@"COPYRIGHT", @"Copyright 2013 Innovattic. All rights reserved")];
    [self.likeOnFB setText:NSLocalizedString(@"LIKE_US_ON_FB", @"Like us on Facebook")];
    [self.fun setText:NSLocalizedString(@"WE_HOPE_HAVE_FUN", @"We hope you have had fun!")];
    
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    [self.versionLabel setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"VERSION", @"Versie"),[appInfo objectForKey:@"CFBundleShortVersionString"]]];
	// Do any additional setup after loading the view.
}
- (IBAction)openDTMurl:(id)sender {
    
    NSURL *url = [ [ NSURL alloc ] initWithString: @"http://www.dothemathgame.com" ];
    
    [[UIApplication sharedApplication] openURL:url];
    
}
- (IBAction)openFBurl:(id)sender {

    NSURL *url = [ [ NSURL alloc ] initWithString: @"fb://profile/350119961775413" ];
    if(![[UIApplication sharedApplication] canOpenURL:url])
    {
        url = [ [ NSURL alloc ] initWithString: @"http://www.facebook.com/dothemathgame" ];
    }
    [[UIApplication sharedApplication] openURL:url];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBackground:nil];
    [self setDevelopedBy:nil];
    [self setCopyright:nil];
    [self setFun:nil];
    [self setDtmUrlbutton:nil];
    [self setFburlButton:nil];
    [self setLikeOnFB:nil];
    [self setVersionLabel:nil];
    [super viewDidUnload];
}
@end
