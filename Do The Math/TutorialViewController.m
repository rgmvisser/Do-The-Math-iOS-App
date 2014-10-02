//
//  TutorialViewController.m
//  dothemath
//
//  Created by Innovattic 1 on 3/26/13.
//  Copyright (c) 2013 Innovattic. All rights reserved.
//

#import "TutorialViewController.h"
#import "InfoView.h"
#import "Tutorial.h"
@interface TutorialViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation TutorialViewController

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
	// Do any additional setup after loading the view.
    
    CGPoint board = CGPointMake(20, 229);
    CGRect circle = CGRectMake(40, 112, 79, 128);
    CGRect arrow = CGRectMake(88, 66, 127, 68);
    UIImage *image1 = [UIImage imageNamed:@"foto 1"];
    UIImage *image2 = [UIImage imageNamed:@"foto 2"];
    
    InfoView *info1 = [[InfoView alloc] initWithFrame:self.scrollView.frame info:@"Dit is het niveau van het spel dat jullie aan het spelen zijn." board:board circle:circle arrow:arrow];
    
    board = CGPointMake(20, 229);
    circle = CGRectMake(0, 9, 127, 68);
    arrow = CGRectMake(121, 45, 133, 195);
    InfoView *info2 = [[InfoView alloc] initWithFrame:self.scrollView.frame info:@"Dit is het niveau van het spel dat jullie aan het spelen zijn." board:board circle:circle arrow:arrow];
    
    board = CGPointMake(20, 267);
    circle = CGRectMake(184, 82, 127, 68);
    arrow = CGRectMake(126, 131, 98, 144);
    InfoView *info3 = [[InfoView alloc] initWithFrame:self.scrollView.frame info:@"Dit is het niveau van het spel dat jullie aan het spelen zijn." board:board circle:circle arrow:arrow];
    
    Tutorial *tut1 = [[Tutorial alloc] initWithImages:[NSArray arrayWithObjects:image1, image2, nil] andInfo:[NSArray arrayWithObjects:[NSArray arrayWithObjects:info1,info2, nil],[NSArray arrayWithObjects:info3, nil], nil]];
    [self showTutorial:tut1];
    
}

-(void)showTutorial:(Tutorial *)tutorial
{
    int index = 0;
    int count = 0;
    CGRect frame = self.scrollView.frame;
    for(UIImage *tutImage in tutorial.images)
    {
       
        for(InfoView *infoView in [tutorial.infos objectAtIndex:index])
        {
             frame.origin.x = self.scrollView.frame.size.width * count;
            UIView *container = [[UIView alloc] initWithFrame:frame];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
            [imageView setImage:tutImage];
            [container addSubview:imageView];
            [container addSubview:infoView];
            
            [self.scrollView addSubview:container];
            count++;
        }
        index++;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * count, self.scrollView.frame.size.height);
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
