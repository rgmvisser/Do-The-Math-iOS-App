//
//  CustomGameCell.m
//  dothemath
//
//  Created by Innovattic 1 on 11/1/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "CustomGameCell.h"
#import "Game+Functions.h"
#import "UIImageView+dynamicLoad.h"
#import "Appearance.h"
#import "DifficultyView.h"
#import "SettingManager.h"
@interface CustomGameCell()
{
    Game *_game;
    CGRect _initButtonFrame;

}

@property (weak, nonatomic) IBOutlet DifficultyView *difficultyView;
@property (weak, nonatomic) IBOutlet UIImageView *timeLeftImage;
@property (weak, nonatomic) IBOutlet UILabel *timeLeftLabel;


@end

@implementation CustomGameCell

@synthesize difficultyView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];

    
    [Appearance setCellDeleteButton:self.button];
    _initButtonFrame = self.button.frame;
    [self.button setHidden:YES];
    [Appearance setLabelFont:self.timeLeftLabel];
    [self.timeLeftLabel setFont:[UIFont fontWithName:[Appearance getFont] size:14]];

    
}
- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    if(state == UITableViewCellStateShowingDeleteConfirmationMask) {
        for(UIView *subview in self.subviews)
        {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                subview.hidden = YES;
                subview.alpha = 0;
            }
        }
    }
    
    
    
    
}


- (void)layoutSubviews {
    if (self.editing) {
        [self.accessoryView setHidden:YES];
        //Dont resize text on animation
        self.button.titleLabel.adjustsFontSizeToFitWidth = NO;
        CGRect buttonFrame = _initButtonFrame;
        buttonFrame.origin.x += buttonFrame.size.width;
        buttonFrame.size.width = 0;
        self.button.frame = buttonFrame;
        [self.button setHidden:NO];
        [UIView animateWithDuration:0.6 animations:^{
            self.button.frame = _initButtonFrame;
        }];
    }
    else {
       [self.accessoryView setHidden:NO];
        __block CGRect buttonFrame = _initButtonFrame;
        buttonFrame.origin.x += buttonFrame.size.width;
        buttonFrame.size.width = 0;
        [UIView animateWithDuration:0.6 animations:^{
            self.button.frame = buttonFrame;
        } completion:^(BOOL finished) {
            [self.button setHidden:YES];
            
            //Resize text after animation
            self.button.titleLabel.adjustsFontSizeToFitWidth = YES;
        }];
    }
    [super layoutSubviews];
}


-(void)setGame:(Game *)game
{
    _game = game;
    Opponent *opponent = game.opponent;
    NSString *gameResult = @"";
    if([_game isComplete])
    {
        gameResult = [_game getResultOfGame];
        [self.timeLeftImage setHidden:YES];
        [self.timeLeftLabel setHidden:YES];
    }
    else{
        [self setTimeLeft];
    }
    
    
    self.username.text = [NSString stringWithFormat:@"%@ %@",opponent.username,gameResult];
    [self.difficultyView setDifficulty:game.difficulty withLabel:YES];
    
    [self.avatar setDynamicImage:[opponent opponentId] avatarId:[opponent avatar]];
}

-(void)setTimeLeft{
    [self.timeLeftImage setHidden:NO];
    [self.timeLeftLabel setHidden:NO];
    //standaard, als settings nog niet set zijn
    int expiration = 60*60*72;
    if([[SettingManager shared] gameExpiration] != -1)
    {
        expiration = [[SettingManager shared] gameExpiration]*60*60;
    }
    NSTimeInterval lastAction = [[[NSDate alloc] init] timeIntervalSinceDate:_game.lastAction];
    // The server keeps time in GMT. Therefore the app needs to consider this in the calculation
    int secondsLeft = expiration - (int)lastAction /*+ [[NSTimeZone localTimeZone] secondsFromGMT]*/;
    int hoursLeft = ceil(secondsLeft/(60.0f*60.0f));
    int minutesLeft = ceil(secondsLeft/(60.0f));
    if(hoursLeft < 0){ hoursLeft = 0; }
    if(minutesLeft < 0){ minutesLeft = 0; }
    if ( minutesLeft < 60 ) {
        [self.timeLeftLabel setText:[NSString stringWithFormat:@"%d %@",minutesLeft,NSLocalizedString(@"min", @"Letter for indication of minutes (min)")]];
    } else {
        [self.timeLeftLabel setText:[NSString stringWithFormat:@"%d %@",hoursLeft,NSLocalizedString(@"H", @"Letter for indication of hours (h)")]];
    }
}

@end
