//
//  MainScreenViewController.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 18.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "MainScreenViewController.h"
#import "RoundedButton.h"
#import "UINavigationController+TranslucentNavigationBar.h"
#import "WebService.h"
#import "AuthorizationResponse.h"
#import "GetNewWordsResponse.h"
#import "GetNewWordsDTO.h"
#import "GameplayViewController.h"
#import "ErrorResponse.h"
#import "PerDayChartResponse.h"
#import "PDLineChart.h"
#import "StatisticsViewController.h"

@import Charts;
@import SVProgressHUD;

static NSString * const kGameplaySegue = @"gameplaySegue";
static NSString * const kStatisticsSegue = @"statisticsSegue";
static NSInteger const kWordsToLoad = 10;

@interface MainScreenViewController() <ChartViewDelegate>

@property (weak, nonatomic) IBOutlet PDLineChart *lineChart;

@property (weak, nonatomic) IBOutlet RoundedButton *restartButton;
@property (weak, nonatomic) IBOutlet RoundedButton *startButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSArray *chartData;

@property (nonatomic, assign) GameplayViewControllerType gameplaySelectedType;

@property (nonatomic, assign) NSInteger attemptsCounter;

@end

@implementation MainScreenViewController

#pragma mark - Initialization

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.alpha = 0.0f;
    
    [self.navigationItem setHidesBackButton:YES];
    
    [self loadUsername];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.lineChart resetData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController setEdgeGestureRecognizerEnabled:NO];
    [self setupLineChart];
    
    [self loadChartData];
}

#pragma mark - Button Actions

- (IBAction)startButtonPressed:(id)sender {
    [self loadWordsToRepeat:NO];
}

- (IBAction)repeatButtonPressed:(id)sender {
    [self loadWordsToRepeat:NO];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:kGameplaySegue]) {
        GameplayViewController *gameplayViewController = segue.destinationViewController;
        gameplayViewController.words = self.words;
        gameplayViewController.controllerType = self.gameplaySelectedType;
    } else if ([segue.identifier isEqualToString:kStatisticsSegue]) {
        StatisticsViewController *statisticsViewController = segue.destinationViewController;
        statisticsViewController.perDayData = self.chartData;
    }
}

#pragma mark - Helpers

-(void)loadUsername {
    self.attemptsCounter++;
    WebService *service = [WebService new];
    [service requestWithUserIDType:WebServiceRequestGetUsername completion:^(AuthorizationResponse *response, ErrorResponse *error) {
        if ([response isKindOfClass:[AuthorizationResponse class]]) {
            [WebService setNickname:response.userID];
            self.titleLabel.text = [self.titleLabel.text stringByReplacingOccurrencesOfString:@"XXX" withString:response.userID];
            [UIView animateWithDuration:0.5f animations:^{
                self.titleLabel.alpha = 1.0f;
            }];
        } else {
            if(self.attemptsCounter < 5)
                [self loadUsername];
        }
    }];
}

-(void)loadChartData {
    WebService *service = [WebService new];
    [service requestWithUserIDType:WebServiceRequestGetPerDayChart completion:^(PerDayChartResponse *response, ErrorResponse *error) {
        if([response isKindOfClass:[PerDayChartResponse class]]) {
            self.chartData = response.chartData;
            PDLineChartDataObject *lineData = [self chartDataFromArray:self.chartData];
            self.lineChart.chartData = lineData;
//            self.lineChart.data = [self lineChartDataPerDay];
        } else {
            if(self.attemptsCounter < 5) {
                [self loadChartData];
            }
        }
    }];
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

-(void)setupLineChart {
    self.lineChart.animatable = YES;
    self.lineChart.animationDuration = 0.75f;
    self.lineChart.noDataDescription = @"Нет данных для показа.";
    self.lineChart.yValueTextColor = [UIColor whiteColor];
    self.lineChart.yValueLabelDegree = 65;
}

//-(LineChartData*)lineChartDataPerDay {
//    NSMutableArray *xVals = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < self.chartData.count; i++) {
//        PerDayChartGraphObject *object = self.chartData[i];
//        [xVals addObject:object.date];
//    }
//    
//    NSMutableArray *yVals = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < self.chartData.count; i++) {
//        PerDayChartGraphObject *object = self.chartData[i];
//        [yVals addObject:[[ChartDataEntry alloc] initWithValue:object.value.integerValue xIndex:i]];
//    }
//    
//    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet 1"];
//    
//    set1.lineWidth = 1.75;
//    set1.circleRadius = 4.0;
//    [set1 setValueTextColor:[UIColor whiteColor]];
//    [set1 setValueFont:[UIFont systemFontOfSize:12]];
//    [set1 setDrawValuesEnabled:YES];
//    [set1 setColor:[UIColor.whiteColor colorWithAlphaComponent:0.4]];
//    [set1 setCircleColor:UIColor.whiteColor];
//    
//    return [[LineChartData alloc] initWithXVals:xVals dataSet:set1];
//}

//- (LineChartData *)dataWithCount:(int)count range:(double)range {
//    NSMutableArray *xVals = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < count; i++) {
//        [xVals addObject:[@(i) stringValue]];
//    }
//    
//    NSMutableArray *yVals = [[NSMutableArray alloc] init];
//    
//    for (int i = 0; i < count; i++) {
//        double val = (double) (arc4random_uniform(range)) + 3;
//        [yVals addObject:[[ChartDataEntry alloc] initWithValue:(int)val xIndex:i]];
//    }
//    
//    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithYVals:yVals label:@"DataSet 1"];
//    
//    set1.lineWidth = 1.75;
//    set1.circleRadius = 4.0;
//    [set1 setValueTextColor:[UIColor whiteColor]];
//    [set1 setValueFont:[UIFont systemFontOfSize:12]];
//    [set1 setDrawValuesEnabled:YES];
//    [set1 setColor:[UIColor.whiteColor colorWithAlphaComponent:0.4]];
//    [set1 setCircleColor:UIColor.whiteColor];
//    
//    return [[LineChartData alloc] initWithXVals:xVals dataSet:set1];
//}

-(void)loadWordsToRepeat:(BOOL)repeat {
    GameplayViewControllerType controllerType;
    GetNewWordsType wordRequestType;
    if(repeat) {
        controllerType = GameplayViewControllerTypeRepeat;
        wordRequestType = GetNewWordsTypeRepeatWords;
    } else {
        controllerType = GameplayViewControllerTypeStudy;
        wordRequestType = GetNewWordsTypeStudyWords;
    }
    
    self.gameplaySelectedType = controllerType;
    [SVProgressHUD show];
    WebService *service = [WebService new];
    [service requestWithType:WebServiceRequestGetWordsToRepeat dto:^BaseDTO *(GetNewWordsDTO *dtoObject) {
        dtoObject.wordsCount = kWordsToLoad;
        dtoObject.userID = [WebService userID];
        dtoObject.reqeustType = wordRequestType;
        return dtoObject;
    } completion:^(GetNewWordsResponse *response, ErrorResponse *error) {
        if(error) {
            [SVProgressHUD showErrorWithStatus:error.errorMessage];
        } else if([response isKindOfClass:[GetNewWordsResponse class]]) {
            [SVProgressHUD showSuccessWithStatus:@""];
            self.words = response.words;
            [self performSegueWithIdentifier:kGameplaySegue sender:self];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Не удалось загрузить слова. Неизвестная ошибка."];
        }
    }];
}

@end
