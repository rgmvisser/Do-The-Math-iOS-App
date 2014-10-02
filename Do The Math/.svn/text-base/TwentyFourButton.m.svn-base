//
//  TwentyFourButton.m
//  dothemath
//
//  Created by Innovattic 1 on 11/6/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#define left_bottom_selected @"24_postit_left_bottom_selected.png"
#define right_bottom_selected @"24_postit_right_bottom_selected.png"
#define right_top_selected @"24_postit_right_top_selected.png"
#define left_top_selected @"24_postit_left_top_selected.png"

#define left_bottom @"24_postit_left_bottom.png"
#define right_bottom @"24_postit_right_bottom.png"
#define right_top @"24_postit_right_top.png"
#define left_top @"24_postit_left_top.png"


#import "TwentyFourButton.h"

@interface TwentyFourButton()
{
    UILabel *_valueLabel;
    UILabel *_equationLabel;
    UIImageView *_postitImage;
    int _currentValue;
}
@end

@implementation TwentyFourButton

@synthesize value = _value;
@synthesize equation = _equation;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame type:(int)type {
    self = [super initWithFrame:frame];
    if (self) {
        // Set the labels of the button
        _valueLabel = [[UILabel alloc] init];
        _equationLabel = [[UILabel alloc] init];
        _valueLabel.text = @"";
        _equationLabel.text = @"";
        _valueLabel.textAlignment = UITextAlignmentCenter;
        _equationLabel.textAlignment = UITextAlignmentCenter;
        [_equationLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:16]];
        [_valueLabel setFont:[UIFont fontWithName:@"DK Crayon Crumble" size:30]];
        [_valueLabel setBackgroundColor:[UIColor clearColor]];
        [_equationLabel setBackgroundColor:[UIColor clearColor]];
        
        // Position the button according to the locations
        CGRect equationFrame;
        CGRect valueFrame;
        CGAffineTransform rotate;
        switch (type) {
            case 1: //left-top
                _postitImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:left_top] highlightedImage:[UIImage imageNamed:left_top_selected]];
                equationFrame = CGRectMake(27, 8, 72, 25);
                valueFrame = CGRectMake(28, 8, 68, 63);
                rotate = CGAffineTransformMakeRotation(0.03);
                break;
            case 2: //right-top
                _postitImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:right_top] highlightedImage:[UIImage imageNamed:right_top_selected]];
                equationFrame = CGRectMake(29, 8, 66, 31);
                valueFrame = CGRectMake(27, 8, 62, 72);
                rotate = CGAffineTransformMakeRotation(0.17);
                break;
            case 3: //left-bottom
                _postitImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:left_bottom] highlightedImage:[UIImage imageNamed:left_bottom_selected]];
                equationFrame = CGRectMake(28, 8, 70, 25);
                valueFrame = CGRectMake(29, 8, 68, 66);
                rotate = CGAffineTransformMakeRotation(0.04);
                break;
            case 4: //right-bottom
                _postitImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:right_bottom] highlightedImage:[UIImage imageNamed:right_bottom_selected]];
                equationFrame = CGRectMake(22, 2, 70, 26);
                valueFrame = CGRectMake(27, 2, 71, 67);
                rotate = CGAffineTransformMakeRotation(-0.16);
                break;
            default:
                break;
        }
        
        // Apply the location and transformation settings
        _valueLabel.transform = rotate;
        _equationLabel.transform = rotate;
        [_valueLabel setFrame:valueFrame];
        [_equationLabel setFrame:equationFrame];
        [_postitImage setFrame:CGRectMake(0, 0, 100, 83)];
        
        // Add the image to the view
        [_postitImage addSubview:_valueLabel];
        [_postitImage addSubview:_equationLabel];
        [self addSubview:_postitImage];
    }
    return self;
}

-(NSString *)equation {
    if(!_equation) {
        _equation = @"";
    }
    return _equation;
}

-(void) setEquation:(NSString *)equation {
    _equation = equation;
    _equationLabel.text = equation;
}

-(void)selectPostIt {
    [_postitImage setHighlighted:YES];
}

-(void)deselectPostIt {
    [_postitImage setHighlighted:NO];
}


-(void)setValue:(int)value {
    _value = value;
    _valueLabel.text = [NSString stringWithFormat:@"%d",value];
}

@end
