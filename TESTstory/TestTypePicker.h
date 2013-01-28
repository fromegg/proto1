//
//  TestTypePicker.h
//  TESTstory
//
//  Created by igor on 12/12/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TestTypePickerDelegate <NSObject>
@required
- (void)typeSelected:(NSString *)typeName;
@end

@interface TestTypePicker : UITableViewController
@property (nonatomic) NSArray* testTypeList;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) id<TestTypePickerDelegate> delegate;
@end
