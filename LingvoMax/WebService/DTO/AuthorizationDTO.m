//
//  AuthorizationDTO.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 18.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "AuthorizationDTO.h"

@implementation AuthorizationDTO

-(NSString *)httpMethodName {
    return @"authorization";
}

-(NSDictionary *)requestBody {
    return  @{
              @"username" : is_Object_Null(self.username),
              @"password" : is_Object_Null(self.password)
              };
}

@end
