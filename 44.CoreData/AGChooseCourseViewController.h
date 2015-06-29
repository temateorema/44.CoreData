//
//  AGChooseCourseViewController.h
//  44.CoreData
//
//  Created by MC723 on 29.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import "AGTableViewController.h"

typedef enum {
    AGStudentsType,
    AGCoursesType
} AGDataType;

@protocol AGChooseCourseViewControllerDelegate;
@interface AGChooseCourseViewController : AGTableViewController

@property (weak, nonatomic) id <AGChooseCourseViewControllerDelegate> delegate;
@property (strong, nonatomic) id data;
@property (assign, nonatomic) AGDataType typeEntity;

- (IBAction)cancelBarButton:(UIBarButtonItem *)sender;
- (IBAction)saveBarButton:(UIBarButtonItem *)sender;

@end


@protocol AGChooseCourseViewControllerDelegate
- (void) chooseDataArray:(NSMutableArray*)datatArray andType:(AGDataType)entityType;

@end

