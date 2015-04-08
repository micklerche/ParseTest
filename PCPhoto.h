//
//  PCPhoto.h
//  POC_ParsePhoto
//
//  Created by Mick Lerche on 4/7/15.
//  Copyright (c) 2015 Mick Lerche. All rights reserved.
//

#import <Parse/Parse.h>

@interface PCPhoto : PFObject <PFSubclassing>
+ (NSString *)parseClassName;

@property NSString *photoID;
@property NSString *username;
@property NSString *comment;
@property NSDate *date;
@property PFGeoPoint *photolocation;
@property PFFile *originalImage;
@property PFFile *thumbnailImage;
@property NSSet *tags;
@property int likes;


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;







@end
