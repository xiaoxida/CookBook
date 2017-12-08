//
//  CBCollectionViewCell.m
//  CookBook
//
//  Created by Xiaoxi Dai on 12/4/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBCollectionViewCell.h"

@interface CBCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation CBCollectionViewCell
- (void) setupCell: (NSString *) cell {
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: cell]];
    self.imageView.image = [UIImage imageWithData: imageData];
}
@end
