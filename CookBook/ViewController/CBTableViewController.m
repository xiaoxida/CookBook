//
//  CBTableViewController.m
//  CookBook
//
//  Created by Xiaoxi Dai on 12/2/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBTableViewController.h"
#import "../Model/CBRecipeModel.h"
#import "CBAddRecipeViewController.h"

@interface CBTableViewController ()
@property (strong, nonatomic) CBRecipeModel* recipeModel;
@property (nonatomic, assign) NSInteger row;
@end

@implementation CBTableViewController
NSTimeInterval lastClick;
NSIndexPath *lastIndexPath;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.recipeModel = [CBRecipeModel sharedModel];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(tappedOnce:)];
    [self.tableView addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(tappedTwice:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.tableView addGestureRecognizer:doubleTap];
    [singleTap requireGestureRecognizerToFail:doubleTap];
}

- (void) tappedOnce: (UITapGestureRecognizer *) recognizer {
    if (UIGestureRecognizerStateEnded == recognizer.state)
    {
        CGPoint p = [recognizer locationInView:recognizer.view];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];
        self.row = indexPath.row;
        // Do your stuff
        [self performSegueWithIdentifier:@"ShowDetail" sender:self.tableView];
    }
}

- (void) tappedTwice: (UITapGestureRecognizer *) recognizer {
    if (UIGestureRecognizerStateEnded == recognizer.state)
    {
        CGPoint p = [recognizer locationInView:recognizer.view];
        NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:p];
        self.row = indexPath.row;
        // Do your stuff
        // Assuming you have a UIImage reference
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = paths[0];
        CBRecipe *selectedRecipe = [self.recipeModel recipeAtIndex:self.row];
        NSString *helper = [[NSString alloc] initWithFormat:@"%@", selectedRecipe.image];
        NSString *filepath = [documentsDirectory stringByAppendingPathComponent:helper];
        //NSLog(@"%@", self.imageText);
        UIImage* tempImage = [UIImage imageWithContentsOfFile:filepath];
        
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[[FBSDKSharePhoto photoWithImage:tempImage userGenerated:YES] ];
        
        // Assuming self implements <FBSDKSharingDelegate>
        [FBSDKShareAPI shareWithContent:content delegate:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recipeModel numberOfRecipe];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell" forIndexPath:indexPath];
    // Configure the cell...
    NSString *tableCellText;
    CBRecipe *recipe = [self.recipeModel recipeAtIndex: indexPath.row];
    tableCellText = [NSString stringWithFormat: @"%@", [recipe title]];
    cell.textLabel.text = tableCellText;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.recipeModel removeRecipeAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.row = indexPath.row;
    [self performSegueWithIdentifier:@"ShowDetail" sender:tableView];
}*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    CBAddRecipeViewController *addRecipe = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"ShowDetail"]) {
        CBRecipe *recipe = [self.recipeModel recipeAtIndex: self.row];
        addRecipe.titleText = recipe.title;
        addRecipe.contentText = recipe.content;
        addRecipe.imageText = recipe.image;
    }
    
    // set completion block for AddViewController
    addRecipe.addRecipe = ^(NSString *title, NSString *content, NSString *imagePath) {
        if (title.length > 0 && content.length > 0) {
            if([segue.identifier isEqualToString:@"ShowDetail"])
            {
                [self.recipeModel UpdateWithTitle:title content:content image: imagePath index:self.row];
            }
            else
            {
                [self.recipeModel insertWithTitle:title content:content image:imagePath];
            }
            // update table view
            [self.tableView reloadData];
        }
        // Make the view controller go away
        [self dismissViewControllerAnimated:YES completion:nil];
    };
}


@end
