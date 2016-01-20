//
//  LearnImagesVC.m
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "LearnImagesVC.h"
#import <Parse/Parse.h>
#import "GoogleImage.h"
#import "GoogleImageInfo.h"

@interface LearnImagesVC ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *userCollectionView;
@property int pageNumber;

@end

@implementation LearnImagesVC

- (NSMutableArray *) googleResponses
{
    if (!_googleResponses) {
        _googleResponses = [[NSMutableArray alloc] init];
    }
    return _googleResponses;
}

- (NSArray *) userResponses
{
    if (!_userResponses) {
        _userResponses = [[NSArray alloc] init];
    }
    return _userResponses;
}

- (NSMutableArray *) userSelectedCells
{
    if (!_userSelectedCells) {
        _userSelectedCells = [[NSMutableArray alloc] init];
    }
    return _userSelectedCells;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection = TRUE;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.userSelectedCells = nil;
    [self refreshView];
}

- (void)setWord:(NSString *)word
{
    _word = word;
    self.googleResponses = nil;
    self.userResponses = nil;
    self.userSelectedCells = nil;
    [self refreshView];
}

- (void)refreshView
{
    if (self.word) {
        [self.collectionView reloadData];
        if (![self.googleResponses count]) {
            [self getGoogleImagesForQuery:self.word withPage:0];
        }
        //Also reload user images
        PFQuery *query = [PFQuery queryWithClassName:@"WordImage"];
        [query whereKey:@"word" equalTo:self.word];
        self.userResponses = [query findObjects];
        [self.userCollectionView reloadData];
    }
}

- (void)getGoogleImagesForQuery:(NSString*)query withPage:(int)page
{
    int firstImageNumber = page * 6;
    self.pageNumber = page;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=6&q=%@&start=%i",query, firstImageNumber]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *opQue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:opQue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) NSLog(@"error");
        else if (data)
        {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (![[responseDict objectForKey:@"responseDetails"] isKindOfClass:[NSNull class]])
            {
                NSString *errorMessage;
                if ([[responseDict objectForKey:@"responseStatus"] isEqualToNumber:[NSNumber numberWithInt:400]])
                {
                    errorMessage = @"Google's API limits the number of results for image searches";
                }
                else
                {
                    errorMessage = [NSString stringWithFormat:@"Google's API has returned the following error \nError Code: %@ \n%@",[responseDict objectForKey:@"responseStatus"],[responseDict objectForKey:@"responseDetails"]];
                }
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            }
            
            else if ([[[responseDict objectForKey:@"responseData"] objectForKey:@"results"] count] == 0)
            {
                NSString *errorMessage = @"Your search has no results";
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            }
            
            else
            {
                NSArray *googleImages = [GoogleImage googleImagesWithDictionaries:[[responseDict objectForKey:@"responseData"] objectForKey:@"results"]];
                [self.googleResponses addObjectsFromArray:googleImages];
                [self.collectionView reloadData];
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        GoogleImageInfo *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"GoogleImageInfo" forIndexPath:indexPath];
        GoogleImage *image = self.googleResponses[indexPath.item];
        cell.imageView.image = image.image;
        if ([self.userSelectedCells containsObject:image]) {
            cell.userSelected = TRUE;
            cell.selected = TRUE;
        } else {
            cell.userSelected = FALSE;
            cell.selected = FALSE;
        }
        [cell setNeedsDisplay];
        return cell;
    } else {
        GoogleImageInfo *cell = [self.userCollectionView dequeueReusableCellWithReuseIdentifier:@"UserImageInfo" forIndexPath:indexPath];
        PFObject *result = self.userResponses[indexPath.item];
        PFFile *imageFile = [result objectForKey:@"imageFile"];
        cell.imageView.image = [UIImage imageWithData:[imageFile getData]];
        cell.userSelected = FALSE;
        cell.selected = FALSE;
        [cell setNeedsDisplay];
        return cell;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.collectionView]) {
        return [self.googleResponses count];
    } else {
        return [self.userResponses count];
    }
}

- (IBAction)loadMore:(UIButton *)sender {
    [self getGoogleImagesForQuery:self.word withPage:self.pageNumber + 1];
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        [self.userSelectedCells addObject:self.googleResponses[indexPath.item]];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        GoogleImageInfo *googleCell = (GoogleImageInfo*) cell;
        googleCell.userSelected = TRUE;
        googleCell.selected = TRUE;
        [googleCell setNeedsDisplay];
    }
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:self.collectionView]) {
        [self.userSelectedCells removeObject:self.googleResponses[indexPath.item]];
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        GoogleImageInfo *googleCell = (GoogleImageInfo*) cell;
        googleCell.userSelected = FALSE;
        googleCell.selected = FALSE;
        [googleCell setNeedsDisplay];
    }
}
- (IBAction)saveSelected:(UIButton *)sender {
    //Save selected images to parse.com
    for (GoogleImage *image in self.userSelectedCells) {
        UIImage *saveImage = image.image;
        NSData *saveData = UIImagePNGRepresentation(saveImage);
        PFFile *saveFile = [PFFile fileWithData:saveData];
        PFObject *object = [PFObject objectWithClassName:@"WordImage"];
        [object setObject:saveFile forKey:@"imageFile"];
        [object setObject:self.word forKey:@"word"];
        [object save];
    }
    [self refreshView];
}

@end
