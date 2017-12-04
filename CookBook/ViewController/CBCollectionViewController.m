//
//  CBCollectionViewController.m
//  CookBook
//
//  Created by Xiaoxi Dai on 12/3/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBCollectionViewController.h"
#import "CBCollectionViewCell.h"
#import "CBWebViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface CBCollectionViewController ()

@property (strong, nonatomic) NSMutableDictionary *popularRecipes;
@end

@implementation CBCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    self.popularRecipes = [[NSMutableDictionary alloc] init];
    
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                    initWithGraphPath:@"christinesrecipes.zh/feed?limit=12" parameters:@{@"fields": @"picture,id"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe
         completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             self.popularRecipes = result;
             [self.collectionView reloadData];
             NSLog(@"%lu", [[[self.popularRecipes objectForKey:@"data"] valueForKey:@"picture"] count]);
             //NSLog(@"%@", [[[self.popularRecipes objectForKey:@"data"]valueForKey:@"picture"]objectAtIndex:0]);
             //             NSLog(@"%@", [[result objectForKey:@"data"]valueForKey:@"picture"]);
             //             NSLog(@"%@", [[result objectForKey:@"data"]valueForKey:@"id"]);
         }];
    [connection start];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //Get selected item
    NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
    NSIndexPath *ip = selectedItems[0];
    NSString *recipe = [[[self.popularRecipes objectForKey:@"data"]valueForKey:@"id"] objectAtIndex:ip.item];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CBWebViewController *wvc = [segue destinationViewController];
    wvc.websiteString = [NSString stringWithFormat:@"https://www.facebook.com/%@",recipe];
}
- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender {
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                    initWithGraphPath:@"christinesrecipes.zh/feed?limit=12" parameters:@{@"fields": @"picture,id"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe
         completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             self.popularRecipes = result;
             [self.collectionView reloadData];
             NSLog(@"%lu", [[[self.popularRecipes objectForKey:@"data"] valueForKey:@"picture"] count]);
             //NSLog(@"%@", [[[self.popularRecipes objectForKey:@"data"]valueForKey:@"picture"]objectAtIndex:0]);
             //             NSLog(@"%@", [[result objectForKey:@"data"]valueForKey:@"picture"]);
             //             NSLog(@"%@", [[result objectForKey:@"data"]valueForKey:@"id"]);
         }];
    [connection start];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return [[[self.popularRecipes objectForKey:@"data"] valueForKey:@"picture"] count];
    return 12;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell
    //NSLog(@"%@", self.popularRecipes);
    NSString *recipe = [[[self.popularRecipes objectForKey:@"data"]valueForKey:@"picture"] objectAtIndex:indexPath.item];
    if(recipe)
    {
        [cell setupCell:recipe];
    }
    else
    {
        [cell setupCell:@""];
    }
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
