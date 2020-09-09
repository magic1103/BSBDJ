//
//  LaunchScreenViewController.m
//  7.BSBDJ
//
//  Created by Mac on 2020/9/5.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "RootViewController.h"

@interface LaunchScreenViewController ()

@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];


}
- (void)viewDidAppear:(BOOL)animated{
    RootViewController *rootVc = [[RootViewController alloc]init];
    [self presentViewController:rootVc animated:YES completion:nil];
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
