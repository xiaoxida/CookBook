//
//  CBPopularModel.m
//  CookBook
//
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
        FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                        initWithGraphPath:@"286033133315/photos" parameters:@{@"fields": @"source"}];
        FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
        [connection addRequest:requestMe
             completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 NSLog(@"%@", result);
                 self.popularRecipes = [result objectForKey:@"data"];
                 //NSLog(@"%@", result);
                 //NSLog(@"%@", [result objectForKey:@"data"]);
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
