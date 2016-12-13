//
//  GetNewWordsDTO.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 25.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "BaseDTO.h"

typedef NS_ENUM(NSInteger, GetNewWordsType) {
    GetNewWordsTypeStudyWords,
    GetNewWordsTypeRepeatWords
};

@interface GetNewWordsDTO : BaseDTO

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) NSInteger wordsCount;
@property (nonatomic, assign) GetNewWordsType reqeustType;

@end
