//
//  CBRecipe.h
//  CookBook
//
//  Created by Xiaoxi Dai on 12/2/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kTitleKey = @"TitleKey";
static NSString * const kContentKey = @"ContentKey";
static NSString * const kImageKey = @"ImageKey";

@interface CBRecipe : NSObject
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* content;
@property (strong, nonatomic) NSString* image;

// Initializing the flashcard
- (instancetype) initWithTitle: (NSString *) title
                       content: (NSString *) content
                         image: (NSString *) image;

- (NSDictionary *) convertForPList;

@end
