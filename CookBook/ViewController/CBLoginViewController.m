//
//  ViewController.m
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/1/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBLoginViewController.h"
#import "CBPopularModel.h"

@interface CBLoginViewController ()
@property (strong, nonatomic) CBPopularModel *popularModel;
@end

@implementation CBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //help change the title
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    //ask for permission
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_posts",@"user_photos"];
    self.loginButton.publishPermissions = @[@"publish_actions"];
    self.loginButton.loginBehavior = FBSDKLoginBehaviorWeb;
    // If there's already a cached token, read the profile information.
    if ([FBSDKAccessToken currentAccessToken]) {
        [self observeProfileChange:nil];
    }
    else
    {
        [self observeTokenChange:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Observations

- (void)observeProfileChange:(NSNotification *)notfication {
    if ([FBSDKProfile currentProfile]) {
        NSString *title = [NSString stringWithFormat:@"Continue as %@", [FBSDKProfile currentProfile].name];
        [self.continueButton setTitle:title forState:UIControlStateNormal];
        self.popularModel = [CBPopularModel sharedModel];
    }
}

- (void)observeTokenChange:(NSNotification *)notfication {
    if (![FBSDKAccessToken currentAccessToken]) {
        [self.continueButton setTitle:@"Continue as guest" forState:UIControlStateNormal];
    } else {
        [self observeProfileChange:nil];
    }
}

@end
