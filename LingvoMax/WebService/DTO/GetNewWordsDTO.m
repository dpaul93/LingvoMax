//
//  GetNewWordsDTO.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 25.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "GetNewWordsDTO.h"

@implementation GetNewWordsDTO

-(NSString *)httpMethodName {
    switch (self.reqeustType) {
        case GetNewWordsTypeStudyWords:
            return @"getNewWords";
        case GetNewWordsTypeRepeatWords:
            return @"getWordsToRepeat";
            
        default: return nil;
    }
}

-(NSDictionary *)requestBody {
    return @{
             @"userID" : is_Object_Null(self.userID),
             @"count" : @(self.wordsCount)
            };
}

@end
