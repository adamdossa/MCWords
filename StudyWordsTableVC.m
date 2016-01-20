//
//  MCWordsTableVC.m
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "StudyWordsTableVC.h"

@implementation StudyWordsTableVC


#pragma mark - View lifecycle
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.words count];
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
    UIViewController *detailVC = [self.splitViewController.viewControllers lastObject];
    if ([detailVC respondsToSelector:@selector(setWord:)]) {
        [detailVC performSelector:@selector(setWord:) withObject:self.words[indexPath.item]];
    }
    if ([detailVC respondsToSelector:@selector(setDefinition:)]) {
        [detailVC performSelector:@selector(setDefinition:) withObject:self.wordDefinitions[indexPath.item]];
    }
}

@end
