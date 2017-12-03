//
//  ViewController.m
//  CookBook
//
//  Created by Xiaoxi Dai on 12/1/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBLoginViewController.h"

@interface CBLoginViewController ()

@end

@implementation CBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.loginBehavior = FBSDKLoginBehaviorWeb;
    // If there's already a cached token, read the profile information.
    if ([FBSDKAccessToken currentAccessToken]) {
        [self observeProfileChange:nil];
    }
    else
    {
        [self observeTokenChange:nil];
    }
    // Do any additional setup after loading the view, typically from a nib.
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
//    // Optional: Place the button in the center of your view.
//    loginButton.center = self.view.center;
//    [self.view addSubview:loginButton];
    
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
