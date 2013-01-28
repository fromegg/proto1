//
//  TestResults.m
//  TESTstory
//
//  Created by igor on 1/22/13.
//  Copyright (c) 2013 igor. All rights reserved.
//

#import "TestResults.h"

@interface TestResults ()

@end

@implementation TestResults

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
    UITabBarController<TestInfoHolder> *parentCV = [self parentViewController];
    _test = parentCV.test;
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
