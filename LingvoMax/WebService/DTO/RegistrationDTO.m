//
//  registrationDTO.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "RegistrationDTO.h"

@implementation RegistrationDTO

-(NSString *)httpMethodName {
    return @"registration";
}

-(NSDictionary *)requestBody {
    return  @{
              @"nametoshow" : is_Object_Null(self.nickname),
              @"username" : is_Object_Null(self.username),
              @"password" : is_Object_Null(self.password)
              };
}

@end
