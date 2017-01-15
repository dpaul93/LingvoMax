//
//  PDLineChart.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 15.11.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "PDLineChart.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(angle) ((angle) * 180.0 / M_PI)


@implementation PDLineChartDataObject
@end

@interface PDLineChart()

@property (nonatomic, strong) NSMutableArray *xValueData;
@property (nonatomic, strong) NSMutableArray *yValueData;
@property (nonatomic, strong) NSMutableArray *chartPoints;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation PDLineChart

-(instancetype)init {
    if(self = [super init]) {
        [self resetData];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self resetData];
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        self.clipsToBounds = NO;
        [self resetData];
    }
    
    return self;
}

#pragma mark - Setters

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    if(self.chartData) {
        //re-calculate graph
    }
}

-(void)setChartData:(PDLineChartDataObject *)chartData {
//    chartData.values = @[@"5", @"0", @"30", @"40", @"0"];
    if(!chartData.values || chartData.values.count == 0) {
        if(self.noDataDescription) {
            [self addNoDataLabel];
        }
        return;
    }
    
    _chartData = chartData;
    
    CGFloat divider = chartData.values.count - 1 ?: 2;
    CGFloat xGap = (self.frame.size.width - self.pointSize) / divider;

    CGFloat min, max;
    CGFloat initialValue = [chartData.values.firstObject floatValue];
    min = max = initialValue;
    for (NSString *value in chartData.values) {
        CGFloat number = [value floatValue];
        min = MIN(number, min);
        max = MAX(number, max);
    }
    
    for (int i = 0; i < chartData.values.count; i++) {
        NSString *value = chartData.values[i];
        UIView *point = [self chartPointObjectWithValue:value];
        
        CGFloat number = [value floatValue];
        CGFloat yPosition = (number / max) * (self.bounds.size.height - self.pointSize);
        yPosition = self.bounds.size.height - yPosition;
        
        NSInteger step = i;
        if(chartData.values.count <= 1) {
            step++;
        }
        CGRect frame = CGRectMake(xGap * step, CGRectGetHeight(self.bounds), CGRectGetWidth(point.bounds), CGRectGetHeight(point.bounds));
        if(!self.animatable) {
            frame.origin.y = yPosition - self.pointSize;
            point.frame = frame;
        } else {
            point.frame = frame;
            frame.origin.y = yPosition - self.pointSize;
            [UIView animateWithDuration:self.animationDuration delay:(i * 0.1) options:UIViewAnimationOptionCurveEaseOut animations:^{
                point.frame = frame;
            } completion:nil];
        }
        
        [self.chartPoints addObject:point];
        
        [self addSubview:point];
        
        [self addXValueLabel:chartData.xValues[i] X:xGap * step];
    }
    
    for (int i = -1; i != chartData.values.count; i++) {
        if(i + 1 == chartData.values.count) {
            continue;
        }
        UIView *first;
        if (i < 0) {
            first = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds), self.pointSize, self.pointSize)];
            [self addSubview:first];
        } else {
            first = self.chartPoints[i];
        }
        UIView *second = self.chartPoints[i + 1];
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:first.center];
        [path addLineToPoint:second.center];

        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = [path CGPath];
        shapeLayer.strokeColor = [self.lineColor CGColor];
        shapeLayer.lineWidth = 1.5;
        shapeLayer.fillColor = [[UIColor clearColor] CGColor];
        shapeLayer.zPosition = -1;
        shapeLayer.lineJoin = kCALineJoinBevel;
        
        [self.lines addObject:shapeLayer];
        
        if(!self.animatable) {
            [self.layer addSublayer:shapeLayer];
        } else {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((self.animationDuration + (i * 0.1)) * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.layer addSublayer:shapeLayer];
                
                CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//              pathAnimation.beginTime = CACurrentMediaTime() + 0.5f;
                pathAnimation.duration = 0.5f;
                pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
                pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
                [shapeLayer addAnimation:pathAnimation forKey:@"strokeEnd"];
            });
        }
    }
}

#pragma mark - Helpers

-(void)addNoDataLabel {
    UILabel *noData = [[UILabel alloc] init];
    noData.text = self.noDataDescription;
    noData.textColor = [UIColor whiteColor];
    [noData sizeToFit];
    CGRect frame = noData.frame;
    frame.origin = CGPointMake(CGRectGetMidX(self.bounds) - CGRectGetMidX(frame), CGRectGetMidY(self.bounds) - CGRectGetMidY(frame));
    noData.frame = frame;
    [self addSubview:noData];
    self.noDataLabel = noData;
}

-(void)resetData {
    self.animatable = NO;
    self.animationDuration = 0.5f;
    self.pointSize = 18;
    self.pointColor = [UIColor whiteColor];
    self.lineColor = [UIColor whiteColor];
    self.yValueLabelDegree = 45;
    self.yValueTextColor = [UIColor blackColor];
    
    [self.xValueData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UIView*)obj removeFromSuperview];
    }];
    
    [self.yValueData enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UIView*)obj removeFromSuperview];
    }];
    
    [self.chartPoints enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(UIView*)obj removeFromSuperview];
    }];
    
    [self.lines enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [(CALayer*)obj removeFromSuperlayer];
    }];
    
    self.xValueData = [NSMutableArray new];
    self.yValueData = [NSMutableArray new];
    self.chartPoints = [NSMutableArray new];
    self.lines = [NSMutableArray new];
}

-(UIView*)chartPointObjectWithValue:(NSString*)value {
    CGRect frame = CGRectZero;
    frame.size = CGSizeMake(self.pointSize, self.pointSize);
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:frame];

    valueLabel.font = [UIFont systemFontOfSize:9];
    valueLabel.text = value;
    valueLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *chartPointView = [[UIView alloc] initWithFrame:frame];
    chartPointView.layer.cornerRadius = CGRectGetHeight(chartPointView.bounds) / 2.0f;
    chartPointView.backgroundColor = self.pointColor;
    [chartPointView addSubview:valueLabel];
    chartPointView.center = CGPointMake(CGRectGetMidX(chartPointView.bounds), CGRectGetMidY(chartPointView.bounds));

    return chartPointView;
}

-(void)addXValueLabel:(NSString*)value X:(CGFloat)x {
    UILabel *valueLabel = [[UILabel alloc] init];
    valueLabel.text = value;
    valueLabel.font = [UIFont systemFontOfSize:10];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    [valueLabel sizeToFit];
    CGRect frame = CGRectMake(x, self.bounds.size.height + CGRectGetWidth(valueLabel.bounds) / 2, CGRectGetWidth(valueLabel.bounds), CGRectGetHeight(valueLabel.bounds));
    valueLabel.frame = frame;
    valueLabel.textColor = self.yValueTextColor;

    valueLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, DEGREES_TO_RADIANS(self.yValueLabelDegree));
    [self addSubview:valueLabel];
    
    [self.xValueData addObject:valueLabel];
}

@end
