//
//  TempTestViewController.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 18.11.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "TempTestViewController.h"
#import "PDLineChart.h"

@interface TempTestViewController ()

@property (weak, nonatomic) IBOutlet PDLineChart *chartView;

@end

@implementation TempTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


-(void)viewDidLayoutSubviews__ {
    static BOOL shouldLayout = YES;
    [super viewDidLayoutSubviews];
    
    if(shouldLayout) {
        PDLineChartDataObject *data = [PDLineChartDataObject new];
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < 20; i++) {
            if(i == 19) {
                [temp addObject:@"100"];
            } else
                [temp addObject:[NSString stringWithFormat:@"%i",arc4random_uniform(100)]];
        }
        data.values = temp;
        
        self.chartView.chartData = data;
        
        shouldLayout = NO;
    }

}

- (IBAction)reloadPressed:(id)sender {
    [self.chartView resetData];
    self.chartView.animatable = YES;
    self.chartView.animationDuration = 0.3f;
    
    PDLineChartDataObject *data = [PDLineChartDataObject new];
    NSMutableArray *temp = [NSMutableArray new];
    for (int i = 0; i < 20; i++) {
        if(i == 19) {
            [temp addObject:@"100"];
        } else
            [temp addObject:[NSString stringWithFormat:@"%i",arc4random_uniform(100)]];
    }
    data.values = temp;
    
    self.chartView.chartData = data;

}

@end
