//
//  AGStudents.h
//  44.CoreData
//
//  Created by MC723 on 30.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AGCourses;

@interface AGStudents : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *courses;
@end

@interface AGStudents (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(AGCourses *)value;
- (void)removeCoursesObject:(AGCourses *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
