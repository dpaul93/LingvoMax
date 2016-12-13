//
//  ErrorResponse.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorResponse : NSError

@property (nonatomic, strong, readonly) NSString *errorMessage;
@property (nonatomic, assign, readonly) NSInteger errorCode;

@end
