//
//  ResponseFactory.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseResponse.h"
#import "ResponseHeaders.h"
#import "WebService.h"

@interface ResponseFactory : NSObject

+(BaseResponse*)responseWithRequestType:(WebServiceRequestType)type response:(NSString*)response;

@end
