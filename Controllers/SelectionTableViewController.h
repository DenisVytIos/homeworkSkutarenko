//
//  SelectionTableViewController.h
//  41CoreData
//
//  Created by Denis on 21.12.2018.
//  Copyright © 2018 Denis Vitrishko. All rights reserved.
//

#import "FetchingTableViewController.h"
#import "FetchingTableViewController.h"

@protocol SelectionTableViewDelegate;

typedef NS_ENUM(NSInteger, SelectionType) {
    
    SelectionTypeSingle,
    SelectionTypeMultiple
};

typedef void (^ActionAddBlock) (UIViewController*);

@interface SelectionTableViewController : FetchingTableViewController

@property (assign, nonatomic) SelectionType  selection;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSMutableArray *selectedRows;
@property (copy, nonatomic) ActionAddBlock actionAddNewRow;

@property (weak,nonatomic) id <SelectionTableViewDelegate> delegate;

@end

@protocol SelectionTableViewDelegate <NSObject>

@optional

- (void) didSelectObject:(id)object;
- (void) didDeselectObject:(id)object;

@end

