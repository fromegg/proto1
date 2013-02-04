//
//  ReportVC.m
//  TESTstory
//
//  Created by igor on 12/14/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "ReportVC.h"
#import "TestDetails.h"

@interface ReportVC ()
-(IBAction)onDone:(id)sender;
@end

@implementation ReportVC

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex < [actionSheet cancelButtonIndex])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(IBAction)onDone:(id)sender
{

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Action"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Save"
                                                    otherButtonTitles:@"Send to Physician", nil];
    
    [actionSheet showInView:self.view];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITabBarController<TestInfoHolder> *tbvc = segue.destinationViewController;
    tbvc.test = _test;
    
    assert(tbvc.viewControllers.count == 2);
    ((TestDetails*)tbvc.viewControllers[0]).view.image = dataToImage(_test.capturedImageCropped);
    ((TestDetails*)tbvc.viewControllers[1]).view.image = dataToImage(_test.capturedImage);

}


@end
