//
//  ReportVC.m
//  TESTstory
//
//  Created by igor on 12/14/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "ReportVC.h"
#import "TestDetails.h"
#import "GraphVC.h"

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
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex])
    {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    else if(buttonIndex == [actionSheet destructiveButtonIndex])
    {
        [self displayComposerSheet];
    }
    else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
-(IBAction)onDone:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Action"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Send to Physician"
                                                    otherButtonTitles:@"Return to main menu", nil];
    
    [actionSheet showInView:self.view];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITabBarController<TestInfoHolder> *tbvc = segue.destinationViewController;
    tbvc.test = _test;
    
//    assert(tbvc.viewControllers.count == 2);
#pragma message("How to replace this ugly code ?")
    
    ((TestDetails*)tbvc.viewControllers[1]).view.image = dataToImage(_test.capturedImageCropped);
    ((TestDetails*)tbvc.viewControllers[2]).view.image = dataToImage(_test.capturedImage);
}

-(void)displayComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    
    NSDictionary *profile = [[PatientProfile sharedInstance] patientProfile];
    
    NSString *physicianEmail = [[profile objectForKey:@"Physician"] objectForKey:@"Email"];
    NSString *physicianName = [[profile objectForKey:@"Physician"] objectForKey:@"Last Name"];
    NSString *patientName = [[profile objectForKey:@"Patient"] objectForKey:@"First Name"];
    NSString *patientLastName = [[profile objectForKey:@"Patient"] objectForKey:@"Last Name"];
    
    NSString *subject = @"[Test results] from %@ %@";
    subject = [NSString stringWithFormat:subject, patientName, patientLastName];
    
    NSString *emailBody = @"Hello %@, this is my result, check it please.";
    emailBody = [NSString stringWithFormat:emailBody, physicianName];
    

    
	
	NSArray *toRecipients = [NSArray arrayWithObject:physicianEmail];

    [picker setSubject:subject];
	[picker setToRecipients:toRecipients];

	[picker addAttachmentData:_test.capturedImageCropped mimeType:@"image/png" fileName:@"cropped"];    
	//[picker addAttachmentData:_test.capturedImage mimeType:@"image/png" fileName:@"rawImage"];
    [picker addAttachmentData:_test.plotImage mimeType:@"image/png" fileName:@"plot"];
    
	[picker setMessageBody:emailBody isHTML:NO];
    
	[self presentViewController:picker animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	NSString *message;
    
	switch (result)
	{
		case MFMailComposeResultCancelled:
			message = @"Result: canceled";
			break;
		case MFMailComposeResultSaved:
			message = @"Result: saved";
			break;
		case MFMailComposeResultSent:
			message = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
			message = @"Result: failed";
			break;
		default:
			message = @"Result: not sent";
			break;
	}
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mail status" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
