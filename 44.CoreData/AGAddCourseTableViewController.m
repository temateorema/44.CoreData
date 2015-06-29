//
//  AGAddCourseTableViewController.m
//  44.CoreData
//
//  Created by MC723 on 29.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import "AGAddCourseTableViewController.h"
#import "AGDataManager.h"
#import "AGCourses.h"
#import "AGStudents.h"

@interface AGAddCourseTableViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>


@property (strong, nonatomic) UITextField* nameTextField;
@property (strong, nonatomic) UITextField* objectTextField;
@property (strong, nonatomic) UITextField* industryTextField;
@property (strong, nonatomic) NSArray* studentsOfCourse;

@property (strong, nonatomic) NSArray *coursesRowsCount;

@end

@implementation AGAddCourseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.nameTextField = [self createTextField:UIReturnKeyNext andWithKeyboardType:UIKeyboardTypeDefault];
    
    self.objectTextField = [self createTextField:UIReturnKeyNext andWithKeyboardType:UIKeyboardTypeDefault];
    self.industryTextField = [self createTextField:UIReturnKeyDone andWithKeyboardType:UIKeyboardTypeDefault];
    
    self.nameTextField.delegate = self;
    self.objectTextField.delegate = self;
    self.industryTextField.delegate = self;
    
    self.coursesRowsCount = [[NSArray alloc] initWithObjects:self.nameTextField, self.objectTextField, self.industryTextField, nil];
    
    self.studentsOfCourse = [[NSArray alloc] init];
    
    if (self.course != nil) {
        self.nameTextField.text = self.course.courseName;
        self.objectTextField.text = self.course.courseObject;
        self.industryTextField.text = self.course.courseIndustry;
        
    } else {
        self.course = [NSEntityDescription insertNewObjectForEntityForName:@"AGCourses"
                                                     inManagedObjectContext:[[AGDataManager sharedManager] managedObjectContext]];
    }
    self.studentsOfCourse = [[self.course students] allObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

    
#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.coursesRowsCount count];
        
    } else if (section == 2) {
        return [self.studentsOfCourse count] + 1;
        
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Course info";
        
    } else  {
        return @"Students of course";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* indentifier = @"Cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }

    UILabel* label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 6, 100, 30);
    label.font = [UIFont fontWithName:@"Avenir" size:17.f];
    label.textAlignment = NSTextAlignmentRight;
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        label.text = @"Name";
        
        [cell addSubview:label];
        [cell addSubview:self.nameTextField];
        
    } else if (indexPath.section == 0 && indexPath.row == 1 ) {
        label.text = @"Object";
        
        [cell addSubview:label];
        [cell addSubview:self.objectTextField];
        
    } else if (indexPath.section == 0 && indexPath.row == 2 ) {
        label.text = @"Industry";
        
        [cell addSubview:label];
        [cell addSubview:self.industryTextField];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = @"Add student";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    } else if (indexPath.section == 1) {
        AGStudents *student = [self.studentsOfCourse objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
        
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        return NO;
        
    } else {
        return YES;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 1) {
            AGStudents *student = [self.studentsOfCourse objectAtIndex:indexPath.row - 1];
            NSMutableArray* tempArray = [NSMutableArray arrayWithArray:self.studentsOfCourse];
            [tempArray removeObject:student];
            [self.course setStudents:[NSSet setWithArray:tempArray]];
            self.studentsOfCourse = tempArray;
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


#pragma mark - Actions

- (IBAction)actionCancelBarButton:(UIBarButtonItem *)sender {
    [[[AGDataManager sharedManager] managedObjectContext] rollback];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionSaveBarButton:(UIBarButtonItem *)sender {
    self.course.courseName = self.nameTextField.text;
    self.course.courseObject = self.objectTextField.text;
    self.course.courseIndustry = self.industryTextField.text;
    
    NSError* error = nil;
    
    if (![[[AGDataManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
        
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [self.objectTextField becomeFirstResponder];
        
    } else if (textField == self.objectTextField)  {
        [self.industryTextField becomeFirstResponder];
        
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Methods

- (UITextField*) createTextField:(UIReturnKeyType)ReturnKeyType andWithKeyboardType:(UIKeyboardType)keyboardType {
    UITextField* textField = [[UITextField alloc]init];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.returnKeyType = ReturnKeyType;
    textField.keyboardType = keyboardType;
    textField.frame = CGRectMake(130, 7, 220, 30);
    
    return textField;
}

- (void) dealloc {
    NSLog(@"AGAddCourseTableViewController deallocated");
    
}
@end
