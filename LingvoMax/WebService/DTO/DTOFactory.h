//
//  DTOFactory.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTOHeaders.h"
#import "WebService.h"

@interface DTOFactory : NSObject

+(BaseDTO*)dtoWithRequestType:(WebServiceRequestType)type;

@end
