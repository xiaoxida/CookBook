//
//  CBWebViewController.m
//  CookBook
//Email: xiaoxida@usc.edu
//  Created by Xiaoxi Dai on 12/4/17.
//  Copyright © 2017 Xiaoxi Dai. All rights reserved.
//

#import "CBWebViewController.h"

@interface CBWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation CBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [NSURL URLWithString: self.websiteString];
    NSURLRequest *request = [NSURLRequest requestWithURL: url];
    
    [self.webView loadRequest: request];
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
