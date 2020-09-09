//
//  RootViewController.m
//  7.BSBDJ
//
//  Created by Mac on 2020/9/4.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "RootViewController.h"
#import "EssenceViewController.h"
#import "NewViewController.h"
#import "PublishViewController.h"
#import "FriendTrendViewController.h"
#import "MeTableViewController.h"


@interface RootViewController ()

@end

@implementation RootViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //创建精华视图对象
    EssenceViewController *EssenceVc = [[EssenceViewController alloc]init];
    //创建精华导航栏对象 并绑定精华视图对象
    UINavigationController *EssenceNav = [[UINavigationController alloc]initWithRootViewController:EssenceVc];
    //设置菜单栏的标题
    EssenceNav.tabBarItem.title = @"精华";
    //把精华导航栏和精华视图添加到菜单栏
    [self addChildViewController:EssenceNav];
    
    NewViewController *NewVc = [[NewViewController alloc]init];
    UINavigationController *NewNav = [[UINavigationController alloc] initWithRootViewController:NewVc];
    NewNav.tabBarItem.title = @"最新";
    [self addChildViewController:NewNav];
    
    PublishViewController *PublishVc = [[PublishViewController alloc]init];
    PublishVc.tabBarItem.title = @"发布";
    [self addChildViewController:PublishVc];
    
    FriendTrendViewController *FriendTrendVc = [[FriendTrendViewController alloc] init];
    UINavigationController *FriendTrendNav = [[UINavigationController alloc] initWithRootViewController:FriendTrendVc];
    FriendTrendNav.tabBarItem.title = @"关注";
    [self addChildViewController:FriendTrendNav];
    
    MeTableViewController *MeVc = [[MeTableViewController alloc] init];
    UINavigationController *MeNav = [[UINavigationController alloc] initWithRootViewController:MeVc];
    MeNav.tabBarItem.title = @"我的";
    [self addChildViewController:MeNav];}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
