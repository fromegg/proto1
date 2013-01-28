//
//  TestListVC.h
//  TESTstory
//
//  Created by igor on 12/12/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestDetailsVC.h"

@interface TestListVC : UITableViewController<TestInfoDelegate>

@property NSMutableArray *testList;
@property NSString *selectedTest;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

-(IBAction)gotoPatientProfile:(id)sender;

@end
