//
//  PerDayChartResponse.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 27.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "BaseResponse.h"

@interface PerDayChartGraphObject : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *value;

@end

@interface PerDayChartResponse : BaseResponse

@property (nonatomic, strong) NSArray *chartData;

@end
