//
//  GoogleImageInfo.m
//  MCWords
//
//  Created by Adam Dossa on 09/05/2013.
//  Copyright (c) 2013 Adam Dossa. All rights reserved.
//

#import "GoogleImageInfo.h"

@implementation GoogleImageInfo

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRect:self.bounds];
    if (self.userSelected) {
        [[UIColor redColor] setStroke];
        roundedRect.lineWidth = 6.0;
    } else {
        [[UIColor blackColor] setStroke];
        roundedRect.lineWidth = 3.0;
    }
    [roundedRect stroke];
}

@end
