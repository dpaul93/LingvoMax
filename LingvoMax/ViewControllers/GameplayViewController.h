//
//  GameplayViewController.h
//  LingvoMax
//
//  Created by Pavlo Deynega on 27.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GameplayViewControllerType) {
    GameplayViewControllerTypeStudy,
    GameplayViewControllerTypeRepeat
};

@interface GameplayViewController : UIViewController

@property (nonatomic, assign) GameplayViewControllerType controllerType;
@property (nonatomic, strong) NSArray *words;

@end
