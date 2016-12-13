//
//  SetWordsAsKnownDTO.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 01.11.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "SetWordsAsKnownDTO.h"
#import "GetNewWordsResponse.h"

@implementation SetWordsAsKnownDTO

-(NSString *)httpMethodName {
    switch (self.requestType) {
        case SetWordsTypeStudiedWords:
            return @"setWordsAsKnown";
        case SetWordsTypeRepeatedWords:
            return @"forgetWords";
            
        default: return nil;
    }
}

-(NSDictionary *)requestBody {
    NSMutableString *idList = [NSMutableString new];
    
    for (WordObject *word in self.words) {
        [idList appendString:[NSString stringWithFormat:@"%@,", word.wordID]];
    }
    [idList deleteCharactersInRange:NSMakeRange(idList.length - 1, 1)];
    
    return @{
             @"userID" : is_Object_Null(self.userID),
             @"listOfWordsID" : is_Object_Null(idList)
             };
}

@end
