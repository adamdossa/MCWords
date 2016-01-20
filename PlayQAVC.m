//
//  PlayQAVC.m
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "PlayQAVC.h"
#import <Parse/Parse.h>

@interface PlayQAVC ()
@property (nonatomic, strong) NSMutableDictionary *wordDictionary;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *definitionText;
@property (nonatomic, strong) NSString *word;
@end

@implementation PlayQAVC

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

- (NSMutableDictionary*) wordDictionary
{
    if (!_wordDictionary) {
        _wordDictionary = [[NSMutableDictionary alloc] init];
    }
    return _wordDictionary;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.words count];
}

- (IBAction)storeAnswer:(UIButton *)sender {
    if (self.word) {
        self.wordDictionary[self.word] = self.definitionText.text;
    }
    [self.definitionText resignFirstResponder];
}

- (IBAction)saveAll:(UIButton *)sender {
    [self.definitionText resignFirstResponder];
    //First check all words have been defined
    if ([self.words count]!=[self.wordDictionary count]) {
        NSString *errorMessage = @"Please enter definitions for all words!";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    } else {
        //Store to Parse.com
        for (NSString *word in self.words) {
            PFObject *wordDef = [PFObject objectWithClassName:@"WordDefinition"];
            [wordDef setObject:word forKey:@"word"];
            [wordDef setObject:self.wordDictionary[word] forKey:@"wordDefinition"];
            [wordDef setObject:[NSNumber numberWithInt:5] forKey:@"score"];
            [wordDef save];
        }
    }
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
    NSString *definition = self.wordDictionary[self.words[indexPath.item]];
    self.definitionText.text = definition;
    self.word = self.words[indexPath.item];
    [self.definitionText resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.word = nil;
    self.definitionText.text = @"";
}

@end
