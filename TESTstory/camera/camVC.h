//
//  camVC.h
//  TESTstory
//
//  Created by igor on 12/21/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface camVC : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property (nonatomic) UIImagePickerController* picker;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;
-(IBAction) camClicked;
-(IBAction) menuClicked;
@end
