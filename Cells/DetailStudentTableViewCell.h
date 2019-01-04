//
//  DetailStudentTableViewCell.h
//  41CoreData
//
//  Created by Denis on 21.12.2018.
//  Copyright © 2018 Denis Vitrishko. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FormatTextField) {
    FormatTextFieldInteger,
    FormatTextFieldName,
    FormatTextFieldEmail,
    FormatTextFieldFloat
};

@interface DetailStudentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (assign, nonatomic) FormatTextField formatTextField;

@end
