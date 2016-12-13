//
//  GetNewWordsResponse.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 25.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "BaseResponse.h"

@interface WordObject : NSObject

@property (nonatomic, strong) NSString *englishWord;
@property (nonatomic, strong) NSString *transcription;
@property (nonatomic, strong) NSString *russianWord;
@property (nonatomic, strong) NSString *wordID;

@end

@interface GetNewWordsResponse : BaseResponse

@property (nonatomic, strong) NSArray *words;

@end
