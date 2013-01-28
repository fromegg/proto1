//
//  LoginVC.h
//  TESTstory
//
//  Created by igor on 12/28/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *passTextField;
-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(IBAction)onEnter:(id)sender;
@end
