//
//  OpenCVController.h
//  TESTstory
//
//  Created by igor on 1/17/13.
//  Copyright (c) 2013 igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestInfo.h"
#import <opencv2/highgui/cap_ios.h>
#import <AudioToolbox/AudioServices.h>

@interface OpenCVController : UIViewController<CvVideoCameraDelegate, TestInfoHolder>
{
    cv::Mat _lastFrame;
    CvVideoCamera *_videoCamera;
    int _state;
    UIActivityIndicatorView *_spinner;
}
@property (strong, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *control;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (assign) SystemSoundID tickSound;
@property(nonatomic) TestInfo *test;

- (IBAction)onAction:(id)sender;
- (void)filter1:(cv::Mat&)image;
- (void)filter2:(cv::Mat&)src withCrop:(BOOL)doCrop;
- (void)unwrapTarget:(cv::Mat&)src;
- (UIImage*)cropImage:(cv::Mat&)src;

@end
