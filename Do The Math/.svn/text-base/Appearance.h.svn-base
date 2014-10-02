//
//  Appearence.h
//  dothemath
//
//  Created by Innovattic 1 on 11/20/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COLOR_GREY 0x282C42
#define COLOR_RED 0xEC4647
#define COLOR_ORANJE 0xF59D49
#define COLOR_YELLOW 0xF9FF48
#define FONT_NAME @"DK Crayon Crumble"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define FONT_SIZE_SUB_TEXT 17
//#define FONT_NAME @"Marker Felt"
@interface Appearance : NSObject 

+(void)setCellLabel:(UILabel *)label;
+(void)setLabelFont:(UILabel *)label;
+(void)setTextFieldFont:(UITextField *)textfield;

+(NSString *)getFont;
+(CGFloat)subTextFontSize;

+(void)setDefaultAppearance;
+(void)setCellButton:(UIButton *)button;
+(void)setCellDeleteButton:(UIButton *)button;
+(void)setStyleButton:(UIButton *)button;

@end
