//
//  PlayTabBarVC.m
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "PlayTabBarVC.h"

@interface PlayTabBarVC ()

@end

@implementation PlayTabBarVC

- (void) setWords:(NSArray *)words
{
    _words = words;
    for (UIViewController *controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(setWords:)]) {
            [controller performSelector:@selector(setWords:) withObject:self.words];
        }
        if ([controller respondsToSelector:@selector(setWordDefinitions:)]) {
            [controller performSelector:@selector(setWordDefinitions:) withObject:self.wordDefinitions];
        }
    }
    
}

@end
