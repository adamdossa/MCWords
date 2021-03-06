//
//  LearnImagesVC.h
//  MCWords
//
//  Created by Adam Dossa on 08/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LearnImagesVC : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSString *word;
@property (nonatomic, strong) NSMutableArray *googleResponses;
@property (nonatomic, strong) NSArray *userResponses;
@property (nonatomic, strong) NSMutableArray *userSelectedCells;
@end
