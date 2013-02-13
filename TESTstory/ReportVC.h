//
//  ReportVC.h
//  TESTstory
//
//  Created by igor on 12/14/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestInfo.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ReportVC : UIViewController<UIActionSheetDelegate, TestInfoHolder, UIAlertViewDelegate, MFMailComposeViewControllerDelegate>
@property (nonatomic) TestInfo *test;
@end
