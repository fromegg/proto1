//
//  OpenCVController.m
//  TESTstory
//
//  Created by igor on 1/17/13.
//  Copyright (c) 2013 igor. All rights reserved.
//
#import "testVide.h"
#import "UIImage2OpenCV.h"

@implementation testVide

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSLog(@"init");
	}
	return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    v = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:v];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"Show View" forState:UIControlStateNormal];
    button.frame = CGRectMake(60, 60, 160.0, 40.0);
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    
    
    _videoCamera = [[CvVideoCamera alloc] initWithParentView:v];
    _videoCamera.delegate = self;
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _videoCamera.defaultFPS = 20;
    
#if (TARGET_IPHONE_SIMULATOR)
//    _lastFrame = [UIImage cvMatWithImage:[UIImage imageNamed:@"p1.jpg"]];
//    NSData *data =  imageToData([UIImage imageWithCVMat:_lastFrame]);
//    _imageView.image = dataToImage(data);
#endif
    
    [_videoCamera start];
}

-(void)processImage:(cv::Mat &)image
{
    _lastFrame = image.clone();
}

-(IBAction) buttonPressed: (id) sender
{
    [_videoCamera stop];
    v.image = [UIImage imageWithMat: _lastFrame andImageOrientation:UIImageOrientationUp];
}

@end
