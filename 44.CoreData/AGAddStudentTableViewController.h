//
//  AGAddStudentTableViewController.h
//  44.CoreData
//
//  Created by MC723 on 28.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGStudents;
@protocol AGAddStudentTableViewControllerDelegate;

@interface AGAddStudentTableViewController : UITableViewController

@property (weak, nonatomic) id <AGAddStudentTableViewControllerDelegate> delegate;
@property (strong, nonatomic) AGStudents *student;

- (IBAction)actionCancelBarButton:(UIBarButtonItem *)sender;
- (IBAction)actionSaveBarButton:(UIBarButtonItem *)sender;
@end

@protocol AGAddStudentTableViewControllerDelegate <NSObject>
//- (void)didFinishEditingDate:(NSDate *)date;

@end
