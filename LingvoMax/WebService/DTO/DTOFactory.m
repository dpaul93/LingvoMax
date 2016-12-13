//
//  DTOFactory.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "DTOFactory.h"

@implementation DTOFactory

+(BaseDTO *)dtoWithRequestType:(WebServiceRequestType)type {
    switch (type) {
        case WebServiceRequestRegistration:
            return [RegistrationDTO new];
        case WebServiceRequestAuthorization:
            return [AuthorizationDTO new];
        case WebServiceRequestGetNewWords:
        case WebServiceRequestGetWordsToRepeat:
            return [GetNewWordsDTO new];
        case WebServiceRequestSetWordsAsKnown:
        case WebServiceRequestForgetWords:
            return [SetWordsAsKnownDTO new];
            
        default: return [BaseDTO new];
    }
}

@end
