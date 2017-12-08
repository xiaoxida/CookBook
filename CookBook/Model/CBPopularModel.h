//
//  CBPopularModel.h
//  CookBook
//
//  Created by Xiaoxi Dai on 12/7/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPopularModel : NSObject
+ (instancetype) sharedModel;

- (instancetype) initWithArray: (NSMutableArray*) otherArray;

- (NSUInteger) numberOfPopulars;

- (NSDictionary *) getPopularAtIndex: (NSUInteger) index;

@end
