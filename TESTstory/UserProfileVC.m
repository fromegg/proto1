//
//  UserProfileVC.m
//  TESTstory
//
//  Created by igor on 12/13/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "UserProfileVC.h"
#import <QuartzCore/QuartzCore.h>
#import "TestListVC.h"

@interface UserProfileVC ()
-(void)savePatientProfile;
-(void)loadPatientProfile;
@end

@implementation UserProfileVC


enum CATS
{
    patient,
    physican
};

enum TEXT_ROWS
{
    firstName,
    lastName,
    address,
    city,
    country,
    state,
    zip,
    phoneNumber,

};


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
#pragma message("how to find out previous viewcontroller?")
    if(self.navigationController)
    {
        [self.navigationController setToolbarHidden:YES animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self savePatientProfile];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Notification" message:@"Please fill in info texfield" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//    
//    [alert show];
//    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex: 0];
    _patientProfileFile = [dir stringByAppendingPathComponent: @"userProfile"];
    _patientProfile = [NSKeyedUnarchiver unarchiveObjectWithFile:_patientProfileFile];
    
    
     _patientProfile = [[PatientProfile sharedInstance] patientProfile];
    
    
    self.title = @"Patient Info";
    
    _patientList = @[
    @"First Name",
    @"Last Name",
    @"Address",
    @"City",
    @"Country",
    @"State",
    @"Zip",
    @"Phone"];
    
    _physicianList = @[
    @"Last Name",
    @"Phone",
    @"Email"];
    
    _sections = @[@"Patient", @"Physician"];
    
    [self loadPatientProfile];
    
    _fullList = [[NSMutableDictionary alloc] init];
    [_fullList setObject:_patientList forKey:[NSNumber numberWithInt:patient]];
    [_fullList setObject:_physicianList forKey:[NSNumber numberWithInt:physican]];
}

-(void)loadPatientProfile
{
   // _patientProfile = [[PatientProfile sharedInstance] patientProfile];
//    if(!_patientProfile)
//    {
//        NSMutableDictionary* patientFields = [[NSMutableDictionary alloc] initWithObjects:@[
//                                              @"First name",
//                                              @"Last Name",
//                                              @"Novgorodskaya St, 3B",
//                                              @"Kharkiv",
//                                              @"Ukraine",
//                                              @"",
//                                              @"",
//                                              @""] forKeys:_patientList];
//        
//        NSMutableDictionary* physicianFields = [[NSMutableDictionary alloc] initWithObjects:@[@"Dr. Alex",@"",@"physician@test.com"] forKeys:_physicianList];
//        _patientProfile = [[NSMutableDictionary alloc] initWithObjectsAndKeys:patientFields,@"Patient", physicianFields, @"Physician", nil];
//        NSLog(@"%@",_patientProfile);
//        NSLog(@"Patient profile generated");
//    }
//    else
//    {
//        NSLog(@"%@",_patientProfile);
//        NSLog(@"Patient profile loaded");
//    }
    
}

-(void)savePatientProfile
{
    BOOL res = [NSKeyedArchiver archiveRootObject:_patientProfile toFile:_patientProfileFile];
    NSLog(@"%@",_patientProfile);
    NSLog(@"Patient profile saved %d",res);
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sections objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _fullList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // NSArray* arr = [_fullList objectForKey:[NSNumber numberWithInt:section]];
    return [[_fullList objectForKey:[NSNumber numberWithInt:section]] count];
}

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.textColor = UIColorFromRGB(0x3A5FCD);
    [cell.textLabel setFont:[UIFont systemFontOfSize:[UIFont buttonFontSize]]];
    
    UITextField *playerTextField;
    for(id child in [cell subviews])
    {
        if([child isKindOfClass:[UITextField class]])
        {
            playerTextField = (UITextField*)child;
        }
    }
    
    if(playerTextField == nil)
    {
        playerTextField = [[UITextField alloc] initWithFrame:CGRectMake(130, 10, 185, 30)];
        playerTextField.adjustsFontSizeToFitWidth = YES;
        playerTextField.textColor = [UIColor grayColor];
        
        [playerTextField becomeFirstResponder];
        playerTextField.delegate = self;
        [cell addSubview:playerTextField];
    }
    
    NSString* sectionName = [_sections objectAtIndex:indexPath.section];
    NSString* fieldName = [[_fullList objectForKey:[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = fieldName;
    playerTextField.text = [[_patientProfile objectForKey:sectionName] objectForKey:fieldName];
    
    
    return cell;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell* parentCell = (UITableViewCell*)textField.superview;
    NSIndexPath* indexPath = [[self tableView] indexPathForCell:parentCell];
    NSString* sectionName = [_sections objectAtIndex:indexPath.section];
    NSString* fieldName = [[_fullList objectForKey:[NSNumber numberWithInt:indexPath.section]] objectAtIndex:indexPath.row];
    
    NSString* value = [textField text];
    if([value length] != 0)
    {
        [[_patientProfile objectForKey:sectionName] setValue:value forKey:fieldName];
        NSLog(@"saved to profile > [%@]:[%@]-\"%@\"", sectionName, fieldName, value);
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}


@end
