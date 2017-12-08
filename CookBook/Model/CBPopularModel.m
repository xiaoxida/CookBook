//
//  CBPopularModel.m
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/7/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBPopularModel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface CBPopularModel ()
@property (strong, nonatomic) NSMutableArray *popularRecipes;
@end

@implementation CBPopularModel

+ (instancetype) sharedModel
{
    static CBPopularModel *_sharedModel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //request the photos from "christinesrecipes.zh", 286033133315 is the album id
        FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                        initWithGraphPath:@"286033133315/photos" parameters:@{@"fields": @"source"}];
        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
        [connection addRequest:requestMe
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 //load the photo from result
                 self.popularRecipes = [result objectForKey:@"data"];
             }];
        [connection start];
    }
    return self;
}

- (instancetype) initWithArray:(NSMutableArray *) otherArray
{
    self = [super init];
    if(self)
    {
        _popularRecipes = [[NSMutableArray alloc] initWithArray:otherArray];
    }
    return self;
}


- (NSUInteger) numberOfPopulars {
    return [self.popularRecipes count];
}

- (NSDictionary *) getPopularAtIndex: (NSUInteger) index {
    NSDictionary *recipe = [self.popularRecipes objectAtIndex:index];
    return recipe;
}
@end
