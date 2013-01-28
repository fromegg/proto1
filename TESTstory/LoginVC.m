//
//  LoginVC.m
//  TESTstory
//
//  Created by igor on 12/28/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

@end

@implementation LoginVC

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -90; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return FALSE;
}

-(IBAction)onEnter:(id)sender
{
#pragma message("remove from here")
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex: 0];
    NSString *patientProfileFile = [dir stringByAppendingPathComponent: @"userProfile"];
    id file = [NSKeyedUnarchiver unarchiveObjectWithFile: patientProfileFile];
    
    UIViewController *next;
    if(!file)
    {
        next = [self.storyboard instantiateViewControllerWithIdentifier:@"userProfileFirstTime"];
    }
    else
    {
        next = [self.storyboard instantiateViewControllerWithIdentifier:@"startNavigation"];
    }
   
    [self presentViewController:next animated:YES completion:nil];
}


@end
