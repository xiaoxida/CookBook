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
#import "CBPopularModel.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface CBCollectionViewController ()
//@property (strong, nonatomic) NSMutableDictionary *popularRecipes;
@property (strong, nonatomic) CBPopularModel *popularModel;
@end

@implementation CBCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.popularModel = [CBPopularModel sharedModel];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView reloadData];
    });
    NSLog(@"%lu", [self.popularModel numberOfPopulars]);
    /*
    self.popularRecipes = [[NSMutableDictionary alloc] init];
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                    initWithGraphPath:@"286033133315/photos" parameters:@{@"fields": @"source"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe
         completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             self.popularRecipes = result;
             [self.collectionView reloadData];
             //NSLog(@"%@", result);
             //NSLog(@"%@", [result objectForKey:@"data"]);
             //NSLog(@"%@", [[[result objectForKey:@"photos"] valueForKey:@"data"] objectAtIndex:0]);
         }];
    [connection start];*/
    
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
    //NSString *recipe = [[[self.popularRecipes objectForKey:@"data"]valueForKey:@"id"] objectAtIndex:ip.item];
    NSDictionary *tempRecipe = [self.popularModel getPopularAtIndex:ip.item];
    NSString *recipe = [tempRecipe valueForKey:@"id"];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CBWebViewController *wvc = [segue destinationViewController];
    wvc.websiteString = [NSString stringWithFormat:@"https://www.facebook.com/%@",recipe];
}
- (IBAction)refreshButtonPressed:(UIBarButtonItem *)sender {
    if (![FBSDKAccessToken currentAccessToken])
    {
        return;
    }
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]
                                    initWithGraphPath:@"286033133315/photos" parameters:@{@"fields": @"source"}];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    [connection addRequest:requestMe
         completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             NSLog(@"%@", result);
             self.popularModel = [[CBPopularModel alloc] initWithArray: [result objectForKey:@"data"]];
             NSLog(@"%@", result);
             NSLog(@"%lu", [self.popularModel numberOfPopulars]);
             [self.collectionView reloadData];
         }];
    [connection start];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //return [[[self.popularRecipes objectForKey:@"data"] valueForKey:@"picture"] count];
    //return 12;
    return [self.popularModel numberOfPopulars];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell
    //NSLog(@"%@", self.popularRecipes);
    NSDictionary *recipe = [self.popularModel getPopularAtIndex:indexPath.item];
    NSString *imageUrl = [recipe objectForKey:@"source"];
   //NSString *recipe = [[[self.popularRecipes objectForKey:@"data"]valueForKey:@"picture"] objectAtIndex:indexPath.item];
    [cell setupCell:imageUrl];
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
