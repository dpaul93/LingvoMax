//
//  StartPageViewController.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "StartPageViewController.h"
#import "RoundedButton.h"
#import "KeyboardHandler.h"
#import "UINavigationController+TranslucentNavigationBar.h"
#import "WebService.h"
#import "AuthorizationResponse.h"
#import "AuthorizationDTO.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "ErrorResponse.h"

static NSString * const kMainScreenSegue = @"MainScreenSegue";

@interface StartPageViewController() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet RoundedButton *loginButton;
@property (weak, nonatomic) IBOutlet RoundedButton *registrationButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomScrollViewConstraint;

@property (strong, nonatomic) KeyboardHandler *keyboardHandler;

@end

@implementation StartPageViewController

#pragma mark - Initialization

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setAlpha:0.0f];
    
//    UIImage *back = [UIImage imageNamed:@"dictionary_blurred_scaled"];
    UIImage *back = [UIImage imageNamed:@"back_blurred"];

    [self.navigationController addBackgroundImageViewWithImage:back];
    
    [self.navigationController setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:self.loginButton.backgroundColor];

    self.keyboardHandler = [[KeyboardHandler alloc] initWithView:self.view bottomConstraint:self.bottomScrollViewConstraint];
    self.keyboardHandler.scrollView = self.scrollView;
    [self.keyboardHandler addTapRecognizer];
    
    [self setLeftImageForTextField:self.loginTextField imageName:@"user_icon"];
    [self setLeftImageForTextField:self.passwordTextField imageName:@"lock_icon"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setEdgeGestureRecognizerEnabled:YES];
    
    if(![WebService userID]) {
        [UIView animateWithDuration:0.25f animations:^{
            [self.view setAlpha:1.0f];
        }];
    } else {
        [self performSegueWithIdentifier:kMainScreenSegue sender:self];
    }
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Button Actions

- (IBAction)loginButtonPressed:(id)sender {
    [self signIn];
}

#pragma mark - Sign In

-(void)signIn {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    WebService *webService = [[WebService alloc] init];
    [webService requestWithType:WebServiceRequestAuthorization dto:^BaseDTO *(AuthorizationDTO *dtoObject) {
        dtoObject.username = self.loginTextField.text;
        dtoObject.password = self.passwordTextField.text;
        return dtoObject;
    } completion:^(AuthorizationResponse *response, ErrorResponse *error) {
        if(response && [response isKindOfClass:[AuthorizationResponse class]]) {
            if(response.success) {
                [SVProgressHUD showSuccessWithStatus:@""];
                [WebService setUserID:response.userID];
                [self performSegueWithIdentifier:kMainScreenSegue sender:self];
            } else {
                //[SVProgressHUD showErrorWithStatus:error.errorMessage];
            }
        } else if(error && [error isKindOfClass:[ErrorResponse class]]) {
            [SVProgressHUD showErrorWithStatus:error.errorMessage];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Произошла неизвестная ошибка!"];
        }
    }];
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing__:(UITextField *)textField {
    if([textField isEqual:self.loginTextField]) {
        [self.scrollView setContentOffset:CGPointMake(0, textField.bounds.size.height * 2) animated:YES];
    } else if([textField isEqual:self.passwordTextField]) {
        [self.scrollView setContentOffset:CGPointMake(0, textField.bounds.size.height * 3) animated:YES];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if([textField isEqual:self.passwordTextField]) {
        [textField resignFirstResponder];
        [self signIn];
    }
    
    return YES;
}

#pragma mark - Helpers

-(void)setLeftImageForTextField:(UITextField*)textField imageName:(NSString*)imageName {
    CGFloat imageSize = textField.bounds.size.height - 10.0f;
    UIImage *test = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:test];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = CGRectMake(0.0, 0.0f, imageSize + 10.0f, imageSize);
    textField.leftView = imageView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

@end
