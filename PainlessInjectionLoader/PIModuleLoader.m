//
//  PIModuleLoader.m
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

#include <objc/objc.h>
#include <objc/runtime.h>

#import "PIModuleLoader.h"

@implementation PIModuleLoader

+ ( NSArray *)listWithType:(Class)inCls
{
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    int numberOfClasses = objc_getClassList(NULL, 0);
    if (numberOfClasses > 0) {
        Class *classes = (__unsafe_unretained Class *)malloc(numberOfClasses * sizeof(Class));
        objc_getClassList(classes, numberOfClasses);
        for (int index = 0; index < numberOfClasses; ++index) {
            Class cls = classes[index];
            if (class_getSuperclass(cls) == inCls) {
                id module = [[cls alloc] init];
                [temp addObject:module];
            }
        }
        
        free(classes);
    }
    
    return [temp copy];
}


@end
