//
//  LearnAudioVC.m
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "LearnAudioVC.h"
#import <AVFoundation/AVFoundation.h>

@interface LearnAudioVC ()
@property (nonatomic, strong) NSArray *audioTableData;
@property (nonatomic, strong) NSArray *audioURLData;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@end

@implementation LearnAudioVC

- (NSArray*) audioTableData
{
    if (!_audioTableData) {
        _audioTableData = [[NSArray alloc] init];
    }
    return _audioTableData;
}

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
        NSArray *elements = [NSArray arrayWithObjects:
                             [WNAudioFileMetadataRequest request],
                             nil];
        
        WNWordRequest *req = [WNWordRequest requestWithWord: self.word
                                       requestCanonicalForm: YES
                                 requestSpellingSuggestions: NO
                                            elementRequests: elements];

        [self.client wordWithRequest:req completionBlock: ^(WNWordResponse *response, NSError *error) {
            WNWordObject *word = response.wordObject;
            if(word.audioFileMetadata != nil){
                NSMutableArray *tempTable = [[NSMutableArray alloc] init];
                NSMutableArray *tempURL = [[NSMutableArray alloc] init];
                for(WNAudioFileMetadata *meta in word.audioFileMetadata){
                    [tempTable addObject:meta.createdBy];
                    [tempURL addObject:meta.fileUrl];
                }
                self.audioTableData = tempTable;
                self.audioURLData = tempURL;
            }
            [self.tableView reloadData];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.audioTableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AudioInfo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *audioText = self.audioTableData[indexPath.item];
    cell.textLabel.text = audioText;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSURL *fileURL = [NSURL URLWithString:self.audioURLData[indexPath.item]];
    NSData *fileData = [NSData dataWithContentsOfURL:fileURL];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    //audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    
}

@end
