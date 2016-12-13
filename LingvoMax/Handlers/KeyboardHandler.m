//
//  KeyboardHandler.m
//  GotToTrain
//
//  Created by Paul Deynega on 9/29/15.
//  Copyright © 2015 Migon Software. All rights reserved.
//

#import "KeyboardHandler.h"

@interface KeyboardHandler()

@property (strong, nonatomic) NSLayoutConstraint *constraintToChange;
@property (strong, nonatomic) UIView *view;

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (assign, nonatomic) BOOL canBeEdited;

@end

@implementation KeyboardHandler

-(instancetype)initWithView:(UIView *)view bottomConstraint:(NSLayoutConstraint *)bottomConstraint {
    self = [super init];
    if (self) {
        [self registerForKeyboardNotifications];
        
        self.view = view;
        self.constraintToChange = bottomConstraint;
    }
    
    return self;
}

-(void)addTapRecognizer {
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:self.tapRecognizer];
    self.canBeEdited = YES;
}

- (void)registerForKeyboardNotifications {
    self.canBeEdited = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
}

-(void)keyboardWillBeChanged:(NSNotification *)notification {
    CGRect keyboardEndFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] integerValue];
    
    CGFloat endKeyboardHeight = keyboardBeginFrame.origin.y - keyboardEndFrame.origin.y;
    
//    if(endKeyboardHeight == 0) {
//        return;
//    }
    
//    self.constraintToChange.constant += endKeyboardHeight;
    
    if(self.scrollView) {
        [self.scrollView setContentInset:UIEdgeInsetsMake(0, 0, endKeyboardHeight, 0)];
//        [self.scrollView setContentOffset:CGPointMake(0, endKeyboardHeight / 2)];
    }
    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
//    [UIView setAnimationDuration:animationDuration];
//    [UIView setAnimationCurve:animationCurve];
//    
//    [self.view layoutIfNeeded];
//    
//
//    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    self.canBeEdited = YES;
}

#pragma mark - Tap Recognizer

-(void)onTap:(UITapGestureRecognizer*)tapRecognizer {
    if(self.canBeEdited)
        [self.view endEditing:YES];
}

-(void)dealloc {
    NSLog(@"%@ dealocated", NSStringFromClass([self class]));
    [self.view removeGestureRecognizer:self.tapRecognizer];
    self.tapRecognizer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification
                                                  object:nil];
}

@end
