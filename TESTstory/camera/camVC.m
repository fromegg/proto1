//
//  camVC.m
//  TESTstory
//
//  Created by igor on 12/21/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "camVC.h"

@interface camVC ()

@end

@implementation camVC


- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

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

-(IBAction)menuClicked
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Some Action"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Save"
                                                    otherButtonTitles:nil];
    
    [actionSheet showInView:self.view];

}

-(IBAction)camClicked
{
    _picker = [[UIImagePickerController alloc] init];
    
    _picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        
        _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    } else
        
    {
        
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    [self presentViewController:_picker animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *) Picker
{
}


- (void)imagePickerController:(UIImagePickerController *) Picker

didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _selectedImage.image = info[UIImagePickerControllerOriginalImage];
    
    [[Picker parentViewController] dismissViewControllerAnimated:YES completion:nil];
    
}





@end
