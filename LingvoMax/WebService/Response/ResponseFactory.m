//
//  ResponseFactory.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "ResponseFactory.h"

@implementation ResponseFactory

+(BaseResponse *)responseWithRequestType:(WebServiceRequestType)type response:(NSString *)response{
    switch (type) {
        case WebServiceRequestRegistration:
        case WebServiceRequestSetWordsAsKnown:
        case WebServiceRequestForgetWords:
            return [[SuccessResponse alloc] initWithResponseString:response];
        case WebServiceRequestAuthorization:
        case WebServiceRequestGetUsername:
            return [[AuthorizationResponse alloc] initWithResponseString:response];
        case WebServiceRequestGetNewWords:
        case WebServiceRequestGetWordsToRepeat:
            return [[GetNewWordsResponse alloc] initWithResponseString:response];
        case WebServiceRequestGetPerDayChart:
        case WebServiceRequestGetAccumulativeChart:
            return [[PerDayChartResponse alloc] initWithResponseString:response];
            
        default: return [BaseResponse new];
    }
}

@end
