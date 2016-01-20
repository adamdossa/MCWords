//
//  LearnWebVC.m
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "LearnWebVC.h"

@interface LearnWebVC ()
@property (nonatomic, strong) NSString* currentWord;

@end

@implementation LearnWebVC
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshView];
}

- (void)setWord:(NSString *)word
{
    _word = word;
    [self refreshView];
}

- (void)refreshView
{
    if (self.word) {
//        if (![self.word isEqualToString:self.currentWord]) {
            [self.bbcWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://bbc.co.uk/search/news/?q=" stringByAppendingString:self.word]]]];
            [self.twitterWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[@"http://twitter.com/search?q=" stringByAppendingString:self.word]]]];
            self.currentWord = self.word;
//        }
    }
}
@end
