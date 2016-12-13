//
//  PushAnimator.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 17.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "PushAnimator.h"

@implementation PushAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    CGRect fromFrame, toFrame, initialFrame;
    fromFrame = toFrame = initialFrame = fromViewController.view.frame;
    fromFrame.origin.x = fromFrame.size.width;
    toViewController.view.frame = fromFrame;
    
    toFrame.origin.x = -toFrame.size.width;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        [fromViewController.view setFrame:toFrame];
        [toViewController.view setFrame:initialFrame];
    } completion:^(BOOL finished) {
        fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
