//
//  EssenceViewController.m
//  7.BSBDJ
//
//  Created by Mac on 2020/9/4.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "EssenceViewController.h"
#import "FirstTableViewController.h"
#import "SecondTableViewController.h"
#import "ThirdTableViewController.h"
#import "Topics.h"

@interface EssenceViewController ()<UIScrollViewDelegate>
//滚动视图
@property(nonatomic,strong) UIScrollView *scrolVc;
//标题数组
@property(nonatomic,strong) NSArray *titleArray;
//标题视图
@property(nonatomic,strong) UIView *titleView;
//用来存放上一个点击的标题按钮
@property(nonatomic,strong) UIButton *lastClickBtn;
//@property(nonatomic,strong) UITableView *tableView;
@end

@implementation EssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    //添加子视图控制器
    [self addChildViewController:[[FirstTableViewController alloc] init]];
    [self addChildViewController:[[SecondTableViewController alloc] init]];
    [self addChildViewController:[[ThirdTableViewController alloc] init]];
    //请求数据获取分类
    [self getClassify];
    
    //NSLog(@"%@",self.titleArray);
    
    //设置导航条
    [self setNavBar];
    
    
    
    //[self setTitlesView];
}
//发起请求
- (void)getClassify{
        //请求地址
    NSString *url = [NSString stringWithFormat:@"http://newhtrs.site.8dfish.com/api/bsbdj/classify"];
    NSURL *adUrl = [NSURL URLWithString:url];
    //发送请求
    [[[NSURLSession sharedSession] dataTaskWithURL:adUrl completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //判断请求有没有出错
        if (!error) {
            //请求返回的数据
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //判断是否成功
            if ([result[@"code"] intValue] == 1) {
                //NSLog(@"%@---%@",result,[NSThread currentThread]);
                //
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.titleArray = result[@"data"];
                    //[self setTitlesView];
                    //设置滚动视图
                    [self setScrollView];
                    //设置标题视图
                    [self setTitlesView];
                });
                //NSLog(@"%@",self.titleArray);
            }
        }

    }]resume];
    
}
//设置导航栏
- (void)setNavBar{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"游戏" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.title = @"BSBDJ";
}
//设置滚动视图
- (void)setScrollView{
    self.scrolVc = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //self.scrolVc.backgroundColor = [UIColor blueColor];
    //self.scrolVc.frame = self.view.bounds;
    //设置滑动视图分页 提升用户体验
    self.scrolVc.pagingEnabled = YES;
    [self.view addSubview:self.scrolVc];
    self.scrolVc.delegate = self;
    
    //循环创建滚动视图里的表格视图
    NSInteger titleCount = self.titleArray.count;
    for (NSInteger i = 0; i < titleCount; i++) {
        //UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //根据索引创建不同的表格视图
        UIView *tableView = self.childViewControllers[i].view;
        tableView.frame = CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

        [self.scrolVc addSubview:tableView];
    }
    //设置滚动视图偏移的范围 x为表格视图的宽度之和 y为0
    self.scrolVc.contentSize = CGSizeMake(titleCount * [UIScreen mainScreen].bounds.size.width, 0);
    
}
//设置标题视图
-(void)setTitlesView{
    UIView *titlesVc = [[UIView alloc] init];
    //设置半透明
    titlesVc.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5];
    //titlesVc.backgroundColor = [UIColor redColor];
    titlesVc.frame = CGRectMake(0, self.navigationController.navigationBar.bounds.size.height+46, [UIScreen mainScreen].bounds.size.width,35);
    self.titleView = titlesVc;
    [self.view addSubview:titlesVc];
    
    //self.titleArray = @[@"1",@"2"];
    //根据请求的数据设置标题栏的按钮
    NSInteger titleCount = self.titleArray.count;
    for (NSInteger i = 0; i < titleCount; i++) {
        UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake( i * ([UIScreen mainScreen].bounds.size.width / titleCount),5,[UIScreen mainScreen].bounds.size.width / titleCount,20)];
        [titleButton setTitle:self.titleArray[i][@"name"] forState:UIControlStateNormal];
        [titlesVc addSubview:titleButton];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        int titleId = [self.titleArray[i][@"id"] intValue];
        //设置标题按钮的tag属性
        titleButton.tag = titleId;
        [titleButton addTarget:self action:@selector(getContent:) forControlEvents:UIControlEventTouchUpInside];
        //初始化点击第一个标题按钮
        if (i == 0) {
            [self getContent:titleButton];
        }
    }
}
//标题按钮的点击事件
- (void)getContent:(UIButton *)btn{
    //NSLog(@"%ld",(long)btn.tag);
    //设置当前点击的按钮变成红色
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    if (self.lastClickBtn != btn && self.lastClickBtn != nil) {
            //把上一个点击的按钮变成黑色
        [self.lastClickBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    self.lastClickBtn = btn;
    
    //if (btn.tag == 1) {
        //UITableView *contentVc = [[UITableView alloc] init];
        //contentVc.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.scrolVc.frame.size.height);
        //contentVc.backgroundColor = [UIColor redColor];
        //[self.scrolVc addSubview:contentVc];
    //}else if (btn.tag == 2){
        //UITableView *contentVc = [[UITableView alloc] init];
        //contentVc.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.scrolVc.frame.size.height);
        //contentVc.backgroundColor = [UIColor blueColor];
        //[self.scrolVc addSubview:contentVc];
    //}
    //点击标题按钮时 滚动视图的表格视图滑到对应的栏目 x是这个按钮在标题视图中的子视图的索引乘以滚动视图的宽度 y最好为0
    self.scrolVc.contentOffset = CGPointMake([self.titleView.subviews indexOfObject:btn] * self.scrolVc.frame.size.width, 0);
}
//scrollview的代理方法 当滑动快要停止时调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //用滑动视图的偏移量算出索引
    NSUInteger index = self.scrolVc.contentOffset.x / self.scrolVc.frame.size.width;
    //根据索引拿到按钮
    UIButton *titleBtn = self.titleView.subviews[index];
    //调用点击按钮方法
    [self getContent:titleBtn];
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
