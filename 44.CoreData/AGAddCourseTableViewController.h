//
//  AGAddCourseTableViewController.h
//  44.CoreData
//
//  Created by MC723 on 29.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AGCourses;
@protocol AGAddCourseTableViewControllerDelegate;

@interface AGAddCourseTableViewController : UITableViewController

@property (weak, nonatomic) id <AGAddCourseTableViewControllerDelegate> delegate;
@property (strong, nonatomic) AGCourses *course;


- (IBAction)actionCancelBarButton:(UIBarButtonItem *)sender;
- (IBAction)actionSaveBarButton:(UIBarButtonItem *)sender;

@end

@protocol AGAddStudentTableViewControllerDelegate <NSObject>

@end
