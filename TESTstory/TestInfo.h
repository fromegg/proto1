//
//  TestInfo.h
//  TESTstory
//
//  Created by igor on 12/12/12.
//  Copyright (c) 2012 igor. All rights reserved.
//



@interface TestInfo : NSManagedObject
@property (atomic, strong) NSString  *name;
@property (atomic, strong) NSString  *cat;
@property (atomic, strong) NSData *capturedImage;
@property (atomic, strong) NSData *capturedImageCropped;
@property (atomic, strong) NSData *plotImage;

#pragma message("how to set custom methods,getters here ?")
//-(UIImage*) getCapturedImage;
//-(void) setupCapturedImage:(UIImage *)image;
//-(UIImage*) getCapturedImageCropped;
//-(void) setupCapturedImageCropped:(UIImage *)image;

@end

@protocol TestInfoHolder <NSObject>
@required
@property (nonatomic, strong) TestInfo* test;
@end

UIImage *dataToImage(NSData *data);
NSData *imageToData(UIImage *img);
