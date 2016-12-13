//
//  PDLineChart.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 15.11.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLineChartDataObject : NSObject

@property (nonatomic, strong) NSArray *xValues;
@property (nonatomic, strong) NSArray *yValues;
@property (nonatomic, strong) NSArray *values;

@end

@interface PDLineChart : UIView

@property (nonatomic, strong) PDLineChartDataObject *chartData;

@property (nonatomic, strong) UIColor *pointColor;
@property (nonatomic, assign) NSInteger pointSize;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, assign) CGFloat yValueLabelDegree;
@property (nonatomic, strong) UIColor *yValueTextColor;

@property (nonatomic, assign) BOOL animatable;
@property (nonatomic, assign) CGFloat animationDuration;

@property (nonatomic, strong) NSString *noDataDescription;

-(void)resetData;

@end
