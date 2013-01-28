//
//  TestTypePicker.m
//  TESTstory
//
//  Created by igor on 12/12/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "TestTypePicker.h"

@interface TestTypePicker ()

@end

@implementation TestTypePicker

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

    _testTypeList = @[@"Blood Sampling",@"Urine sampling",@"Drugs abuse testing",@"Alcohol test", @"Pregnancy test"];
    _selectedIndex = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_testTypeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
    cell.textLabel.text = [_testTypeList objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TestCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    [_delegate typeSelected:[_testTypeList objectAtIndex:indexPath.row]];
    [self.navigationController  popViewControllerAnimated:YES];
}



@end
