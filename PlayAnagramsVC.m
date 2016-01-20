//
//  PlayAnagramsVC.m
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "PlayAnagramsVC.h"
#include <stdlib.h>

@interface PlayAnagramsVC ()
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *scrambledLabel;
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSString *definition;
@property (weak, nonatomic) IBOutlet UITextField *answer;
@property (weak, nonatomic) IBOutlet UIImageView *resultImage;
@end

@implementation PlayAnagramsVC

- (NSString *) getRandomWord
{
    int totalWords = [self.words count];
    int r = random() % totalWords;
    return self.words[r];
}

- (IBAction)newAnagram:(UIButton *)sender {
    int totalWords = [self.words count];
    int r = random() % totalWords;    
    self.word = self.words[r];
    self.definition = self.wordDefinitions[r];
    self.scrambledLabel.text = [self scrambleString:self.word];
    self.definitionLabel.text = self.definition;
    self.resultImage.image = nil;
    [self.answer resignFirstResponder];
    
}

- (IBAction)checkAnswer:(UIButton *)sender {
    NSString *answerString = self.answer.text;
    if ([answerString isEqualToString: self.word]) {
        UIImage *image = [UIImage imageNamed:@"ThumbUp.png"];
        self.resultImage.image = image;
    } else {
        UIImage *image = [UIImage imageNamed:@"ThumbDown.png"];
        self.resultImage.image = image;
    }
    [self.answer resignFirstResponder];
    
}

- (NSString *)scrambleString:(NSString *)toScramble {
    for (int i = 0; i < [toScramble length] * 15; i ++) {
        int pos = random() % [toScramble length];
        int pos2 = random() % ([toScramble length] - 1);
        char ch = [toScramble characterAtIndex:pos];
        NSString *before = [toScramble substringToIndex:pos];
        NSString *after = [toScramble substringFromIndex:pos + 1];
        NSString *temp = [before stringByAppendingString:after];
        before = [temp substringToIndex:pos2];
        after = [temp substringFromIndex:pos2];
        toScramble = [before stringByAppendingFormat:@"%c%@", ch, after];
    }
    return toScramble;
}

@end
