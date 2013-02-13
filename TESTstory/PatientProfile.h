//
//  PatientProfile.h
//  TESTstory
//
//  Created by igor on 2/12/13.
//  Copyright (c) 2013 igor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientProfile : NSObject
@property (nonatomic) NSMutableDictionary *patientProfile;
+(PatientProfile*)sharedInstance;
-(void)loadProfile;
@end
