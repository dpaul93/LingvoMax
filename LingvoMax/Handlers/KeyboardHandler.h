//
//  KeyboardHandler.h
//  GotToTrain
//
//  Created by Paul Deynega on 9/29/15.
//  Copyright © 2015 Migon Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardHandler : NSObject

@property (nonatomic, weak) UIScrollView *scrollView;

-(instancetype)initWithView:(UIView*)view bottomConstraint:(NSLayoutConstraint*)bottomConstraint;

-(void)addTapRecognizer;

@end
