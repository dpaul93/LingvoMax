//
//  AuthorizationResponse.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "AuthorizationResponse.h"

@interface AuthorizationResponse()

@property (nonatomic, strong, readwrite) NSString *userID;

@end

@implementation AuthorizationResponse

-(instancetype)initWithResponseString:(NSString *)response {
    if(self = [super initWithResponseString:response]) {
        self.userID = response;
    }
    
    return self;
}

@end
