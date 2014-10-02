//
//  TwentyFourButton.h
//  dothemath
//
//  Created by Innovattic 1 on 11/6/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwentyFourButton : UIControl

@property (nonatomic) int value;
@property (nonatomic) NSString *equation;

-(id)initWithFrame:(CGRect)frame type:(int)type;

-(void)selectPostIt;
-(void)deselectPostIt;

@end
