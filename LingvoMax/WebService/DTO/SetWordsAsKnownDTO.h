//
//  SetWordsAsKnownDTO.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 01.11.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "BaseDTO.h"

typedef NS_ENUM(NSInteger, SetWordsType) {
    SetWordsTypeStudiedWords,
    SetWordsTypeRepeatedWords
};

@interface SetWordsAsKnownDTO : BaseDTO

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSArray *words;
@property (nonatomic, assign) SetWordsType requestType;

@end
