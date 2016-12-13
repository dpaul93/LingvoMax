//
//  AuthorizationResponse.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "BaseResponse.h"

@interface AuthorizationResponse : BaseResponse

@property (nonatomic, strong, readonly) NSString *userID;

@end
