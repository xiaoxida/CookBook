//
//  CBLoginViewController
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/1/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface CBLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@end

