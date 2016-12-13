//
//  UINavigationController+TranslucentNavigationBar.h
//  GotToTrain
//
//  Created by Paul Deynega on 10/6/15.
//  Copyright © 2015 Migon Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TranslucentNavigationBar)

-(void)setBackgroundColor:(UIColor*)color;
-(void)addBackgroundImageViewWithImage:(UIImage*)background;

-(void)setEdgeGestureRecognizerEnabled:(BOOL)enabled;

@end
