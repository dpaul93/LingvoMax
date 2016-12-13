//
//  WebService.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "WebService.h"
#import "DTO/DTOFactory.h"
#import "Response/ResponseFactory.h"
#import "ErrorResponse.h"
#import <Parse.h>

static NSString * const kUserIDKey = @"UserIDKey";
static NSString * const kUserNicknameKey = @"UserNicknameKey";

@interface WebService()

@property (nonatomic, strong, readwrite) NSString *userID;

@end

@implementation WebService

#pragma mark - Request Methods

-(void)requestWithType:(WebServiceRequestType)type dto:(BaseDTO *(^)(id))dto completion:(void (^)(id, ErrorResponse *))completion {
    BaseDTO *baseDTO = [DTOFactory dtoWithRequestType:type];
    
    baseDTO = dto(baseDTO);
    
    [self callFunctionWithType:type method:baseDTO.httpMethodName params:baseDTO.requestBody completion:completion];
}

-(void)requestWithUserIDType:(WebServiceRequestType)type completion:(void (^)(id, ErrorResponse *))completion {
    if(!self.userID)
        return;
    
    NSDictionary *params = @{ @"userID" : self.userID };
    
    NSString *url = [self urlForUserIDRequest:type];
    if(!url)
        return;
    
    [self callFunctionWithType:type method:url params:params completion:completion];
}

-(void)callFunctionWithType:(WebServiceRequestType)type method:(NSString*)method params:(NSDictionary*)params completion:(void (^)(id, ErrorResponse *))completion {
    [PFCloud callFunctionInBackground:method withParameters:params block:^(id _Nullable object, NSError * _Nullable error) {
        ErrorResponse *errorResponse = nil;
        BaseResponse *response = nil;
        if(error) {
            errorResponse = [[ErrorResponse alloc] initWithDomain:error.domain code:error.code userInfo:error.userInfo];
        } else {
            response = [ResponseFactory responseWithRequestType:type response:object];
        }
        
        completion(response, errorResponse);
    }];
}

#pragma mark - Instance UserID Getter

-(NSString *)userID {
    if(!_userID) {
        _userID = [[self class] userID];
    }
    
    return _userID;
}

#pragma mark - Class Methods

-(NSString*)urlForUserIDRequest:(WebServiceRequestType)type {
    switch (type) {
        case WebServiceRequestGetUsername: return @"getusername";
        case WebServiceRequestGetKnownWordsCount: return @"getKnownWordsCount";
        case WebServiceRequestGetPerDayChart: return @"getPerDayChart";
        case WebServiceRequestGetAccumulativeChart: return @"getAccumulativeChart";
            
        default: return nil;
    }
}

#pragma mark - Class UserID Getters / Setters

+(NSString *)userID {
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:kUserIDKey];
    return userID;
}

+(void)setUserID:(NSString *)userID {
    if(userID && userID.length) {
        [[NSUserDefaults standardUserDefaults] setValue:userID forKey:kUserIDKey];
    }
}

+(void)clearUserID {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kUserIDKey];
}

+(NSString *)nickname {
    NSString *nickname = [[NSUserDefaults standardUserDefaults] valueForKey:kUserNicknameKey];
    return nickname;
}

+(void)setNickname:(NSString *)nickname {
    if(nickname && nickname.length) {
        [[NSUserDefaults standardUserDefaults] setValue:nickname forKey:kUserNicknameKey];
    }
}

+(void)clearNickname {
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kUserNicknameKey];
}

@end
