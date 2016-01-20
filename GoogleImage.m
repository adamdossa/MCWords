//
//  GoogleImage.m
//  Image Search
//
//  Created by James Hildensperger on 7/15/12.
//  Copyright (c) 2012 James Hildensperger. All rights reserved.
//

#import "GoogleImage.h"

@interface GoogleImage()
@property (nonatomic, readwrite, strong) NSString  *title;
@property (nonatomic, readwrite, strong) NSString  *imageUrl;
@property (nonatomic, readwrite, strong) NSString  *imageId;
@property (nonatomic, readwrite, strong) UIImage   *image;
@end

@implementation GoogleImage
@synthesize title           = _title;
@synthesize imageUrl        = _imageUrl;
@synthesize imageId         = _imageId;
@synthesize image           = _image;

- (id)initWithDictionary:(NSDictionary*)dictionary;
{
    if(self = [super init])
    {
        self.title          = [dictionary objectForKey:@"titleNoFormatting"];
        self.imageUrl       = [dictionary objectForKey:@"tbUrl"];
        self.imageId        = [dictionary objectForKey:@"imageId"];
        self.image          = [self cacheImage:self.imageId];

    }
    return self;
}

- (UIImage *)cacheImage:(NSString *)imageId
{
    NSArray *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *imagePath     = [[cacheDirectory objectAtIndex:0] stringByAppendingPathComponent:imageId];
    
    UIImage *image;

    if([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    else
    {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageUrl]];
        image = [UIImage imageWithData:data];
        
        NSError *error = nil;
        
        [data writeToFile:imagePath options:NSDataWritingAtomic error:&error];
        
        if (error) 
        {
            NSLog(@"Error writing - %@", error);
        }
    }
    return image;
}

+(GoogleImage *)googleImageWithDictionary:(NSDictionary *)dictionary
{
    GoogleImage *newGoogleImage = [[GoogleImage alloc] initWithDictionary:dictionary];
    return newGoogleImage;
}

+(NSArray *)googleImagesWithDictionaries:(NSArray *)dictionaries
{
    
    NSMutableArray *tempGoogleImages = [NSMutableArray array];
    for(NSDictionary *dictionary in dictionaries)
    {
        [tempGoogleImages addObject:[[self class] googleImageWithDictionary:dictionary]];
    }
    NSArray *newGoogleImages = [NSArray arrayWithArray:tempGoogleImages];
    return newGoogleImages;
}

@end
