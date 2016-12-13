//
//  BaseResponse.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "BaseResponse.h"

@interface BaseResponse()

@property (nonatomic, assign, readwrite) BOOL success;

@end

@implementation BaseResponse

-(instancetype)initWithResponseString:(NSString *)response {
    if(self = [super init]) {
        if(response && response.length) {
            self.success = YES;
        }
    }
    
    return self;
}

@end
