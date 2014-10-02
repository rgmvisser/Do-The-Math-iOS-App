//
//  ScoreBarView.h
//  dothemath
//
//  Created by Innovattic 1 on 12/11/12.
//  Copyright (c) 2012 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreBarView : UIView


@property (nonatomic) NSTimeInterval delay;
@property (nonatomic) NSTimeInterval duration;

-(void)addScoreBarImage:(UIImage *)image;
-(void)setPresentage:(double)precentage withLabel:(UILabel*)label animated:(BOOL)animated;
@end
