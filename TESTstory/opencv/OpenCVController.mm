//
//  OpenCVController.m
//  TESTstory
//
//  Created by igor on 1/17/13.
//  Copyright (c) 2013 igor. All rights reserved.
//
#import "UIImage+OpenCV.h"
#import "OpenCVController.h"

@interface OpenCVController ()
- (void)processFrame;
@end

@implementation OpenCVController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSLog(@"init");
	}
	return self;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return FALSE;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bool isPhotoesPresent = _test.capturedImage && _test.capturedImageCropped;
    [_nextButton setEnabled:isPhotoesPresent];

       
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tick" ofType:@"aiff"];
    AudioServicesCreateSystemSoundID((CFURLRef)objc_unretainedPointer([NSURL fileURLWithPath:path]), &_tickSound);
   
    UIImage *img = [UIImage imageNamed:@"aim1.png"];
    UIImageView* overlay = [[UIImageView alloc] initWithImage:img];
    [overlay setClipsToBounds:YES];

    [self.view addSubview:overlay];
    [self.view bringSubviewToFront:_control];
    
    
    _videoCamera = [[CvVideoCamera alloc] initWithParentView:_imageView];
    _videoCamera.delegate = self;
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _videoCamera.defaultFPS = 20;

    _state = 0;
    [_control setEnabled:NO forSegmentAtIndex:2];
    
#if (TARGET_IPHONE_SIMULATOR)
    _lastFrame = cv::Mat(100,100, CV_8UC3);
#endif
    
    [_videoCamera start];
}

- (UIImage*)cropImage:(cv::Mat&)src
{
//    using namespace cv;
//    Mat mask = Mat::zeros(src.rows, src.cols, CV_8UC1);
//    //rectangle(mask, bigRect, Scalar(255), CV_FILLED);
//    
//    drawContours(mask, tmp1, -1, Scalar(255,0,0), CV_FILLED);
//    Mat crop(src.rows, img0.cols, CV_8UC3);
//    crop.setTo(Scalar(0));
//    // and copy the magic apple
//    src.copyTo(crop, mask);
//    
    
    return [UIImage imageWithCVMat: _lastFrame];
}

- (IBAction)onAction:(id)sender
{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    

    if (selectedSegment == 0)
    {
        _state = 0;
    }
    else if (selectedSegment == 1)
    {
        _state = 1;
        [segmentedControl setEnabled:YES forSegmentAtIndex:2];
    }
    else if (selectedSegment == 2)
    {
        cv::Mat capturedCropped = _lastFrame.clone();
        cv::Mat captured = _lastFrame.clone();
        [self filter2:capturedCropped withCrop:YES];
        [self filter2:captured withCrop:NO];
        
        _test.capturedImage = imageToData([UIImage imageWithCVMat:captured]);
        _test.capturedImageCropped = imageToData([UIImage imageWithCVMat:capturedCropped]);
        
        AudioServicesPlaySystemSound(_tickSound);
        
        [segmentedControl setSelectedSegmentIndex:0];
        [_nextButton setEnabled:YES];
    }
}

- (void)filter1:(cv::Mat&)image
{
    cv::Mat edges;
    cv::Mat gray;
    
    cv::cvtColor(image, gray, CV_BGR2GRAY);
    cv::Canny(gray, edges, 30, 70);
    
    std::vector< std::vector<cv::Point> > c;

    CvMemStorage* storage = cvCreateMemStorage(0);
    CvSeq* contours=0;
    
    IplImage bin = edges;
    
    cvFindContours( &bin, storage, &contours, sizeof(CvContour), CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE, cvPoint(0,0));
    
    CvSeq* big = contours;
    CvRect bigRect = cvRect(0,0,0,0);
    
    while(contours)
    {
        CvRect bndRect = cvRect(0,0,0,0);
        
        bndRect = cvBoundingRect(contours, 0);
        if (bndRect.height * bndRect.width > bigRect.height * bigRect.width)
        {
            bigRect = bndRect;
            big = contours;
        }
        contours = contours->h_next;
    }
    
    {
        IplImage dst = image;
        cvDrawContours(&dst, big, cvScalar(0, 255, 0), cvScalar(0, 255, 0), -1, 4, 8);
        memcpy(dst.imageData, image.data, dst.height*dst.width);
    }
}

//-( // find biggest contour

- (void)filter2:(cv::Mat&)src withCrop:(BOOL)doCrop
{
    using namespace cv;
    Mat gray;
    cvtColor(src, gray, CV_RGB2GRAY);
    
    Canny(gray, gray, 160, 650, 5);
    
   // src = gray;
    
    typedef vector<cv::Point> TContour;
    typedef vector<TContour> TContours;
    TContours contours;
    int biggestContour = -1;
    findContours(gray, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    
    cv::Rect boundRect;
    cv::Rect bigRect = cv::Rect(0,0,0,0);
    
    for(TContours::iterator it = contours.begin(); it != contours.end(); it++)
    {
        //Get a bounding rectangle around the moving object.
        boundRect = boundingRect(*it);
        if (boundRect.height * boundRect.width > bigRect.height * bigRect.width)
        {
            bigRect = boundRect;
            biggestContour = (it - contours.begin());
        }
    }
    
    if(biggestContour == -1)
        return;
    
    TContour &simpleContour = contours[biggestContour];
    TContour approxedContour;
    approxPolyDP( simpleContour, approxedContour, arcLength(simpleContour, true)*0.02, true );
    
    TContours contoursApproxed;
    contoursApproxed.push_back(approxedContour);

    drawContours(src, contours, biggestContour, cvScalar(0, 255, 0), 2 );
    drawContours(src, contoursApproxed, -1, Scalar(255,0,0), 2);

    if(doCrop)
    {
        Mat mask = Mat::zeros(src.rows, src.cols, CV_8UC1);
        //rectangle(mask, bigRect, Scalar(255), CV_FILLED);
        
        drawContours(mask, contoursApproxed, -1, Scalar(255,0,0), CV_FILLED);
        Mat crop(src.rows, src.cols, CV_8UC3);
        crop.setTo(Scalar(0));
        src.copyTo(crop, mask);
        
        crop.copyTo(src);
    }
}


- (void)processImage:(cv::Mat&)image
{
    if(_state)
    {
        image.copyTo(_lastFrame);
        [self filter2:image withCrop:NO];
    }
}

#pragma message("REFACTOR THIS SHIT")

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ((id<TestInfoHolder>)segue.destinationViewController).test = _test;
    [_videoCamera stop];
}

-(void) viewWillAppear:(BOOL)animated
{
    [_videoCamera start];
    _state = 0;
    [_control setEnabled:NO forSegmentAtIndex:2];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [_videoCamera stop];
}


@end
