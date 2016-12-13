//
//  GetNewWordsResponse.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 25.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "GetNewWordsResponse.h"

@implementation WordObject
@end

@implementation GetNewWordsResponse

-(instancetype)initWithResponseString:(NSString *)response {
    if(self = [super initWithResponseString:response]) {
        NSMutableArray *temp = [NSMutableArray new];
        
        NSArray *divided = [response componentsSeparatedByString:@";"];
        
        for (NSString *words in divided) {
            WordObject *wordObject = [self wordObjectFromString:words];
            [temp addObject:wordObject];
        }
        
        self.words = temp;
    }
    
    return self;
}

-(WordObject*)wordObjectFromString:(NSString*)string {
    WordObject *word = [WordObject new];
    
    NSMutableString *mutable = [string mutableCopy];

    NSString *english = [[mutable componentsSeparatedByString:@":"] firstObject];
    word.englishWord = [self clearWordFromSpecialCharacters:english];

    [mutable replaceCharactersInRange:[self rangeFromString:english] withString:@""];
    
    NSString *transcription = [[mutable componentsSeparatedByString:@"|"] firstObject];
    word.transcription = [self clearWordFromSpecialCharacters:transcription];
    
    [mutable replaceCharactersInRange:[self rangeFromString:transcription] withString:@""];
    
    NSString *russian = [[mutable componentsSeparatedByString:@"?"] firstObject];
    word.russianWord = [self clearWordFromSpecialCharacters:russian];
    
    [mutable replaceCharactersInRange:[self rangeFromString:russian] withString:@""];
    
    word.wordID = [self clearWordFromSpecialCharacters:mutable];
    
    return word;
}

-(NSString*)clearWordFromSpecialCharacters:(NSString*)word {
    return [word stringByReplacingOccurrencesOfString:@"!" withString:@""];
}

-(NSRange)rangeFromString:(NSString*)string {
    return NSMakeRange(0, string.length + 1);
}

@end
