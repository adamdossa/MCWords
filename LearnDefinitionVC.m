//
//  MCWordsDefinitionVC.m
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "LearnDefinitionVC.h"

@interface LearnDefinitionVC ()
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@end

@implementation LearnDefinitionVC

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

- (void)setDefinition:(NSString *)definition
{
    _definition = definition;
    [self refreshView];
}

- (void)refreshView
{
    if (self.word) {
        self.wordLabel.text = self.word;
        self.definitionLabel.text = self.definition;
    }
}

@end
