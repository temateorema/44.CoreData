//
//  AGStudentsTableViewController.m
//  44.CoreData
//
//  Created by MC723 on 24.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import "AGStudentsTableViewController.h"
#import "AGStudents.h"
#import "AGAddStudentTableViewController.h"


@interface AGStudentsTableViewController () <AGAddStudentTableViewControllerDelegate>

@end

@implementation AGStudentsTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *description = [NSEntityDescription entityForName:@"AGStudents" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSSortDescriptor *firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    NSSortDescriptor *lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    
    [request setSortDescriptors:@[firstNameDescriptor, lastNameDescriptor]];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
                                                    initWithFetchRequest:request
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
    AGStudents *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [super configureCell:cell atIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AGAddStudentTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AGAddStudentTableViewController"];
    
    vc.delegate = self;
    
    AGStudents *student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.student = student;
    
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self setStyleOfNavigationBar:navigation];
//    
//    [self presentViewController:navigation animated:YES completion:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) setStyleOfNavigationBar:(UINavigationController *) controller {
    controller.navigationBar.barTintColor = [UIColor blackColor];
    controller.navigationBar.tintColor = [UIColor whiteColor];
    controller.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}


#pragma mark - Action

- (IBAction)actionAddStudentButton:(UIBarButtonItem *)sender {
    AGAddStudentTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AGAddStudentTableViewController"];
    
//    vc.delegate = self;
//    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self setStyleOfNavigationBar:navigation];
//    
//    [self presentViewController:navigation animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
