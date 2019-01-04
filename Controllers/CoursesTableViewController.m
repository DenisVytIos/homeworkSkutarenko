//
//  CoursesTableViewController.m
//  41CoreData
//
//  Created by Denis on 21.12.2018.
//  Copyright © 2018 Denis Vitrishko. All rights reserved.
//

#import "CoursesTableViewController.h"
#import "Course+CoreDataClass.h"
#import "DetailCourseTableViewController.h"

@interface CoursesTableViewController ()

@end

@implementation CoursesTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    
}

#pragma mark - Actions

- (void) actionAdd:(id)sender {
    
    [self performSegueWithIdentifier:@"DetailCourseTableViewController" sender:nil];
    
}

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    [super configureCell:cell withObject:object];
    
    Course *course = (Course *)object;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", course.name];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"students: %d", (int)[course.students count]];
    
}


#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[DetailCourseTableViewController class]]) {
        
        DetailCourseTableViewController* detailCourseTableViewController = segue.destinationViewController;
        detailCourseTableViewController.course = sender;
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"DetailCourseTableViewController" sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Course*> *fetchRequest = Course.fetchRequest;
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController<Course*> *aFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
    
}

@end
