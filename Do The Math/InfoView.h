//
//  info.h
//  dothemath
//
//  Created by Innovattic 1 on 3/26/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoView : UIView

@property (nonatomic,assign) CGRect locationCircle;
@property (nonatomic,assign) CGPoint locationBoard;
@property (nonatomic,assign) CGRect locationArrow;
@property (nonatomic,retain) NSString *info;

-(id)initWithFrame:(CGRect)frame info:(NSString *)info board:(CGPoint)boardLocation circle:(CGRect)circle arrow:(CGRect)arrow;

@end
