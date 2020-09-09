//
//  LoginViewController.m
//  7.BSBDJ
//
//  Created by Mac on 2020/9/7.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 30, 30)];
    [userName setText:@"userName"];
    [self.view addSubview:userName];
    // Do any additional setup after loading the view.
    [self dataTask];
}
- (void)dataTask{
    NSURL *url = [NSURL URLWithString:@"http://newhtrs.site.8dfish.com/api/user/login"];
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@---%@",result,[NSThread currentThread]);
    }]resume];
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
