//
//  DataManager.h
//  41CoreData
//
//  Created by Denis on 21.12.2018.
//  Copyright © 2018 Denis Vitrishko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSPersistentContainer;
@class Student;

@interface DataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;


+ (DataManager *) sharedManager;

- (void)saveContext;

@end
