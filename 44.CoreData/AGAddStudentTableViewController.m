//
//  AGAddStudentTableViewController.m
//  44.CoreData
//
//  Created by MC723 on 28.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import "AGAddStudentTableViewController.h"
#import "AGChooseCourseViewController.h"
#import "AGDataManager.h"
#import "AGStudents.h"
#import "AGCourses.h"

@interface AGAddStudentTableViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AGChooseCourseViewControllerDelegate>

@property (strong, nonatomic) UITextField *firstNameTextField;
@property (strong, nonatomic) UITextField *lastNameTextField;
@property (strong, nonatomic) UITextField *emailTextField;

@property (strong, nonatomic) NSArray *studentsRowsCount;

@end

@implementation AGAddStudentTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.firstNameTextField = [self createTextField:UIReturnKeyNext andWithKeyboardType:UIKeyboardTypeDefault];
    self.lastNameTextField = [self createTextField:UIReturnKeyNext andWithKeyboardType:UIKeyboardTypeDefault];
    self.emailTextField = [self createTextField:UIReturnKeyDone andWithKeyboardType:UIKeyboardTypeEmailAddress];
    self.firstNameTextField.delegate = self;
    self.lastNameTextField.delegate = self;
    self.emailTextField.delegate = self;
    
    self.studentsRowsCount = [[NSArray alloc] initWithObjects:self.firstNameTextField, self.lastNameTextField, self.emailTextField, nil];
    
    if (self.student != nil) {
        self.firstNameTextField.text = self.student.firstName;
        self.lastNameTextField.text = self.student.lastName;
        self.emailTextField.text = self.student.email;
        
    } else {
        self.student = [NSEntityDescription insertNewObjectForEntityForName:@"AGStudents"
                                                     inManagedObjectContext:[[AGDataManager sharedManager] managedObjectContext]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
        if (section == 0) {
            return @"User info";
    
        } else  {
            return @"User courses";
        }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.studentsRowsCount count];;
    } else {
        return [[self.student courses] count] + 1;
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
    label.textAlignment = NSTextAlignmentRight;
    
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        label.text = @"First name";
        
        [cell addSubview:label];
        [cell addSubview:self.firstNameTextField];
        
    } else if (indexPath.section == 0 && indexPath.row == 1 ) {
        label.text = @"Last name";
        
        [cell addSubview:label];
        [cell addSubview:self.lastNameTextField];
        
    } else if (indexPath.section == 0 && indexPath.row == 2 ) {
        label.text = @"Email";
        
        [cell addSubview:label];
        [cell addSubview:self.emailTextField];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"Add course";
        
    } else if (indexPath.section == 1) {
        NSArray* tempArray = [[self.student courses] allObjects];
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [[tempArray objectAtIndex:indexPath.row - 1] name]];
    }
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return NO;
            
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        return NO;
            
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 1 && indexPath.row != 0) {
            
            NSArray *tempArray = [self.student.courses allObjects];
            NSMutableArray *tempMutableArray = [NSMutableArray arrayWithArray:tempArray];
            [tempMutableArray removeObject:[tempArray objectAtIndex:indexPath.row - 1]];
            
            [self.student setCourses:[NSSet setWithArray:tempMutableArray]];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        AGChooseCourseViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AGChooseCourseViewController"];
        
        vc.delegate = self;
        vc.data = self.student;
        vc.typeEntity = AGCoursesType;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Actions

- (IBAction)actionCancelBarButton:(UIBarButtonItem *)sender {
    [[[AGDataManager sharedManager] managedObjectContext] rollback];
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)actionSaveBarButton:(UIBarButtonItem *)sender {
    self.student.firstName = self.firstNameTextField.text;
    self.student.lastName = self.lastNameTextField.text;
    self.student.email = self.emailTextField.text;
    
    NSError* error = nil;
    
    if (![[[AGDataManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
        
    } else {
        [self.navigationController popViewControllerAnimated:YES];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstNameTextField) {
        [self.lastNameTextField becomeFirstResponder];
        
    } else if (textField == self.lastNameTextField)  {
        [self.emailTextField becomeFirstResponder];
        
    } else {
        [textField resignFirstResponder];
        
    }
    return YES;
}


#pragma mark - AGChooseCourseTableViewControllerDelegate

- (void) chooseDataArray:(NSMutableArray*)datatArray andType:(AGDataType)entityType {
    
    if (entityType == AGCoursesType) {
        [self.student setCourses:[NSSet setWithArray:datatArray]];
    }
    [self.tableView reloadData];
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
    NSLog(@"AGAddStudentTableTableViewController deallocated");
    
}

@end
