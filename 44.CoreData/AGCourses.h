//
//  AGCourses.h
//  44.CoreData
//
//  Created by MC723 on 30.06.15.
//  Copyright (c) 2015 temateorema. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AGStudents;

@interface AGCourses : NSManagedObject

@property (nonatomic, retain) NSString * courseIndustry;
@property (nonatomic, retain) NSString * courseName;
@property (nonatomic, retain) NSString * courseObject;
@property (nonatomic, retain) NSSet *students;
@end

@interface AGCourses (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(AGStudents *)value;
- (void)removeStudentsObject:(AGStudents *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
