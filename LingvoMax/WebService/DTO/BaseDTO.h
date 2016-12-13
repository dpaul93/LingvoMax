//
//  BaseDTO.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDTO : NSObject

-(NSString*)httpMethodName;
-(NSDictionary*)requestBody;

id is_Object_Null(id object);

@end
