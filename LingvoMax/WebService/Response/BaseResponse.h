//
//  BaseResponse.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseResponse : NSObject

@property (nonatomic, assign, readonly) BOOL success;

-(instancetype)initWithResponseString:(NSString*)response;

@end
