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

@interface testVide : UIViewController<CvVideoCameraDelegate, TestInfoHolder>
{
    cv::Mat _lastFrame;
    CvVideoCamera *_videoCamera;
    UIActivityIndicatorView *_spinner;
    UIImageView *v;
}

-(IBAction) buttonPressed:(id)sender;

@end
