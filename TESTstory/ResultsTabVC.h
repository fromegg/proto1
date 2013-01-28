//
//  ResultsTabVC.h
//  TESTstory
//
//  Created by igor on 1/22/13.
//  Copyright (c) 2013 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestInfo.h"

@interface ResultsTabVC : UITabBarController<TestInfoHolder>
@property TestInfo *test;
@end
