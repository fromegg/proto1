//
//  UserProfileVC.h
//  TESTstory
//
//  Created by igor on 12/13/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic) NSArray* patientList;
@property (nonatomic) NSArray* physicianList;
@property (nonatomic) NSArray* sections;
@property (nonatomic) NSMutableDictionary* fullList;
@property (nonatomic) NSMutableDictionary* patientProfile;
@property (nonatomic) NSString* patientProfileFile;

@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) IBOutlet UIToolbar *toolbar;

@end
