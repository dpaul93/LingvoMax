//
//  StatisticsViewController.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 25.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "StatisticsViewController.h"
#import "UINavigationController+TranslucentNavigationBar.h"
#import "WebService.h"
#import "GetNewWordsResponse.h"
#import "GetNewWordsDTO.h"
#import "PDLineChart.h"
#import "PerDayChartResponse.h"
#import "WebService.h"

@interface StatisticsViewController ()

@property (weak, nonatomic) IBOutlet PDLineChart *dayLineChart;
@property (weak, nonatomic) IBOutlet PDLineChart *allTimeLineChart;
@property (weak, nonatomic) IBOutlet UILabel *wordsLearnt;

@property (nonatomic, strong) NSArray *allTimeData;

@property (nonatomic, assign) NSInteger attemptsCounter;

@end

@implementation StatisticsViewController

#pragma mark - Initialization

- (void)viewDidLoad {
    [super viewDidLoad];
    self.wordsLearnt.alpha = 0.0f;
    [self setupLineChart];
    [self loadChartData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setEdgeGestureRecognizerEnabled:YES];
}

#pragma mark - Button Actions

- (IBAction)logoutButtonPressed:(id)sender {
    [WebService clearUserID];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Chart Methods

-(void)loadChartData {
    self.attemptsCounter++;
    WebService *service = [WebService new];
    [service requestWithUserIDType:WebServiceRequestGetAccumulativeChart completion:^(PerDayChartResponse *response, ErrorResponse *error) {
        if([response isKindOfClass:[PerDayChartResponse class]]) {
            self.allTimeData = response.chartData;
            [self updateWordsLearntLabelWithData:response.chartData.lastObject];
            PDLineChartDataObject *lineData = [self chartDataFromArray:self.allTimeData];
            self.allTimeLineChart.chartData = lineData;
            if(self.perDayData && !self.dayLineChart.chartData) {
                PDLineChartDataObject *perDayData = [self chartDataFromArray:self.perDayData];
                self.dayLineChart.chartData = perDayData;
            }
        } else {
            if(self.attemptsCounter < 5) {
//                [self loadChartData];
            }
        }
    }];
    if(!self.perDayData) {
        WebService *perDayService = [WebService new];
        [perDayService requestWithUserIDType:WebServiceRequestGetPerDayChart completion:^(PerDayChartResponse *response, ErrorResponse *error) {
            if([response isKindOfClass:[PerDayChartResponse class]]) {
                self.perDayData = response.chartData;
                PDLineChartDataObject *lineData = [self chartDataFromArray:self.perDayData];
                self.dayLineChart.chartData = lineData;
            } else {
                if(self.attemptsCounter < 5) {
//                    [self loadChartData];
                }
            }
        }];
    }
}

#pragma mark - Helpers

-(void)updateWordsLearntLabelWithData:(PerDayChartGraphObject*)data {
    self.wordsLearnt.text = [self.wordsLearnt.text stringByReplacingOccurrencesOfString:@"XXX" withString:data.value];
    [UIView animateWithDuration:0.5 animations:^{
        self.wordsLearnt.alpha = 1.0f;
    }];
}

-(void)setupLineChart {
    NSArray *charts = @[self.dayLineChart, self.allTimeLineChart];
    for (PDLineChart *lineChart in charts) {
        lineChart.animatable = YES;
        lineChart.animationDuration = 0.75f;
        lineChart.noDataDescription = @"Нет данных для показа.";
        lineChart.yValueTextColor = [UIColor whiteColor];
        lineChart.yValueLabelDegree = 65;

    }
}

-(PDLineChartDataObject*)chartDataFromArray:(NSArray*)data {
    PDLineChartDataObject *chartData = [PDLineChartDataObject new];
    NSMutableArray *valuesArray = [NSMutableArray new];
    NSMutableArray *xValuesArray = [NSMutableArray new];
    for (PerDayChartGraphObject *object in data) {
        [valuesArray addObject:object.value];
        [xValuesArray addObject:object.date];
    }
    chartData.values = valuesArray;
    chartData.xValues = xValuesArray;
    return chartData;
}

@end
