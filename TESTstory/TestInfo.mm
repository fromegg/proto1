//
//  TestInfo.m
//  TESTstory
//
//  Created by igor on 12/12/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "TestInfo.h"

@implementation TestInfo
@dynamic name;
@dynamic cat;
@dynamic capturedImageCropped;
@dynamic capturedImage;



//-(void) setupCapturedImage:(UIImage *)image
//{
//    capturedImage = [UIImagePNGRepresentation(image) copy];
//}
//
//-(UIImage*) getCapturedImage
//{
//    return [UIImage imageWithData:capturedImage];
//}
//
//
//-(void) setupCapturedImageCropped:(UIImage *)image
//{
//    capturedImageCroped = [UIImagePNGRepresentation(image) copy];
//}
//
//-(UIImage*) getCapturedImageCropped
//{
//    return UIImage imageWithData:capturedImageCroped];
//}[

@end

UIImage *dataToImage(NSData *data)
{
    return [UIImage imageWithData:data];
}

NSData *imageToData(UIImage *img)
{
    return UIImagePNGRepresentation(img);
}


