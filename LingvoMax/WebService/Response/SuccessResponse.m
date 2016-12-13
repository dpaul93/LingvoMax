//
//  SuccessResponse.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "SuccessResponse.h"

@interface SuccessResponse()

@property (nonatomic, assign, readwrite) BOOL success;

@end

@implementation SuccessResponse

@synthesize success;

-(instancetype)initWithResponseString:(NSString *)response {
    if(self = [super initWithResponseString:response]) {
        if([response isEqualToString:@"Success"])
            self.success = YES;
    }
    
    return self;
}

@end
