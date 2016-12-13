//
//  GameplayViewController.m
//  LingvoMax
//
//  Created by Pavlo Deynega on 27.10.15.
//  Copyright © 2015 paul deynega. All rights reserved.
//

#import "GameplayViewController.h"
#import "RoundedButton.h"
#import "KeyboardHandler.h"
#import "GetNewWordsResponse.h"
#import "WebService.h"
#import "SetWordsAsKnownDTO.h"
#import "SuccessResponse.h"
#import "ErrorResponse.h"

@import SVProgressHUD;

typedef NS_ENUM(NSInteger, GameplayType) {
    GameplayTypeNone,
    GameplayTypeStudy,
    GameplayTypeTranslateToRussian,
    GameplayTypeRepeat2,
    GameplayTypeTranslateToEnglish,
    GameplayTypeRepeat3,
    GameplayTypeFinish
};

@interface GameplayViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UILabel *taskLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishWordLabel;
@property (weak, nonatomic) IBOutlet UILabel *transcriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *russianWordLabel;
@property (weak, nonatomic) IBOutlet UITextField *wordTextField;
@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet RoundedButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *wordsToRepeatLabel;

@property (weak, nonatomic) IBOutlet UILabel *wordsLearntLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) KeyboardHandler *keyboardHandler;

@property (nonatomic, assign) GameplayType gameType;

@property (nonatomic, strong) NSMutableArray *currentWords;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *currentWordsToFill;

@property (nonatomic, strong) NSMutableArray *wordsToRepeat;

@property (nonatomic, assign) NSInteger amountOfWordsLearnt;
@property (nonatomic, assign) NSInteger amountOfWordsToRepeat;

@property (nonatomic, assign) BOOL inProcess;

@end

@implementation GameplayViewController

#pragma mark - Initaliazation

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentWords = [NSMutableArray new];
    self.wordsToRepeat = [NSMutableArray new];
    self.currentWordsToFill = [NSMutableArray new];
    
    self.containerView.backgroundColor = [self.containerView.backgroundColor colorWithAlphaComponent:0.5f];
    self.containerView.layer.cornerRadius = 5.0f;
    
    self.keyboardHandler = [[KeyboardHandler alloc] initWithView:self.view bottomConstraint:self.bottomLayoutConstraint];
    [self.keyboardHandler addTapRecognizer];
    self.keyboardHandler.scrollView = self.scrollView;
    
    [self nextButtonPressed:nil];
}

#pragma mark - UITextField Delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self nextButtonPressed:nil];
    return YES;
}

#pragma mark - Button Actions

- (IBAction)nextButtonPressed:(id)sender {
    if(self.currentIndex >= self.currentWords.count) {
        [self.wordTextField resignFirstResponder];
        self.currentIndex = 0;
        
        switch (self.gameType) {
            case GameplayTypeNone: {
                [self prepareViewForRepeatWithTitle:@"1. Обучение"];
                self.gameType = GameplayTypeStudy;
                self.currentWords = [self.words mutableCopy];
                [self handleNextStudyWord];
                break;
            }
            case GameplayTypeStudy: {
                [self prepareViewForInputEnglish:NO title:@"2. Переведите на русский"];
                self.gameType = GameplayTypeTranslateToRussian;
                [self setNewRepeatWordToRussian:YES];
                break;
            }
            case GameplayTypeTranslateToRussian: {
                if(self.currentWords.count == self.currentWordsToFill.count) {
                    [self prepareViewForInputEnglish:YES title:@"3. Переведите на английский"];
                    self.gameType = GameplayTypeTranslateToEnglish;
                    self.currentWords = [self.words mutableCopy];
                    self.currentWordsToFill = [NSMutableArray new];
                    [self setNewRepeatWordToRussian:NO];
                } else {
                    NSMutableArray *excluding = [[self excludingArrayFromCurrentWords] mutableCopy];
                    [self randomizeArray:excluding];
                    self.currentWords = excluding;
                    self.currentWordsToFill = [NSMutableArray new];
                    [self prepareViewForRepeatWithTitle:@"2. Повторение"];
                    self.gameType = GameplayTypeRepeat2;
                    [self handleNextStudyWord];
                }
                break;
            }
            case GameplayTypeRepeat2: {
                [self prepareViewForInputEnglish:NO title:@"2. Переведите на русский"];
                self.gameType = GameplayTypeTranslateToRussian;
                [self setNewRepeatWordToRussian:YES];
                break;
            }
            case GameplayTypeTranslateToEnglish: {
                if(self.currentWords.count == self.currentWordsToFill.count) {
                    self.amountOfWordsToRepeat = self.wordsToRepeat.count;
                    self.amountOfWordsLearnt = self.words.count - self.amountOfWordsToRepeat;
                    [self prepareViewForExit];
                    self.currentWords = [NSMutableArray new];
                    self.gameType = GameplayTypeFinish;
                } else {
                    NSMutableArray *excluding = [[self excludingArrayFromCurrentWords] mutableCopy];
                    [self randomizeArray:excluding];
                    self.currentWords = excluding;
                    self.currentWordsToFill = [NSMutableArray new];
                    [self prepareViewForRepeatWithTitle:@"3. Повторение"];
                    self.gameType = GameplayTypeRepeat3;
                    [self handleNextStudyWord];
                }
                break;
            }
            case GameplayTypeRepeat3: {
                [self prepareViewForInputEnglish:YES title:@"3. Переведите на английский"];
                self.gameType = GameplayTypeTranslateToEnglish;
                [self setNewRepeatWordToRussian:NO];
                break;
            }
            case GameplayTypeFinish: {
                [self dismissViewControllerAnimated:YES completion:nil];
                return;
            }
        }
    } else {
        switch (self.gameType) {
            case GameplayTypeStudy:
            case GameplayTypeRepeat2:
            case GameplayTypeRepeat3: {
                [self handleNextStudyWord];
                break;
            }
            case GameplayTypeTranslateToEnglish: {
                [self handleNextReapeatWordToRussian:NO];
                break;
            }
            case GameplayTypeTranslateToRussian: {
                [self handleNextReapeatWordToRussian:YES];
                break;
            }
            default: break;
        }
    }
    
    static int index = 0;
    
    NSArray *images = @[@"back_blurred", @"blue_space_blurred", @"Nebula_blurred", @"horsehead_nebula_blurred"];
    if(index >= images.count)
        index = 0;
    UIImage *image = [UIImage imageNamed:images[index]];
    self.backgroundImageView.image = image;
    index++;
}

- (IBAction)exitButtonPressed:(id)sender {
    if(self.gameType == GameplayTypeFinish) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showExitAlert];
    }
}

#pragma mark - Gameplay actions

-(void)handleNextStudyWord {
    WordObject *word = self.currentWords[self.currentIndex];
    
    self.englishWordLabel.text = word.englishWord;
    self.transcriptionLabel.text = word.transcription;
    self.russianWordLabel.text = word.russianWord;
    
    self.currentIndex++;
}

-(void)setNewRepeatWordToRussian:(BOOL)russian {
    WordObject *word = self.currentWords[self.currentIndex];
    if(russian) {
        self.englishWordLabel.text = word.englishWord;
        self.transcriptionLabel.text = word.transcription;
    } else {
        self.englishWordLabel.text = word.russianWord;
    }
}

-(void)handleNextReapeatWordToRussian:(BOOL)russian {
    WordObject *word = self.currentWords[self.currentIndex];
    
    NSString *wordToCheck = russian ? word.russianWord : word.englishWord;
    BOOL correct = NO;
    NSArray *separated = [wordToCheck componentsSeparatedByString:@","];
    NSArray *separatedEntered = [self.wordTextField.text componentsSeparatedByString:@","];

    for (NSString *containedWord in separated) {
        for (NSString *enteredWord in separatedEntered) {
            NSString *cleared = [containedWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *enteredCleared = [enteredWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if([cleared isEqualToString:enteredCleared]) {
                correct = YES;
                break;
            }
        }
    }
    
    if(correct) {
        [self.currentWordsToFill addObject:word];
    } else {
        if(![self.wordsToRepeat containsObject:word]) {
            [self.wordsToRepeat addObject:word];
        }
    }
    
    [self flashAnswerCorrect:correct];
    
    self.currentIndex++;
    if(self.currentIndex >= self.currentWords.count) {
        [self nextButtonPressed:nil];
    } else {
        [self setNewRepeatWordToRussian:russian];
    }
    self.wordTextField.text = @"";
}

#pragma mark - Helpers

-(void)flashAnswerCorrect:(BOOL)correct {
    UIColor *color;
    if(correct) {
        color = [UIColor colorWithRed:0.05 green:0.95 blue:0.30 alpha:1.0];
    } else {
        color = [UIColor colorWithRed:1.00 green:0.14 blue:0.18 alpha:1.0];
    }
    
    UIView *flashView = [[UIView alloc] initWithFrame:self.view.bounds];
    flashView.alpha = 0.0f;
    flashView.backgroundColor = color;
    [self.view insertSubview:flashView belowSubview:self.scrollView];
    
    [UIView animateWithDuration:0.25 animations:^{
        flashView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

-(NSArray*)excludingArrayFromArray:(NSArray*)words {
    NSMutableArray *temp = [self.words mutableCopy];
    for (WordObject *word in words) {
        if([temp containsObject:word]) {
            [temp removeObject:word];
        }
    }
    return temp;
}

-(NSArray*)excludingArrayFromCurrentWords {
    NSMutableArray *temp = [self.currentWords mutableCopy];
    for (WordObject *word in self.currentWordsToFill) {
        if([temp containsObject:word]) {
            [temp removeObject:word];
        }
    }
    return temp;
}

-(void)prepareViewForExit {
    if(self.amountOfWordsLearnt > 0) {
        WebService *service = [WebService new];
        [service requestWithType:WebServiceRequestSetWordsAsKnown dto:^BaseDTO *(SetWordsAsKnownDTO *dtoObject) {
            dtoObject.userID = [WebService userID];
            dtoObject.words = [self excludingArrayFromArray:self.wordsToRepeat];
            if(self.controllerType == GameplayViewControllerTypeStudy)
                dtoObject.requestType = SetWordsTypeStudiedWords;
            else if (self.controllerType == GameplayViewControllerTypeRepeat)
                dtoObject.requestType = SetWordsTypeRepeatedWords;
            return dtoObject;
        } completion:^(SuccessResponse *response, ErrorResponse *error) {
            if(error) {
                [SVProgressHUD showErrorWithStatus:error.errorMessage];
            } else if([response isKindOfClass:[SuccessResponse class]]) {
                if(response.success) {
                    NSLog(@"Forgotten successfully");
                }
            }
        }];
    }
    
    self.wordsLearntLabel.text = [self.wordsLearntLabel.text stringByReplacingOccurrencesOfString:@"XXX" withString:@(self.amountOfWordsLearnt).stringValue];
    self.wordsToRepeatLabel.text = [self.wordsToRepeatLabel.text stringByReplacingOccurrencesOfString:@"XXX" withString:@(self.amountOfWordsToRepeat).stringValue];

    self.nextButton.backgroundColor = [UIColor colorWithRed:0.70 green:0.11 blue:0.27 alpha:1.0];
    [self.nextButton setTitle:@"На главную" forState:UIControlStateNormal];
    
    self.containerHeightConstraint.constant = -(self.containerView.bounds.size.height / 3.0f);
    [UIView animateWithDuration:0.75f animations:^{
        [self.containerView layoutIfNeeded];
        self.wordsLearntLabel.alpha = 1.0f;
        self.wordsToRepeatLabel.alpha = 1.0f;
        
        self.transcriptionLabel.alpha = 0.0f;
        self.englishWordLabel.alpha = 0.0f;
        self.russianWordLabel.alpha = 0.0f;
        self.wordTextField.alpha = 0.0f;
        self.taskLabel.alpha = 0.0f;
    }];
}

-(void)prepareViewForRepeatWithTitle:(NSString*)title {
    [self.transcriptionLabel setHidden:NO];
    [self.englishWordLabel setHidden:NO];
    [self.russianWordLabel setHidden:NO];
    [self.wordTextField setHidden:YES];
    self.taskLabel.text = title;
}

-(void)prepareViewForInputEnglish:(BOOL)english title:(NSString*)title{
    self.taskLabel.text = title;
    [self.russianWordLabel setHidden:YES];
    if(english) {
        [self.transcriptionLabel setHidden:YES];
    } else {
        [self.transcriptionLabel setHidden:NO];
    }
    [self.wordTextField setHidden:NO];
}

-(void)randomizeArray:(NSMutableArray*)array {
    for (int i = 0; i < array.count; i++) {
        int random = arc4random_uniform((int)array.count);
        [array exchangeObjectAtIndex:0 withObjectAtIndex:random];
    }
}

-(void)showExitAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Предупреждение" message:@"Вы действительно хотите прервать обучение?" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.gameType = GameplayTypeFinish;
        self.currentWords = [NSMutableArray new];
        [self prepareViewForExit];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
