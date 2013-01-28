//
//  AppDelegate.m
//  TESTstory
//
//  Created by igor on 12/10/12.
//  Copyright (c) 2012 igor. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

NSManagedObjectModel *getManagedObjectModel();

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _managedObjectContext = [self managedObjectContext];
    return YES;
}

+ (AppDelegate *)sharedInstance
{
    static AppDelegate *sharedInstance;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)saveContext
{
    NSError *error = nil;
    if (_managedObjectContext != nil)
    {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{    
    if (_managedObjectModel != nil)
    {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TestsModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"testsStorage.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
@end

// not used
NSManagedObjectModel *getManagedObjectModel()
{
    static NSManagedObjectModel *mom = nil;
    
    if (mom != nil) {
        return mom;
    }
    
    NSEntityDescription *runEntity = [[NSEntityDescription alloc] init];
    [runEntity setName:@"Run"];
    [runEntity setManagedObjectClassName:@"Run"];
    
    NSAttributeDescription *dateAttribute = [[NSAttributeDescription alloc] init];
    
    [dateAttribute setName:@"date"];
    [dateAttribute setAttributeType:NSDateAttributeType];
    [dateAttribute setOptional:NO];
    
    NSAttributeDescription *idAttribute = [[NSAttributeDescription alloc] init];
    
    [idAttribute setName:@"processID"];
    [idAttribute setAttributeType:NSInteger64AttributeType];
    [idAttribute setOptional:NO];
    [idAttribute setDefaultValue:[NSNumber numberWithInteger:-1]];
    
    NSExpression *lhs = [NSExpression expressionForEvaluatedObject];
    NSExpression *rhs = [NSExpression expressionForConstantValue:@0];
    
    NSPredicate *validationPredicate = [NSComparisonPredicate
                                        predicateWithLeftExpression:lhs
                                        rightExpression:rhs
                                        modifier:NSDirectPredicateModifier
                                        type:NSGreaterThanPredicateOperatorType
                                        options:0];
    
    NSString *validationWarning = @"Process ID < 1";
    
    [idAttribute setValidationPredicates:@[validationPredicate]
                  withValidationWarnings:@[validationWarning]];
    
    [runEntity setProperties:@[dateAttribute, idAttribute]];
    
    mom = [[NSManagedObjectModel alloc] init];
    [mom setEntities:@[runEntity]];
    
    
    return mom;
}




