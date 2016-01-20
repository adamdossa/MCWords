//
//  StudySessionTableVC.m
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "StudySessionTableVC.h"
#import <Parse/Parse.h>

@interface StudySessionTableVC ()

@end

@implementation StudySessionTableVC
@synthesize progressSession = _progressSession;

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //Get session number
    if ([PFUser currentUser]) {
        PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        PFObject *progress = [query getFirstObject];
        NSNumber *session = [progress objectForKey:@"session"];
        self.progressSession = [session integerValue];
        [self.tableView reloadData];
    }
}

- (void) setProgressSession:(NSInteger)progressSession
{
    _progressSession = progressSession;
}

- (NSInteger) progressSession
{
    if (!_progressSession) {
        if ([PFUser currentUser]) {
            PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
            [query whereKey:@"user" equalTo:[PFUser currentUser]];
            PFObject *progress = [query getFirstObject];
            NSNumber *session = [progress objectForKey:@"session"];
            _progressSession = [session integerValue];
        }
    }
    return _progressSession;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.progressSession;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SessionInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Session: %d", indexPath.item + 1];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"StudySegue"]) {
            //Get list of words, definitions and pass it through
            PFQuery *query = [PFQuery queryWithClassName:@"Word"];
            [query whereKey:@"session" equalTo:[NSNumber numberWithInt:indexPath.item + 1]];
            NSMutableArray *words = [[NSMutableArray alloc] init];
            NSMutableArray *wordDefinitions = [[NSMutableArray alloc] init];
            NSArray *results = [query findObjects];
            for (PFObject *result in results) {
                [words addObject:[result objectForKey:@"word"]];
                [wordDefinitions addObject:[result objectForKey:@"definition"]];
            }
            if ([segue.destinationViewController respondsToSelector:@selector(setWords:)]) {
                [segue.destinationViewController performSelector:@selector(setWords:) withObject:words];
            }
            if ([segue.destinationViewController respondsToSelector:@selector(setWordDefinitions:)]) {
                [segue.destinationViewController performSelector:@selector(setWordDefinitions:) withObject:wordDefinitions];
            }
            if ([segue.destinationViewController respondsToSelector:@selector(setProgressSession:)]) {
                [segue.destinationViewController performSelector:@selector(setProgressSession:) withObject:[NSNumber numberWithInt:indexPath.item + 1]];
            }
        }
    }
}

@end
