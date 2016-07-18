//
//  PIModuleLoader.h
//  PainlessInjection
//
//  Created by Yaroslav Zhurakovskiy on 7/11/16.
//  Copyright © 2016 Yaroslav Zhurakovskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIModuleLoader : NSObject

+ (nonnull NSArray *)listWithType:(nonnull Class)cls;

@end
