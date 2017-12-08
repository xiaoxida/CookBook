//
//  CBProfileViewController.m
//  CookBook
//
//  Created by Xiaoxi Dai on 12/3/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBProfileViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface CBProfileViewController ()
@property (weak, nonatomic) IBOutlet FBSDKProfilePictureView *profilePictureView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) NSString *myUrl;
@property (nonatomic, strong) FBSDKGraphRequest *request;
@property (strong, nonatomic) NSArray *friendList;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *postsLabel;
@end

@implementation CBProfileViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.profilePictureView.profileID = @"me";
    [self.titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLink:)]];
    [self updateContent:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateContent:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
}

- (void) updateContent:(NSNotification *)notification
{
    if ([FBSDKAccessToken currentAccessToken]) {
        self.titleLabel.hidden = NO;
        self.friendsLabel.hidden = NO;
        self.postsLabel.hidden = NO;
        self.titleLabel.text = [FBSDKProfile currentProfile].name;
        self.myUrl = [FBSDKProfile currentProfile].linkURL.absoluteString;
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"friends,feed"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 //NSLog(@"User total friends : %@",[result valueForKey:@"feed"]);
                 //NSLog(@"User total friends : %lu", [[[result valueForKey:@"feed"]objectForKey:@"data"] count]);
                 self.friendsLabel.text = [NSString stringWithFormat:@"%@ friends", [[[result valueForKey:@"friends"]objectForKey:@"summary"]valueForKey:@"total_count"]];
                 self.postsLabel.text = [NSString stringWithFormat:@"%lu posts", [[[result valueForKey:@"feed"]objectForKey:@"data"] count]];
             }
         }];
    } else {
        self.titleLabel.hidden = YES;
        self.friendsLabel.hidden = YES;
        self.postsLabel.hidden = YES;
        self.myUrl = @"";
    }
}

- (void)tapLink:(UITapGestureRecognizer *)gesture
{
    if ([FBSDKAccessToken currentAccessToken]) {
        NSURL *url = [NSURL URLWithString:self.myUrl];
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
