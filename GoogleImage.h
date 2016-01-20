//
//  GoogleImage.h
//  Image Search
//
//  Created by James Hildensperger on 7/15/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleImage : NSObject
@property (nonatomic, readonly, strong) NSString  *title;
@property (nonatomic, readonly, strong) UIImage   *image;

- (id)initWithDictionary:(NSDictionary*)dictionary;
+(GoogleImage*)googleImageWithDictionary:(NSDictionary*)dictionary;
+(NSArray*)googleImagesWithDictionaries:(NSArray*)dictionaries;
@end
