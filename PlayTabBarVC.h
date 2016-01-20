//
//  PlayTabBarVC.h
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayTabBarVC : UITabBarController
@property (nonatomic, strong) NSArray *words; //of NSString
@property (nonatomic, strong) NSArray *wordDefinitions;
@end
