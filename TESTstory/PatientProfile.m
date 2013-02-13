//
//  PatientProfile.m
//  TESTstory
//
//  Created by igor on 2/12/13.
//  Copyright (c) 2013 igor. All rights reserved.
//

#import "PatientProfile.h"

@implementation PatientProfile

+(PatientProfile*)sharedInstance
{
    static PatientProfile *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance loadProfile];
    });
    
    return sharedInstance;
}

-(void)loadProfile
{
    
    NSArray *_patientList = @[
                     @"First Name",
                     @"Last Name",
                     @"Address",
                     @"City",
                     @"Country",
                     @"State",
                     @"Zip",
                     @"Phone"];
    
    NSArray * _physicianList = @[
                       @"Last Name",
                       @"Phone",
                       @"Email"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dir = [paths objectAtIndex: 0];
    NSString *file = [dir stringByAppendingPathComponent: @"userProfile"];
    _patientProfile = [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    
    if(!_patientProfile)
    {
        NSMutableDictionary* patientFields = [[NSMutableDictionary alloc] initWithObjects:@[
                                              @"Gomer",
                                              @"Simpson",
                                              @"Novgorodskaya St, 3B",
                                              @"Kharkiv",
                                              @"Ukraine",
                                              @"",
                                              @"",
                                              @""] forKeys:_patientList];
        
        NSMutableDictionary* physicianFields = [[NSMutableDictionary alloc] initWithObjects:@[@"Dr. Alex",@"",@"physician@test.com"] forKeys:_physicianList];
        _patientProfile = [[NSMutableDictionary alloc] initWithObjectsAndKeys:patientFields,@"Patient", physicianFields, @"Physician", nil];
        NSLog(@"%@",_patientProfile);
        NSLog(@"Patient profile generated");
    }
    else
    {
        NSLog(@"%@",_patientProfile);
        NSLog(@"Patient profile loaded");
    }
    
}


@end
