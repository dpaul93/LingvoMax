//
//  NavigationControllerDelegate.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 17.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "PushAnimator.h"
#import "PopAnimator.h"

NSString * const kDidReceiveSetGestureRecognizerEnabledNotification = @"DidReceiveSetGestureRecognizerEnabledNotification";
NSString * const kDidReceiveSetGestureRecognizerDisabledNotification = @"DidReceiveSetGestureRecognizerDisabledNotification";

@interface NavigationControllerDelegate()

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition* interactionController;
@property (strong, nonatomic) UIScreenEdgePanGestureRecognizer* edgePanRecognizer;

@end

@implementation NavigationControllerDelegate

#pragma mark - Initialization

- (void)awakeFromNib {
    self.edgePanRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    self.edgePanRecognizer.edges = UIRectEdgeLeft;
    [self.navigationController.view addGestureRecognizer:self.edgePanRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kDidReceiveSetGestureRecognizerEnabledNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kDidReceiveSetGestureRecognizerDisabledNotification object:nil];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController.view removeGestureRecognizer:self.edgePanRecognizer];
    self.edgePanRecognizer = nil;
}

#pragma mark - Gesture recognizer methods

- (void)pan:(UIPanGestureRecognizer*)recognizer {
    UIView* view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.interactionController = [UIPercentDrivenInteractiveTransition new];
        [self.navigationController popViewControllerAnimated:YES];

//        CGPoint location = [recognizer locationInView:view];
//        if (location.x <  CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
//            self.interactionController = [UIPercentDrivenInteractiveTransition new];
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

#pragma mark - UINavigationController Delegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if(operation == UINavigationControllerOperationPush) {
        return [PushAnimator new];
    } else if (operation == UINavigationControllerOperationPop) {
        return [PopAnimator new];
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactionController;
}

#pragma mark - Notification Handling

-(void)didReceiveNotification:(NSNotification*)notification {
    NSString *notificationName = notification.name;
    if([notificationName isEqualToString:kDidReceiveSetGestureRecognizerEnabledNotification]) {
        self.edgePanRecognizer.enabled = YES;
    } else if([notificationName isEqualToString:kDidReceiveSetGestureRecognizerDisabledNotification]) {
        self.edgePanRecognizer.enabled = NO;
    }
}

@end
