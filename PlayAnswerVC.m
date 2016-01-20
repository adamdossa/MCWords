//
//  PlayAnswerVC.m
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "PlayAnswerVC.h"
#import <Parse/Parse.h>

@interface PlayAnswerVC ()
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) PFObject *result;
@end

@implementation PlayAnswerVC

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

- (void)setWords:(NSArray *)words
{
    _words = words;
    [self.tableView reloadData];
}

- (IBAction)checkAnswer:(UIButton *)sender {
    if ([self.word isEqualToString:self.answer]) {
        UIImage *image = [UIImage imageNamed:@"ThumbUp.png"];
        self.imageView.image = image;
        if (self.result) {
            NSNumber *score = [self.result objectForKey:@"score"];
            [self.result setObject:[NSNumber numberWithInt:[score integerValue] + 1 ] forKey:@"score"];
            [self.result save];
        }
    } else {
        UIImage *image = [UIImage imageNamed:@"ThumbDown.png"];
        self.imageView.image = image;
        if (self.result) {
            NSNumber *score = [self.result objectForKey:@"score"];
            [self.result setObject:[NSNumber numberWithInt:[score integerValue] - 1 ] forKey:@"score"];
            [self.result save];
        }
    }
}

- (IBAction)newDefinition:(UIButton *)sender {
    //Query for all definitions of our words, then select a random one
    PFQuery *query = [PFQuery queryWithClassName:@"WordDefinition"];
    [query whereKey:@"word" containedIn:self.words];
    [query whereKey:@"score" greaterThanOrEqualTo:[NSNumber numberWithInt:1]];
    NSArray *results = [query findObjects];
    //Check for any responses
    if (![results count]) {
        //Use the predefined ones
        results = self.wordDefinitions;
        int r = random() % [results count];
        self.answer = self.words[r];
        self.definitionLabel.text = self.wordDefinitions[r];
        self.result = nil;
    } else {
        int r = random() % [results count];
        self.result = results[r];
        NSString *tempAnswer = [self.result objectForKey:@"word"];
        self.answer = tempAnswer;
        self.definitionLabel.text = (NSString*)[self.result objectForKey:@"wordDefinition"];
    }
    self.imageView.image = nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WordInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.words[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.word = self.words[indexPath.item];
    self.imageView.image = nil;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.word = nil;
    self.imageView.image = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.words count];
}

@end
