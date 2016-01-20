//
//  MCWordsInitialTableVC.m
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "StudyTypeTableVC.h"
#import <Parse/Parse.h>
@interface StudyTypeTableVC ()

@end

@implementation StudyTypeTableVC

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    //Requery for quizTaken if current session is maximum session
    PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    PFObject *progress = [query getFirstObject];
    NSNumber *maxSession = [progress objectForKey:@"session"];
    NSNumber *quizTaken = [progress objectForKey:@"quizTaken"];
    if ([maxSession isEqual:self.progressSession] && [quizTaken isEqual:[NSNumber numberWithInt:0]]) {
        //Stop if not indexPath.item == 3
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = nil;
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"WordSegue"]) {
            if ([segue.destinationViewController respondsToSelector:@selector(setWords:)]) {
                [segue.destinationViewController performSelector:@selector(setWords:) withObject:self.words];
            }
            if ([segue.destinationViewController respondsToSelector:@selector(setWordDefinitions:)]) {
                [segue.destinationViewController performSelector:@selector(setWordDefinitions:) withObject:self.wordDefinitions];
            }
        }
    }

    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Requery for quizTaken if current session is maximum session
    PFQuery *query = [PFQuery queryWithClassName:@"Progress"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    PFObject *progress = [query getFirstObject];
    NSNumber *maxSession = [progress objectForKey:@"session"];
    NSNumber *quizTaken = [progress objectForKey:@"quizTaken"];
    if ([maxSession isEqual:self.progressSession] && [quizTaken isEqual:[NSNumber numberWithInt:0]] && (indexPath.item!=3)) {
        //Stop if not indexPath.item == 3
        [[[UIAlertView alloc] initWithTitle:@"Complete Review" message:@"Please complete review first!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
        return;
    }
    if (indexPath.item == 3) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"MainStoryboard" bundle:[NSBundle mainBundle]];
        
        UIViewController *playView = [storyboard instantiateViewControllerWithIdentifier:@"testView"];
        PFQuery *query = [PFQuery queryWithClassName:@"Word"];
        [query whereKey:@"session" lessThanOrEqualTo:[NSNumber numberWithInt:[self.progressSession integerValue] - 1]];
        NSMutableArray *allWords = [[NSMutableArray alloc] init];
        NSMutableArray *allWordDefinitions = [[NSMutableArray alloc] init];
        NSArray *results = [query findObjects];
        for (PFObject *result in results) {
            [allWords addObject:[result objectForKey:@"word"]];
            [allWordDefinitions addObject:[result objectForKey:@"definition"]];
        }
        if ([playView respondsToSelector:@selector(setWordDefinitions:)]) {
            [playView performSelector:@selector(setWordDefinitions:) withObject:allWordDefinitions];
        }
        if ([playView respondsToSelector:@selector(setWords:)]) {
            [playView performSelector:@selector(setWords:) withObject:allWords];
        }
        if ([playView respondsToSelector:@selector(setProgressSession:)]) {
            [playView performSelector:@selector(setProgressSession:) withObject:self.progressSession];
        }
        if ([playView respondsToSelector:@selector(setReview:)]) {
            [playView performSelector:@selector(setReview:) withObject:[NSNumber numberWithInt:1]];
        }
        UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, playView, nil];
        self.splitViewController.viewControllers = viewControllers;
    }

    if (indexPath.item == 2) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"MainStoryboard" bundle:[NSBundle mainBundle]];
        
        UIViewController *playView = [storyboard instantiateViewControllerWithIdentifier:@"testView"];
        if ([playView respondsToSelector:@selector(setWordDefinitions:)]) {
            [playView performSelector:@selector(setWordDefinitions:) withObject:self.wordDefinitions];
        }
        if ([playView respondsToSelector:@selector(setWords:)]) {
            [playView performSelector:@selector(setWords:) withObject:self.words];
        }
        if ([playView respondsToSelector:@selector(setProgressSession:)]) {
            [playView performSelector:@selector(setProgressSession:) withObject:self.progressSession];
        }
        if ([playView respondsToSelector:@selector(setReview:)]) {
            [playView performSelector:@selector(setReview:) withObject:[NSNumber numberWithInt:0]];
        }
        UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, playView, nil];
        self.splitViewController.viewControllers = viewControllers;
    }
    if (indexPath.item == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"MainStoryboard" bundle:[NSBundle mainBundle]];
        
        UIViewController *playView = [storyboard instantiateViewControllerWithIdentifier:@"playView"];
        if ([playView respondsToSelector:@selector(setWordDefinitions:)]) {
            [playView performSelector:@selector(setWordDefinitions:) withObject:self.wordDefinitions];
        }
        if ([playView respondsToSelector:@selector(setWords:)]) {
            [playView performSelector:@selector(setWords:) withObject:self.words];
        }
        if ([playView respondsToSelector:@selector(setProgressSession:)]) {
            [playView performSelector:@selector(setProgressSession:) withObject:self.progressSession];
        }

        UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, playView, nil];
        self.splitViewController.viewControllers = viewControllers;
    }
    if (indexPath.item == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"MainStoryboard" bundle:[NSBundle mainBundle]];
        
        UIViewController *learnView = [storyboard instantiateViewControllerWithIdentifier:@"learnView"];
        UIViewController *navigationViewController = [self.splitViewController.viewControllers objectAtIndex:0];
        NSArray *viewControllers = [[NSArray alloc] initWithObjects:navigationViewController, learnView, nil];
        self.splitViewController.viewControllers = viewControllers;
    }
}

@end
