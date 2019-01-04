//
//  DetailCourseTableViewController.h
//  41CoreData
//
//  Created by Denis on 21.12.2018.
//  Copyright © 2018 Denis Vitrishko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Course;

@interface DetailCourseTableViewController : UITableViewController

@property (strong, nonatomic) Course *course;

@end
