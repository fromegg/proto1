//
//  TestDetailsVC.h
//  TESTstory
//
//  Created by igor on 12/12/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestTypePicker.h"
#import "TestInfo.h"

@protocol TestInfoDelegate <NSObject>
@required
-(void)createTestInfo:(NSString *)name :(NSString *)cat;
@end

@interface TestDetailsVC : UITableViewController<UITextFieldDelegate,TestTypePickerDelegate>
- (IBAction)onDone:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *nameTextfield;
@property (strong, nonatomic) IBOutlet UITableViewCell *testTypeCell;
@property (nonatomic) id<TestInfoDelegate> delegate;

- (IBAction)onCancel:(id)sender;

@end
