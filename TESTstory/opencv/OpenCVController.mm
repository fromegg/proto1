//
//  OpenCVController.m
//  TESTstory
//
//  Created by igor on 1/17/13.
//  Copyright (c) 2013 igor. All rights reserved.
//
#import "OpenCVController.h"
#import "UIImage2OpenCV.h"


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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [_spinner setCenter:self.view.center];
    [self.view addSubview:_spinner];
    [self.view bringSubviewToFront:_spinner];
    
    bool isPhotoesPresent = _test.capturedImage && _test.capturedImageCropped;
    [_nextButton setEnabled:isPhotoesPresent];
    
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"tick" ofType:@"aiff"];
    AudioServicesCreateSystemSoundID((CFURLRef)objc_unretainedPointer([NSURL fileURLWithPath:path]), &_tickSound);
    
    UIImage *aim = [UIImage imageNamed:@"aim1.png"];
    UIImageView* overlay = [[UIImageView alloc] initWithImage:aim];
    [overlay setClipsToBounds:YES];
    
    [self.view addSubview:overlay];
    [self.view bringSubviewToFront:_control];
    
    _videoCamera = [[CvVideoCamera alloc] initWithParentView:_imageView];
    _videoCamera.delegate = self;
    _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetMedium;
    _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    _videoCamera.defaultFPS = 20;
    
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:_videoCamera];
    
#if (TARGET_IPHONE_SIMULATOR)
    _imageView.image = [UIImage imageNamed:@"rawImage.png"];
    _lastFrame = [_imageView.image toMat];
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
    
    return [UIImage imageWithMat: _lastFrame andImageOrientation:UIImageOrientationUp];
}

- (IBAction)onAction:(id)sender
{
    AudioServicesPlaySystemSound(_tickSound);
    
    [_spinner startAnimating];
    
    __block cv::Mat capturedCropped = _lastFrame.clone();
    __block cv::Mat captured = _lastFrame.clone();

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
              
        [self unwrapTarget:capturedCropped];
        
        _test.capturedImage = imageToData([UIImage imageWithMat: captured andImageOrientation:UIImageOrientationUp]);
        _test.capturedImageCropped = imageToData([UIImage imageWithMat: capturedCropped andImageOrientation:UIImageOrientationUp]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_spinner stopAnimating];
            [_nextButton setEnabled:YES];
            
            [self performSegueWithIdentifier:@"afterCapturing" sender:self];
        });
        
    });
    
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
    
    //Canny(gray, gray, 160, 650, 5);
    Canny(gray, gray, 250, 250, 5);
    
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
    //drawContours(src, contoursApproxed, -1, Scalar(255,0,0), 2);
    
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

double angle( cv::Point pt1, cv::Point pt2, cv::Point pt0 ) {
    double dx1 = pt1.x - pt0.x;
    double dy1 = pt1.y - pt0.y;
    double dx2 = pt2.x - pt0.x;
    double dy2 = pt2.y - pt0.y;
    return (dx1*dx2 + dy1*dy2)/sqrt((dx1*dx1 + dy1*dy1)*(dx2*dx2 + dy2*dy2) + 1e-10);
}

- (void)unwrapTarget:(cv::Mat&)src
{
    using namespace cv;
    
    cv::Mat &dst = src;
    
    vector<vector<cv::Point> > squares;
    
    Mat image = src.clone();
    
    // blur will enhance edge detection
    Mat blurred(image);
    medianBlur(image, blurred, 9);
    
    Mat gray0(blurred.size(), CV_8U), gray;
    vector<vector<cv::Point> > contours;
    
    vector<cv::Point> bigRect;
    double sizeControur = 999999;
    
    
    // find squares in every color plane of the image
    for (int c = 0; c < 3; c++)
    {
        int ch[] = {c, 0};
        mixChannels(&blurred, 1, &gray0, 1, ch, 1);
        
        // try several threshold levels
        const int threshold_level = 2;
        for (int l = 0; l < threshold_level; l++)
        {
            // Use Canny instead of zero threshold level!
            // Canny helps to catch squares with gradient shading
            if (l == 0)
            {
                Canny(gray0, gray, 10, 20, 3); //
                
                // Dilate helps to remove potential holes between edge segments
                dilate(gray, gray, Mat(), cv::Point(-1,-1));
            }
            else
            {
                gray = gray0 >= (l+1) * 255 / threshold_level;
            }
            
            // Find contours and store them in a list
            findContours(gray, contours, CV_RETR_LIST, CV_CHAIN_APPROX_SIMPLE);
            
            // Test contours
            vector<cv::Point> approx;
            
            for (size_t i = 0; i < contours.size(); i++)
            {
                approxPolyDP(Mat(contours[i]), approx, arcLength(Mat(contours[i]), true)*0.02, true);
                
                if (approx.size() == 4 &&
                    fabs(contourArea(Mat(approx))) > 1000 &&
                    isContourConvex(Mat(approx)))
                {
                    double maxCosine = 0;
                    
                    for (int j = 2; j < 5; j++)
                    {
                        double cosine = fabs(angle(approx[j%4], approx[j-2], approx[j-1]));
                        maxCosine = MAX(maxCosine, cosine);
                    }
                    
                    if (maxCosine < 0.3 )
                    {
                        squares.push_back(approx);
                        if(fabs(contourArea(approx)) < sizeControur)
                        {
                            sizeControur = fabs(contourArea(approx));
                            bigRect = approx;
                        }
                    }
                }
            }
        }
    }
    
    if(bigRect.size())
    {
        cv::Point2i *rect_points = &bigRect[0];
        for ( int j = 0; j < 4; j++ )
        {
            // cv::line( dst, rect_points[j], rect_points[(j+1)%4], cv::Scalar(0,0,255), 2, 8 ); // blue
        }
        
        cv::RotatedRect box = minAreaRect(bigRect);
        std::cout << "Rotated box set to (" << box.boundingRect().x << "," << box.boundingRect().y << ") " << box.size.width << "x" << box.size.height << std::endl;
        
        Point2f pts[4];
        
        box.points(pts);
        
        float dist = pts[0].x + pts[0].y;
        int index = 0;
        for(int i = 0; i < 4; i++)
        {
            float tmp= (pts[i].x + pts[i].y);
            if(tmp < dist)
            {
                dist = tmp;
                index = i;
            }
        }
        
        cv::Point2f src_vertices[3];
        src_vertices[0] = pts[index++ % 4];
        src_vertices[1] = pts[index++ % 4];
        src_vertices[2] = pts[index++ % 4];
        
        Point2f dst_vertices[3];
        dst_vertices[0] = cv::Point(0, 0);
        dst_vertices[1] = cv::Point(box.boundingRect().width-1, 0);
        dst_vertices[2] = cv::Point(box.boundingRect().width-1, box.boundingRect().height-1);
        
        Mat warpAffineMatrix = getAffineTransform(src_vertices, dst_vertices);
        
        cv::Size size(box.boundingRect().width, box.boundingRect().height);
        warpAffine(dst, dst, warpAffineMatrix, size, INTER_LINEAR, BORDER_CONSTANT);
        
    }
}



- (void)processImage:(cv::Mat&)image
{
    _lastFrame = image.clone();
    [self filter2:image withCrop:NO];
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
}

-(void) viewWillDisappear:(BOOL)animated
{
    [_videoCamera stop];
}


@end
