//
//  CBRecipe.m
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/2/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBRecipe.h"

@implementation CBRecipe
- (instancetype) initWithTitle: (NSString *) title
                       content: (NSString *) content
                         image:  (NSString *)image
{
    self = [super init];
    if (self) {
        _title = title;
        _content = content;
        _image = image;
    }
    return self;
}
- (NSDictionary *) convertForPList
{
    NSDictionary *recipe = [NSDictionary dictionaryWithObjectsAndKeys:
                           self.title, kTitleKey,
                           self.content, kContentKey,
                           self.image, kImageKey,
                           nil];
    return recipe;
}
@end
