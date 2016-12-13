//
//  PerDayChartResponse.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 27.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "PerDayChartResponse.h"

@implementation PerDayChartGraphObject
@end

@implementation PerDayChartResponse

-(instancetype)initWithResponseString:(NSString *)response {
    if(self = [super initWithResponseString:response]) {
        NSMutableArray *temp = [NSMutableArray new];
        
        NSArray *divided = [response componentsSeparatedByString:@","];
        for (NSString *pair in divided) {
            PerDayChartGraphObject *object = [PerDayChartGraphObject new];
            NSArray *pairValues = [pair componentsSeparatedByString:@":"];
            object.date = [[pairValues firstObject] stringByReplacingOccurrencesOfString:@"!" withString:@""];;
            object.value = [[pairValues lastObject] stringByReplacingOccurrencesOfString:@"!" withString:@""];
            [temp addObject:object];
        }
        
        self.chartData = temp;
    }
    
    return self;
}

@end
