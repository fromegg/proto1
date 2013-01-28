//
//  TestDetailsVC.m
//  TESTstory
//
//  Created by igor on 12/12/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "TestDetailsVC.h"
#import "TestTypePicker.h"



@implementation TestDetailsVC;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _testTypeCell.textLabel.text = @"Pregnancy test";
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy HH:mm"];

    _nameTextfield.text = [dateFormatter stringFromDate:[NSDate date]];

}

-(void)dealloc
{
    NSLog(@"TestDetailsVC destroy");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSLog(@"init");
	}
	return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		[_nameTextfield becomeFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onDone:(id)sender
{
    [_delegate createTestInfo:_nameTextfield.text :_testTypeCell.textLabel.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"segue ChooseTest");
    
    TestTypePicker *vc = segue.destinationViewController;
    vc.delegate = self;    
}

- (IBAction)onCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)typeSelected:(NSString *)typeName
{
    _testTypeCell.textLabel.text = typeName;
}
@end
