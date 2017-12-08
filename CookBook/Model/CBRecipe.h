//
//  CBRecipe.h
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/2/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kTitleKey = @"TitleKey";
static NSString * const kContentKey = @"ContentKey";
static NSString * const kImageKey = @"ImageKey";

@interface CBRecipe : NSObject
@property (strong, nonatomic) NSString* title;  //the title of the recipe
@property (strong, nonatomic) NSString* content;    //the content of the recipe
@property (strong, nonatomic) NSString* image;  //the image of the recipe

// Initializing the recipe
- (instancetype) initWithTitle: (NSString *) title
                       content: (NSString *) content
                         image: (NSString *) image;

//convert for plist
- (NSDictionary *) convertForPList;

@end
