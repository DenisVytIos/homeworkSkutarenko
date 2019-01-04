//
//  DetailStudentTableViewController.m
//  41CoreData
//
//  Created by Denis on 21.12.2018.
//  Copyright © 2018 Denis Vitrishko. All rights reserved.
//

#import "DetailStudentTableViewController.h"
#import "DetailStudentTableViewController.h"
#import "DataManager.h"
#import "DetailStudentTableViewCell.h"
#import "Student+CoreDataClass.h"
#import "Course+CoreDataClass.h"

@interface DetailStudentTableViewController () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *allTextFields;
@property (strong, nonatomic) NSArray *courses;
@property (strong, nonatomic) NSArray *teacher;

@end

@implementation DetailStudentTableViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *saveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(actionSave:)];
    
    self.navigationItem.rightBarButtonItem = saveBarButtonItem;
    
    if (self.student) {
        self.navigationItem.title = @"Edit user";
    } else {
        self.navigationItem.title = @"Add user";
    }
    
    self.allTextFields = [NSArray array];
    self.courses = [self.student.courses allObjects];
    self.teacher = [self.student.teacher allObjects];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ([self.allTextFields count] > 0) {
        
        [[self.allTextFields firstObject] becomeFirstResponder];
        
    }
    
}

#pragma mark - Methods

- (void)addSettingForTextField:(UITextField*)textField withFormat:(FormatTextField)format {
    
    if (format == FormatTextFieldName) {
        
        textField.keyboardType = UIKeyboardTypeAlphabet;
        textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyNext;
        
    } else if (format == FormatTextFieldEmail) {
        
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.returnKeyType = UIReturnKeyDone;
        
    }
    
}

- (NSInteger) countInString:(NSString*)string substring:(NSString*)substring {
    
    NSInteger count = 0;
    
    NSRange findingRange = [string rangeOfString:substring];
    while (YES) {
        if (findingRange.location != NSNotFound) {
            
            NSRange searchRange = NSMakeRange(findingRange.location + 1, [string length] - findingRange.location - 1);
            findingRange = [string rangeOfString:substring options:0 range:searchRange];
            count++;
            
        } else {
            break;
        }
    }
    
    return count;
    
}

#pragma mark - Actions

- (void) actionSave:(UIBarButtonItem *)sender {
    
    UITextField *textField = [self.allTextFields firstObject];
    if ([textField.text length] == 0) {
        
        return;
        
    } else {
        
        textField = [self.allTextFields objectAtIndex:1];
        if ([textField.text length] ==  0) {
            
            return;
        }
    }
    
    NSManagedObjectContext *context = [DataManager sharedManager].persistentContainer.viewContext;
    
    if (!self.student) {
        
        self.student = [[Student alloc] initWithContext:context];
        
    }
    
    textField = [self.allTextFields firstObject];
    if ([textField.text length] > 0) {
        self.student.firstName = textField.text;
        textField = [self.allTextFields objectAtIndex:1];
        if ([textField.text length] > 0) {
            self.student.lastName = textField.text;
            textField = [self.allTextFields lastObject];
            self.student.email = textField.text;
        }
    }
    
    NSError *error = nil;
    if (![context save:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger countSections = 1;
    
    if (self.student) {
        if ([self.courses count] > 0) {
            countSections++;
        }
        if ([self.teacher count] > 0) {
            countSections++;
        }
    }
    
    return countSections;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 3;
        
    } else if (section == 1) {
        
        if ([self.courses count] > 0) {
            return [self.courses count];
        } else {
            return [self.teacher count];
        }
    } else {
        return [self.teacher count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        DetailStudentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailStudentTableViewCell" forIndexPath:indexPath];
        
        switch (indexPath.row) {
            case 0:
                cell.title.text = @"First Name";
                cell.textField.placeholder = @"First name";
                cell.formatTextField = FormatTextFieldName;
                [self addSettingForTextField:cell.textField withFormat:cell.formatTextField];
                if (self.student) {
                    cell.textField.text = self.student.firstName;
                }
                break;
            case 1:
                cell.title.text = @"Last Name";
                cell.textField.placeholder = @"Last name";
                cell.formatTextField = FormatTextFieldName;
                [self addSettingForTextField:cell.textField withFormat:cell.formatTextField];
                if (self.student) {
                    cell.textField.text = self.student.lastName;
                }
                break;
            case 2:
                cell.title.text = @"Email";
                cell.textField.placeholder = @"Email";
                cell.formatTextField = FormatTextFieldEmail;
                [self addSettingForTextField:cell.textField withFormat:cell.formatTextField];
                if (self.student) {
                    cell.textField.text = self.student.email;
                }
                break;
        }
        
        if (![self.allTextFields containsObject:cell.textField]) {
            self.allTextFields = [self.allTextFields arrayByAddingObject:cell.textField];
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCourseTableViewCell" forIndexPath:indexPath];
        
        if ([self.courses count] > 0) {
            
            Course* course = [self.courses objectAtIndex:indexPath.row];
            cell.textLabel.text = course.name;
            
        } else {
            
            Course* course = [self.teacher objectAtIndex:indexPath.row];
            cell.textLabel.text = course.name;
            
        }
        return  cell;
        
    } else {
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCourseTableViewCell" forIndexPath:indexPath];
        Course* course = [self.teacher objectAtIndex:indexPath.row];
        cell.textLabel.text = course.name;
        return cell;
        
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"User Info";
    } else if (section == 1) {
        if ([self.courses count] > 0) {
            return @"Learning courses";
        } else {
            return @"Teaching courses";
        }
    } else {
        return @"Teaching courses";
    }
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString* newString = [NSMutableString stringWithString:textField.text];
    [newString replaceCharactersInRange:range withString:string];
    
    NSCharacterSet* validCharacterName = [NSCharacterSet letterCharacterSet];
    NSMutableCharacterSet* validCharacterEmailAddress = [NSMutableCharacterSet alphanumericCharacterSet];
    [validCharacterEmailAddress formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"@._"]];
    
    NSArray* componentsString;
    
    
    if ([textField isEqual:[self.allTextFields lastObject]]) {
        
        componentsString = [newString componentsSeparatedByCharactersInSet:[validCharacterEmailAddress invertedSet]];
        
        if ([componentsString count] > 1) {
            return NO;
        } else {
            
            NSInteger countSymbol = [self countInString:newString substring:@"@"];
            if (countSymbol > 1) {
                return NO;
            }
            
            countSymbol = [self countInString:newString substring:@"."];
            if (countSymbol > 1) {
                return NO;
            }
            
        }
        
    } else {
        
        componentsString = [newString componentsSeparatedByCharactersInSet:[validCharacterName invertedSet]];
        
        if ([componentsString count] > 1) {
            return NO;
        }
        
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == [self.allTextFields lastObject]) {
        [textField resignFirstResponder];
    } else {
        
        NSInteger index = [self.allTextFields indexOfObject:textField];
        
        [[self.allTextFields objectAtIndex:index + 1] becomeFirstResponder];
    }
    
    return YES;
}

@end
