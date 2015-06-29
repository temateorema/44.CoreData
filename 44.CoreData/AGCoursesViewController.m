//
//  AGCoursesViewController.m
//  44.CoreData
//
//  Created by MC723 on 29.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import "AGCoursesViewController.h"
#import "AGCourses.h"
#import "AGAddCourseTableViewController.h"

@interface AGCoursesViewController ()

@end

@implementation AGCoursesViewController
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
    NSEntityDescription *description = [NSEntityDescription entityForName:@"AGCourses" inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSSortDescriptor *courseName = [[NSSortDescriptor alloc] initWithKey:@"courseName" ascending:YES];
    
    [request setSortDescriptors:@[courseName]];
    
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
    AGCourses *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [super configureCell:cell atIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", course.courseName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AGAddCourseTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AGAddCourseTableViewController"];
    
    vc.delegate = self;
    
    AGCourses *course = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.course = course;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];
    [self setStyleOfNavigationBar:navigation];
    
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void) setStyleOfNavigationBar:(UINavigationController *) controller {
    controller.navigationBar.barTintColor = [UIColor blackColor];
    controller.navigationBar.tintColor = [UIColor whiteColor];
    controller.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
}


#pragma mark - Action

- (IBAction)actionAddCourse:(UIBarButtonItem *)sender {
    AGAddCourseTableViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AGAddCourseTableViewController"];
    
    vc.delegate = self;
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:vc];
    [self setStyleOfNavigationBar:navigation];
    
    [self presentViewController:navigation animated:YES completion:nil];
}

@end
