//
//  TestVC.m
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "TestVC.h"
#import <Parse/Parse.h>

@interface TestVC ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerText;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString *answer;
@property (nonatomic, strong) NSMutableArray *remainingWords;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property NSInteger timeSoFar;
@property (nonatomic, strong) NSMutableDictionary *wordDictionary;
@property (weak, nonatomic) IBOutlet UILabel *finalLabel;
@property (nonatomic, strong) NSMutableArray *correctAnswers;
@end

@implementation TestVC

- (NSMutableArray*) correctAnswers
{
    if (!_correctAnswers) {
        _correctAnswers = [[NSMutableArray alloc] init];
    }
    return _correctAnswers;
}

- (NSMutableDictionary*) wordDictionary
{
    if (!_wordDictionary) {
        _wordDictionary = [[NSMutableDictionary alloc] init];
        for (NSString *word in self.words) {
            _wordDictionary[word] = [NSNumber numberWithInt:0];
        }
    }
    return _wordDictionary;
}

- (NSMutableArray*) remainingWords
{
    if (!_remainingWords) {
        _remainingWords = [[NSMutableArray alloc] initWithArray:self.words];
    }
    return _remainingWords;
}

- (IBAction)submit:(UIButton *)sender {
    [self checkAnswer];
}

- (IBAction)start:(UIButton *)sender {
    if (![self.remainingWords count]) {
        self.remainingWords = [[NSMutableArray alloc] initWithArray:self.words];
        [self.remainingWords removeObjectsInArray:self.correctAnswers];
    }
    if (![self.remainingWords count]) {
        [sender setTitle:@"All Done" forState:UIControlStateNormal];
        //Update Progress Session if needed for non-review session
        if (self.review == [NSNumber numberWithInt:0]) {
            PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            PFObject *progress = [query getFirstObject];
            NSNumber *currentSession = [progress objectForKey:@"session"];
            int current = [currentSession integerValue];
            int newSession = [self.progressSession integerValue] + 1;
            if (newSession > current) {
                [progress setObject:[NSNumber numberWithInt:newSession] forKey:@"session"];
                [progress setObject:[NSNumber numberWithInt:0] forKey:@"quizTaken"];
                [progress save];
            }
        } else {
            PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            [query whereKey:@"session" equalTo:self.progressSession];
            PFObject *progress = [query getFirstObject];
            if (progress) {
                [progress setObject:[NSNumber numberWithInt:1] forKey:@"quizTaken"];
                [progress save];
            }
        }
        
    } else {
        [self refreshQuestion];
        [sender setTitle:@"Next" forState:UIControlStateNormal];
    }
}

- (void) refreshQuestion
{
    //Choose from remainingWords
    int r = random() % [self.remainingWords count];
    int o = [self.words indexOfObject:self.remainingWords[r]];
    self.definitionLabel.text = self.wordDefinitions[o];
    self.answer = self.words[o];
    self.answerText.text = nil;
    self.imageView.image = nil;
    [self.remainingWords removeObject:self.answer];
    self.timeSoFar = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(moreProgress) userInfo:nil repeats:YES];
    [self.startButton setEnabled:FALSE];
    self.finalLabel.text = nil;

}

- (void) moreProgress {
    self.timeSoFar = self.timeSoFar + 1;
    self.progressView.progress = self.timeSoFar / 30.0f;
    if ((self.timeSoFar / 30.0f) > 1.0f) {
        [self checkAnswer];
    }
}

- (void) checkAnswer
{
    [self.timer invalidate];
    NSNumber *score = self.wordDictionary[self.answer];
    if ([self.answer isEqualToString:self.answerText.text]) {
        UIImage *image = [UIImage imageNamed:@"ThumbUp.png"];
        self.imageView.image = image;
        score = [NSNumber numberWithInt:[score integerValue] + 1];
    } else {
        UIImage *image = [UIImage imageNamed:@"ThumbDown.png"];
        self.imageView.image = image;
        score = [NSNumber numberWithInt:0];
    }
    self.wordDictionary[self.answer] = score;
    if ([score integerValue] == 2) {
        [self.correctAnswers addObject:self.answer];
    }
    self.finalLabel.text = self.answer;
    [self.answerText resignFirstResponder];
    [self.startButton setEnabled:TRUE];

}

@end
