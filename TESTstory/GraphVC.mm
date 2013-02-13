//
//  GraphVC.m
//  TESTstory
//
//  Created by igor on 2/7/13.
//  Copyright (c) 2013 igor. All rights reserved.
//

#import "GraphVC.h"
#import <opencv2/highgui/cap_ios.h>
#import "UIImage2OpenCV.h"


@implementation GraphVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    id<TestInfoHolder> testHolder = (id<TestInfoHolder>)self.parentViewController;
    
    [self processImage2: dataToImage(testHolder.test.capturedImageCropped)];
    [_graphView createGraph:&histograms];
#pragma message("Refactor this !!!!!!!!, remove from here on top level")
    testHolder.test.plotImage = imageToData([[_graphView graph] imageOfLayer]);

}

-(void)processImage:(UIImage*)img
{
    using namespace cv;
    
    Mat src, dst;
    src = [img toMat];

    /// Separate the image in 3 places ( B, G and R )
    vector<Mat> bgr_planes;
    split( src, bgr_planes );
    
    /// Establish the number of bins
    int histSize = 256;
    
    /// Set the ranges ( for B,G,R) )
    float range[] = { 0, 256 } ;
    const float* histRange = { range };
    
    bool uniform = true; bool accumulate = false;
    
    Mat b_hist, g_hist, r_hist;
    
    /// Compute the histograms:
    calcHist( &bgr_planes[0], 1, 0, Mat(), b_hist, 1, &histSize, &histRange, uniform, accumulate );
    calcHist( &bgr_planes[1], 1, 0, Mat(), g_hist, 1, &histSize, &histRange, uniform, accumulate );
    calcHist( &bgr_planes[2], 1, 0, Mat(), r_hist, 1, &histSize, &histRange, uniform, accumulate );
    
    int hist_w = 255; int hist_h = 400;
    
    Mat histImage( hist_h, hist_w, CV_8UC3, Scalar( 0,0,0) );
    
    /// Normalize the result to [ 0, histImage.rows ]
    normalize(b_hist, b_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );
    normalize(g_hist, g_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );
    normalize(r_hist, r_hist, 0, histImage.rows, NORM_MINMAX, -1, Mat() );

    histograms["red"].resize(256);
    histograms["green"].resize(256);
    histograms["blue"].resize(256);
    
    for( int i = 1; i < histSize; i++ )
    {
        histograms["red"][i] = cvRound(r_hist.at<float>(i));
        histograms["green"][i] = cvRound(g_hist.at<float>(i));
        histograms["blue"][i] = cvRound(b_hist.at<float>(i));
    }
}

-(void)processImage2:(UIImage*)img
{
    using namespace std;
    using namespace cv;
    
    Mat src = [img toMat];
    Mat gray;
    cvtColor(src, gray, CV_BGR2GRAY);
    
    vector<int> pixels(src.cols);
    
    {
        int depth = 4;
        int y = src.rows/2 - depth/2;
        
        for(int j = 0; j < depth; j++)
        {
            for(int i = 0; i < src.cols; i++)
            {
                uchar val = gray.at<uchar>(cv::Point(i, y + j));
                
                pixels[i] += val;
                
                if(val != 255)
                    printf("%3d) %d\n", i, val);
                
                //cout<< gray.at<Vec3b>(i,y + j)[2] << endl;
                //  printf("%d) %d \n",i, gray.at<Vec3b>(i,y + j)[2]);
                
            }
        }
        
        for(auto it = pixels.begin(); it != pixels.end(); it++)
        {
            (*it) /= depth; // get average
            (*it) = ABS(*it - 255); // invert
            // printf("%d) %d\n",it-pixels.begin(), *it);
        }
        
        int min = *min_element(pixels.begin(), pixels.end());
        int max = *max_element(pixels.begin(), pixels.end());
        for(auto it = pixels.begin(); it != pixels.end(); it++)
        {
            double normalized = (double)(*it - min)/(double)(max - min);
            *it =(normalized * 255);
            printf("%d \n", *it);
        }

        
    }
    
    histograms["red"].resize(pixels.size());
    for(int i = 0; i < pixels.size(); i++)
    {
        histograms["red"][i] = pixels[i];
    }
}

@end
