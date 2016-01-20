//
//  PlayAnswerVC.h
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayAnswerVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSArray *wordDefinitions;
@end
