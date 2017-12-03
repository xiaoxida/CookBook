//
//  CBRecipeModel.m
//  CookBook
//
//  Created by Xiaoxi Dai on 12/2/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBRecipeModel.h"

@interface CBRecipeModel ()
@property (strong, nonatomic) NSMutableArray* recipes;
@property (strong, nonatomic) NSString* filepath;
@end

@implementation CBRecipeModel
// Creating the model

- (instancetype)init
{
    self = [super init];
    if (self) {
        // find the Documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDirectory = paths[0];
        NSLog(@"docDir = %@", documentsDirectory);
        
        self.filepath = [documentsDirectory stringByAppendingPathComponent:@"recipes.plist"];
        NSLog(@"filepath = %@", self.filepath);
        
        NSMutableArray *cards = [NSMutableArray arrayWithContentsOfFile:self.filepath];
        
        if(!cards)
        {
            _recipes = [[NSMutableArray alloc] init];
        }
        else    //convert cards
        {
            _recipes = [[NSMutableArray alloc] init];
            if([cards count] != 0)
            {
                for(NSDictionary* card in cards)
                {
                    CBRecipe* recipe = [[CBRecipe alloc] initWithTitle:[card objectForKey:kTitleKey]
                                                               content:[card objectForKey:kContentKey]
                                                                 image:[card objectForKey:kImageKey]];
                    [_recipes addObject:recipe];
                }
            }
        }
    }
    return self;
}

+ (instancetype) sharedModel
{
    static CBRecipeModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

// Accessing number of Recipes in model
- (NSUInteger) numberOfRecipe
{
    return [self.recipes count];
}

- (CBRecipe *) recipeAtIndex: (NSUInteger) index
{
    return [self.recipes objectAtIndex:index];
}

// Inserting a recipe
- (void) insertWithTitle: (NSString *) title
                 content: (NSString *) content
                 image: (NSString *)image
{
    CBRecipe* newRecipe = [[CBRecipe alloc] initWithTitle:title content:content image:image];
    [self.recipes insertObject:newRecipe atIndex:0];
    [self save];
}

- (void) UpdateWithTitle: (NSString *) title
                 content: (NSString *) content
                   image: (NSString *)image
                   index: (NSUInteger) index
{
    CBRecipe* newRecipe = [[CBRecipe alloc] initWithTitle:title content:content image:image];
    [self.recipes replaceObjectAtIndex:index withObject:newRecipe];
    [self save];
}

// Removing a recipe
- (void) removeRecipeAtIndex: (NSUInteger) index
{
    if(index < [self.recipes count])
    {
        [self.recipes removeObjectAtIndex:index];
        [self save];
    }
}

- (void) save {
    NSMutableArray *recipes = [[NSMutableArray alloc] init];
    
    for (CBRecipe* recipe in self.recipes) {
        NSDictionary *recipeD = [recipe convertForPList];
        [recipes addObject: recipeD];
    }
    
    [recipes writeToFile: self.filepath atomically:YES];
}

@end
