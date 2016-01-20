//
//  LearnWebVC.h
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnWebVC : UIViewController
@property (nonatomic, strong) NSString *word;
@property (weak, nonatomic) IBOutlet UIWebView *bbcWebView;
@property (weak, nonatomic) IBOutlet UIWebView *twitterWebView;
@end
