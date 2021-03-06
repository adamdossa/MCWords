//
//  MCWordsTableVC.h
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StudyWordsTableVC : UITableViewController
@property (nonatomic, strong) NSArray *words;
@property (nonatomic, strong) NSArray *wordDefinitions;
@property (nonatomic, strong) NSNumber *progressSession;
@end
