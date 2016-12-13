//
//  AuthorizationDTO.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 18.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "BaseDTO.h"

@interface AuthorizationDTO : BaseDTO

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end
