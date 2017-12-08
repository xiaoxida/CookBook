//
//  CBPopularModel.h
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/7/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPopularModel : NSObject

+ (instancetype) sharedModel;

//initalize the model with NSMutableArray
- (instancetype) initWithArray: (NSMutableArray*) otherArray;

//the number of popular photos
- (NSUInteger) numberOfPopulars;

//get the photo(include the url of the photo and the id of the photo)
- (NSDictionary *) getPopularAtIndex: (NSUInteger) index;

@end
