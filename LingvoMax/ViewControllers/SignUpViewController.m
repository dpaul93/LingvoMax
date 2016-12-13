//
//  SignUpViewController.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 11.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "SignUpViewController.h"
#import "KeyboardHandler.h"
#import "WebService.h"
#import "SuccessResponse.h"
#import "RegistrationDTO.h"
#import "ErrorResponse.h"
#import <SVProgressHUD/SVProgressHUD.h>

static NSString * const kMainScreenSegue = @"MainScreenSegue";

@interface SignUpViewController()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UITextField *nicknameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordConfirmationTextField;

@property (nonatomic, strong) KeyboardHandler *keyboardHandler;

@end

@implementation SignUpViewController

#pragma mark - Initialization

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyboardHandler = [[KeyboardHandler alloc] initWithView:self.view bottomConstraint:self.scrollViewBottomConstraint];
    [self.keyboardHandler setScrollView:self.scrollView];
    [self.keyboardHandler addTapRecognizer];

    [self setLeftImageForTextField:self.nicknameTextField imageName:@"nickname_icon"];
    [self setLeftImageForTextField:self.loginTextField imageName:@"user_icon"];
    [self setLeftImageForTextField:self.passwordTextField imageName:@"lock_icon"];
    [self setLeftImageForTextField:self.passwordConfirmationTextField imageName:@"lock_icon"];
}

#pragma mark - Button Actions

- (IBAction)signUpButtonPressed:(id)sender {
    [self signUp];
}

#pragma mark - Sign Up

-(void)signUp {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    WebService *webService = [[WebService alloc] init];
    [webService requestWithType:WebServiceRequestRegistration dto:^BaseDTO *(RegistrationDTO *dtoObject) {
        dtoObject.nickname = self.nicknameTextField.text;
        dtoObject.username = self.loginTextField.text;
        dtoObject.password = self.passwordTextField.text;
        return dtoObject;
    } completion:^(SuccessResponse *response, ErrorResponse *error) {
        if(response && [response isKindOfClass:[SuccessResponse class]]) {
            if(response.success) {
                [SVProgressHUD showSuccessWithStatus:@"Регистрация успешна!"];
                [self performSegueWithIdentifier:kMainScreenSegue sender:self];
            } else {
                [SVProgressHUD showErrorWithStatus:@"Произошла неизвестная ошибка."];
            }
        } else if(error && [error isKindOfClass:[ErrorResponse class]]) {
            [SVProgressHUD showErrorWithStatus:error.errorMessage];
        } else {
            [SVProgressHUD showErrorWithStatus:@"Произошла неизвестная ошибка."];
        }
    }];
}

#pragma amrk - TextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([textField isEqual:self.nicknameTextField]) {
        [self.loginTextField becomeFirstResponder];
    } else if([textField isEqual:self.loginTextField]) {
        [self.passwordTextField becomeFirstResponder];
    } else if([textField isEqual:self.passwordTextField]) {
        [self.passwordConfirmationTextField becomeFirstResponder];
    } else if([textField isEqual:self.passwordConfirmationTextField]) {
        [textField resignFirstResponder];
        [self signUp];
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
