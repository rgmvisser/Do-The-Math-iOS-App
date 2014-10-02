//
//  Appearence.m
//  dothemath
//
//  Created by Innovattic 1 on 11/20/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import "Appearance.h"


@implementation Appearance

/**
 * Set the layout for a label in a uitablecell
 */
+(void)setCellLabel:(UILabel *)label;
{
    [self setLabelFont:label];
    [label setTextColor:[UIColor blackColor]];
}

/**
 * Get the default font name
 */
+(NSString *)getFont
{
    return FONT_NAME;
}

/**
 * Get the default subtext font size
 */
+ (CGFloat)subTextFontSize
{
    return FONT_SIZE_SUB_TEXT;
}


/**
 * Set the font for a label, correct the size with 3, because default fontsize looks much bigger in storyboard
 */
+(void)setLabelFont:(UILabel *)label
{
    [label setFont:[UIFont fontWithName:FONT_NAME size:label.font.pointSize+3]];
}

/**
 * Set the font for a textfield, correct the size with 3, because default fontsize looks much bigger in storyboard
 */
+(void)setTextFieldFont:(UITextField *)textfield{
    [textfield setFont:[UIFont fontWithName:FONT_NAME size:textfield.font.pointSize+3]];
}

/**
 * Set the font for a cellbutton, also, set also a default background with inset
 */
+(void)setCellButton:(UIButton *)button
{
    //[button.titleLabel setFont:[UIFont fontWithName:button.titleLabel.font.familyName size:18]];
    CGRect buttonFrame = button.frame;
    buttonFrame.origin.x = 287-buttonFrame.size.width;
    buttonFrame.origin.y = 12;
    buttonFrame.size.height = 35;
    button.frame = buttonFrame;

    UIImage *backgroundImage = [[UIImage imageNamed:@"button_accept.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0,10,0,10)];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
      
    [self setCellLabel:button.titleLabel];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.lineBreakMode = UILineBreakModeClip;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    
}

/**
 * Set the font for a delete button in a cell, also, set also a default background with inset
 */
+(void)setCellDeleteButton:(UIButton *)button
{
    //[button.titleLabel setFont:[UIFont fontWithName:button.titleLabel.font.familyName size:18]];
    CGRect buttonFrame = button.frame;
    buttonFrame.origin.x = 287-buttonFrame.size.width;
    buttonFrame.origin.y = 12;
    buttonFrame.size.height = 35;
    button.frame = buttonFrame;
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"button_delete.png"]  resizableImageWithCapInsets:UIEdgeInsetsMake(0,10,0,10)];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [self setCellLabel:button.titleLabel];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.lineBreakMode = UILineBreakModeClip;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
    
}


/**
 * Set the font for a cellbutton, also, set also a default background with inset
 */
+(void)setStyleButton:(UIButton *)button
{
    [self setLabelFont:button.titleLabel];
    button.titleLabel.numberOfLines = 1;
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleLabel.lineBreakMode = UILineBreakModeClip;
    [button setTitleEdgeInsets:UIEdgeInsetsMake(3, 0, 0, 0)];
}

/*
 * Style common ui elements
 */
+(void)setDefaultAppearance
{
    //set the navbar image
    UIImage *navBarImage = [UIImage imageNamed:@"navbar_corners.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBarImage forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:FONT_NAME size:26], UITextAttributeFont,
      nil]];
    
    //set the barbutton image
    UIImage *barButton = [[UIImage imageNamed:@"bar_button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    //set the backbutton image
    UIImage *backButton = [[UIImage imageNamed:@"bar_button_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,15,0,6)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButton forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    //style the barbutton items
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor],
      UITextAttributeTextColor,
      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6],
      UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      UITextAttributeTextShadowOffset,
      [UIFont fontWithName:FONT_NAME size:18],
      UITextAttributeFont,
      nil] forState:UIControlStateNormal];
    
    //style a searchbar
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchbar_white.png"] forState:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"icon_search.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

@end
