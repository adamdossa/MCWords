//
//  MCWordsTBC.m
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "LearnTabBarVC.h"
#import <WordnikUI/WNDefinitionViewController.h>
#import <Wordnik/WNClient.h>
#import <Wordnik/WNCompositeWordDataSource.h>

@interface LearnTabBarVC ()
@property (nonatomic, strong) WNCompositeWordDataSource *dataSource;
@property (nonatomic, strong) WNClient *client;
@property (nonatomic, strong) WNDefinitionViewController *wordNikController;
@property (nonatomic, strong) NSString *detailedWord;
@end

@implementation LearnTabBarVC
- (void) setWord:(NSString *)word
{
    _word = word;
    NSMutableArray *newControllers = [[NSMutableArray alloc] init];
    for (UIViewController *controller in self.viewControllers) {
        if ([controller isKindOfClass:[WNDefinitionViewController class]]) {
            if (!self.wordNikController) {
                self.wordNikController = [[WNDefinitionViewController alloc] initWithWord:self.word dataSource:self.dataSource];
                self.wordNikController.title = @"Detailed Definitions";
                [newControllers addObject:self.wordNikController];
                self.detailedWord = self.word;
            } else {
                if ([self.detailedWord isEqualToString:self.word]) {
                    [newControllers addObject:self.wordNikController];
                } else {
                    self.wordNikController = [[WNDefinitionViewController alloc] initWithWord:self.word dataSource:self.dataSource];
                    self.wordNikController.title = @"Detailed Definitions";
                    [newControllers addObject:self.wordNikController];
                    self.detailedWord = self.word;                    
                }
            }
        } else {
            [newControllers addObject:controller];
        }
    }
    self.viewControllers = newControllers;
    for (UIViewController *controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(setWord:)]) {
            [controller performSelector:@selector(setWord:) withObject:self.word];
        }
        if ([controller respondsToSelector:@selector(setClient:)]) {
            [controller performSelector:@selector(setClient:) withObject:self.client];
        }
    }
}

- (void) setDefinition:(NSString *)definition
{
    _definition = definition;
    for (UIViewController *controller in self.viewControllers) {
        if ([controller respondsToSelector:@selector(setDefinition:)]) {
            [controller performSelector:@selector(setDefinition:) withObject:self.definition];
        }
    }
    
}

- (WNCompositeWordDataSource*) dataSource
{
    if (!_dataSource) {
        _dataSource = [[WNCompositeWordDataSource alloc] init];
        WNWordNetworkDataSource *networkDataSource = [[WNWordNetworkDataSource alloc] initWithWordnikClient: self.client];
        
        [_dataSource addNetworkDataSource: networkDataSource];
        
        NSString *path=[[NSBundle mainBundle] pathForResource:@"OfflineDatabase" ofType: @"wordnik"];
        
        WNLocalWordDataSource *localDataSource=[[WNLocalWordDataSource alloc] initWithPath:path] ;
        
        if (localDataSource!=nil) {
            [_dataSource addLocalDataSource: localDataSource];
        }

    }
    return _dataSource;
}

- (WNClient*) client
{
    if (!_client) {
        WNClientConfig *config = [WNClientConfig configWithAPIKey: @"86b22adc955443033bb0d52d812020a6bfcf75351c2d08a2c" ];
        _client = [[WNClient alloc] initWithClientConfig: config];
    }
    return _client;
}

@end
