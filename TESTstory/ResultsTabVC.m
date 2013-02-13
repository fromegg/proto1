//
//  ResultsTabVC.m
//  TESTstory
//
//  Created by igor on 1/22/13.
//  Copyright (c) 2013 igor. All rights reserved.
//

#import "ResultsTabVC.h"

@interface ResultsTabVC ()

@end

@implementation ResultsTabVC

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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    btn.titleLabel.text = @"Hello";
    
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
