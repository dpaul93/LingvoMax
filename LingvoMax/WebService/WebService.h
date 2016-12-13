//
//  WebService.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseDTO, ErrorResponse;

typedef NS_ENUM(NSInteger, WebServiceRequestType) {
    WebServiceRequestRegistration,
    WebServiceRequestAuthorization,
    WebServiceRequestGetNewWords,
    WebServiceRequestGetWordsToRepeat,
    WebServiceRequestSetWordsAsKnown,
    WebServiceRequestForgetWords,
    WebServiceRequestGetUsername,
    WebServiceRequestGetPerDayChart,
    WebServiceRequestGetAccumulativeChart,
    WebServiceRequestGetKnownWordsCount
};

@interface WebService : NSObject

-(void)requestWithType:(WebServiceRequestType)type dto:(BaseDTO* (^)(id dtoObject))dto completion:(void (^)(id response, ErrorResponse* error))completion;
-(void)requestWithUserIDType:(WebServiceRequestType)type completion:(void (^)(id response, ErrorResponse* error))completion;

+(NSString *)userID;
+(void)setUserID:(NSString*)userID;
+(void)clearUserID;

+(NSString *)nickname;
+(void)setNickname:(NSString*)nickname;
+(void)clearNickname;

@end
