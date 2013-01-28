//
//  ReportVC.h
//  TESTstory
//
//  Created by igor on 12/14/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestInfo.h"

@interface ReportVC : UIViewController<UIActionSheetDelegate, TestInfoHolder>
@property (nonatomic) TestInfo *test;
@end
