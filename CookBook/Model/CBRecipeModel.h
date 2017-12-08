//
//  CBRecipeModel.h
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/2/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBRecipe.h"

@interface CBRecipeModel : NSObject
// Creating the model
+ (instancetype) sharedModel;

// Accessing number of Recipes in model
- (NSUInteger) numberOfRecipe;

// Accessing a recipe
- (CBRecipe *) recipeAtIndex: (NSUInteger) index;

// Inserting a recipe
- (void) insertWithTitle: (NSString *) title
                 content: (NSString *) content
                   image: (NSString *) image;

// Update a recipe
- (void) UpdateWithTitle: (NSString *) title
                 content: (NSString *) content
                   image: (NSString *) image
                   index: (NSUInteger) index;

// Removing a recipe
- (void) removeRecipeAtIndex: (NSUInteger) index;
@end
