//
//  BaseDTO.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "BaseDTO.h"

@implementation BaseDTO

// To be subclassed

-(NSString *)httpMethodName {
    return nil;
}

-(NSDictionary *)requestBody {
    return nil;
}

id is_Object_Null(id object) {
    return object ?: [NSNull null];
}

@end
