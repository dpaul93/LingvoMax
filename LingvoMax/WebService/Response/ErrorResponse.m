//
//  ErrorResponse.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "ErrorResponse.h"

@interface ErrorResponse()

@property (nonatomic, strong, readwrite) NSString *errorMessage;
@property (nonatomic, assign, readwrite) NSInteger errorCode;

@end

@implementation ErrorResponse

-(instancetype)initWithDomain:(NSString *)domain code:(NSInteger)code userInfo:(NSDictionary *)dict {
    if(self = [super initWithDomain:domain code:code userInfo:dict]) {
        NSString *errorCodeString = dict[@"error"];
        self.errorCode = [[[errorCodeString componentsSeparatedByString:@":"] lastObject] integerValue];
        self.errorMessage = [self stringFromErrorCode:self.errorCode];
    }
    
    return self;
}

-(NSString*)stringFromErrorCode:(NSInteger)errorCode {
    switch (errorCode) {
        case 0:
            return @"Ошибка сервера.";
        case 1:
            return @"Такое имя пользователя уже существует, либо слишком короткое.";
        case 2:
            return @"Пароль слишком короткий.";
        case 3:
            return @"Такое имя пользователя не существует, либо неправильный пароль.";
        case 4:
            return @"Неверно введенные данные.";
        case 5:
            return @"Слова отсутствуют в базе.";
        case 6:
            return @"ID пользователя не существует.";
        case 7:
            return @"Такое имя пользователя не существует, либо неправильный пароль.";
        case 8:
            return @"Неправильный мастер-пароль.";
        case 9:
            return @"Нет слов которые можно повторить или пользователь еще не выучил ни одного слова.";
        case 10:
            return @"ID слова не существует.";
        case 11:
            return @"Неверные параметры в запросе.";
        case 12:
            return @"Записей прогресса для графика связанных с пользователем не найдено.";
  
        default:
            return @"Произошла неизвестная ошибка.";
    }
}

@end
