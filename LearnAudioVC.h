//
//  LearnAudioVC.h
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Wordnik/WNClient.h>

@interface LearnAudioVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) WNClient *client;
@property (nonatomic, strong) NSString *word;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
