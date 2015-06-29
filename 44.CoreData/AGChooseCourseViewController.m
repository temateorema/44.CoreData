//
//  AGChooseCourseViewController.m
//  44.CoreData
//
//  Created by MC723 on 29.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import "AGChooseCourseViewController.h"
#import "AGStudents.h"
#import "AGCourses.h"

@interface AGChooseCourseViewController ()

@end

@implementation AGChooseCourseViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    [self.tableView setEditing:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Methods

- (NSString*) entityName:(AGDataType)dataType {
    if (self.typeEntity == AGStudentsType) {
        return @"AGStudents";
        
    } else if (self.typeEntity == AGCoursesType) {
        return @"AGCourses";
    }
    return nil;
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* description = [NSEntityDescription entityForName:[self entityName:self.typeEntity]
                                                   inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:description];
    
    if (self.typeEntity != AGCoursesType) {
        NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
        NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
        [fetchRequest setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
        
    } else {
        NSSortDescriptor* courseName = [[NSSortDescriptor alloc] initWithKey:@"courseName" ascending:YES];
        [fetchRequest setSortDescriptors:@[courseName]];
    }
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                managedObjectContext:self.managedObjectContext
                                                                                                  sectionNameKeyPath:nil
                                                                                                           cacheName:nil];
    
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}


#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (self.typeEntity == AGStudentsType) {
        
        AGStudents *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        
        AGCourses* course = self.data;
        if ([[course students] containsObject:student]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
        
    } else if (self.typeEntity == AGCoursesType) {
        
        AGCourses* course = [self.fetchedResultsController objectAtIndexPath:indexPath];
        cell.textLabel.text = course.courseName;
        AGStudents* student = self.data;
        
        if ([[student courses] containsObject:course]) {
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }
    }
}


#pragma mark - Actions

- (IBAction)cancelBarButton:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)saveBarButton:(UIBarButtonItem *)sender {
    NSArray* selectedRowsArray = [self.tableView indexPathsForSelectedRows];
    NSMutableArray* selectedItems = [NSMutableArray new];
    
    for (NSIndexPath* numberSelectionRow in selectedRowsArray) {
        [selectedItems addObject:[self.fetchedResultsController objectAtIndexPath:numberSelectionRow]];
        
    }
    [self.delegate chooseDataArray:selectedItems andType:self.typeEntity];
    [self.navigationController popViewControllerAnimated:YES];
}


@end
