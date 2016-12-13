//
//  UINavigationController+TranslucentNavigationBar.m
//  GotToTrain
//
//  Created by Paul Deynega on 10/6/15.
//  Copyright © 2015 Migon Software. All rights reserved.
//

#import "UINavigationController+TranslucentNavigationBar.h"
#import "NavigationControllerDelegate.h"

static NSInteger const kStatusBarHeight = 20;
static NSInteger const kImageViewTag = 1488;

@implementation UINavigationController (TranslucentNavigationBar)

-(void)setBackgroundColor:(UIColor*)color {
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    self.navigationBar.translucent = YES;
    self.navigationBar.backgroundColor = color;
    
    NSArray *sublayers = self.navigationBar.layer.sublayers;
    CGSize statusBarSize = CGSizeMake(self.navigationBar.frame.size.width, kStatusBarHeight);
    for (int i = 0; i < sublayers.count; i++) {
        CALayer *layer = sublayers[i];
        if(CGSizeEqualToSize(layer.bounds.size, statusBarSize)) {
            [layer removeFromSuperlayer];
            break;
        }
    }
    
    CALayer *navBackgroundLayer = [CALayer layer];
    navBackgroundLayer.backgroundColor = [color CGColor];
    navBackgroundLayer.frame = CGRectMake(0, -kStatusBarHeight, statusBarSize.width, statusBarSize.height);
    [self.navigationBar.layer addSublayer:navBackgroundLayer];
    navBackgroundLayer.zPosition = -1;
    sublayers = self.navigationBar.layer.sublayers;
}

-(void)addBackgroundImageViewWithImage:(UIImage *)background {
    UIImageView *imageView = [self imageViewFromSublayers];
    
    if(!imageView) {
        imageView = [[UIImageView alloc] initWithImage:background];
        [imageView setFrame:self.view.bounds];
        imageView.tag = kImageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view insertSubview:imageView atIndex:0];
    } else {
        if(background) {
            [imageView setImage:background];
        } else {
            [imageView removeFromSuperview];
        }
    }
}

-(UIImageView*)imageViewFromSublayers {
    for (UIView *subview in self.view.subviews) {
        if(subview.tag) {
            return (UIImageView*)subview;
        }
    }
    return nil;
}

-(void)setEdgeGestureRecognizerEnabled:(BOOL)enabled {
    if(enabled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidReceiveSetGestureRecognizerEnabledNotification object:self];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidReceiveSetGestureRecognizerDisabledNotification object:self];
    }
}

@end
