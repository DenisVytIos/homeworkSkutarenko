//
//  StudentsTableViewController.m
//  41CoreData
//
//  Created by Denis on 21.12.2018.
//  Copyright © 2018 Denis Vitrishko. All rights reserved.
//

#import "StudentsTableViewController.h"
#import "DataManager.h"
#import "DetailStudentTableViewController.h"

@interface StudentsTableViewController ()

@end

@implementation StudentsTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

#pragma mark - View lifecycle

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(actionAdd:)];
    self.navigationItem.rightBarButtonItem = addBarButtonItem;
    
}

#pragma mark - Actions

- (void) actionAdd:(id)sender {
    
    [self performSegueWithIdentifier:@"DetailStudentTableViewController" sender:nil];
    
}

#pragma mark - Methods

- (void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    
    [super configureCell:cell withObject:object];
    
    Student *student = (Student *)object;

    cell.textLabel.text       = [NSString stringWithFormat:@"%@ %@", student.lastName, student.firstName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"courses: %d", (int)[student.courses count]];
    
}


#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[DetailStudentTableViewController class]]) {
        
        DetailStudentTableViewController *detailStudentTableViewController = segue.destinationViewController;
        detailStudentTableViewController.student = sender;
        
    }
    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"DetailStudentTableViewController" sender:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest<Student*> *fetchRequest = Student.fetchRequest;
    
    [fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptorLastName = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    NSSortDescriptor *sortDescriptorFirstName = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    
    [fetchRequest setSortDescriptors:@[sortDescriptorLastName, sortDescriptorFirstName]];
    
    NSFetchedResultsController<Student*> *aFetchedResultsController =
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

