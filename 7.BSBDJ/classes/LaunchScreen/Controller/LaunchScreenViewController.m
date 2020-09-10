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
@property(nonatomic,weak) NSTimer *timer;
@property(nonatomic,strong) UIImageView *adImg;
@property(nonatomic,strong) NSString *url;
@end

@implementation LaunchScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    //self.adImg = [[UIImageView alloc]init];
    //发起请求获取数据并设置启动图
    [self getLaunchImg];
    //设置定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];


}
//- (void)viewDidAppear:(BOOL)animated{
    //RootViewController *rootVc = [[RootViewController alloc]init];
    //[self presentViewController:rootVc animated:YES completion:nil];
//}
//发起请求
- (void)getLaunchImg{
        //请求地址
    NSString *url = [NSString stringWithFormat:@"http://newhtrs.site.8dfish.com/api/user/ad"];
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
                //调用设置启动图的方法并且传值进去
                [self setLaunchImg:result[@"data"][@"img"] :result[@"data"][@"url"]];
            }
        }

    }]resume];
    
}
//设置启动图
- (void)setLaunchImg:(NSString *)img :(NSString *)url{
    //NSLog(@"%@",img);
    NSLog(@"%@",url);
    self.url = url;
    //让代码在主线程里运行
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *adImg = [[UIImageView alloc]initWithImage: [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img]]]];
        //设置用户与系统交互 就能使用手势
        adImg.userInteractionEnabled = YES;
        //初始化一个点击手势
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap)];
        //图片添加点击事件
        [adImg addGestureRecognizer:tap];
        [self.view addSubview:adImg];
    });

  
}
//图片点击事件
- (void)didTap{
    NSURL *url = [NSURL URLWithString:self.url];
    UIApplication *app = [UIApplication sharedApplication];
    //判断url是否能够跳转
    if ([app canOpenURL:url]) {
        //打开safar浏览器并跳到指定页面
        [app openURL:url options:@{} completionHandler:nil];
    }
}
//定时器访问的方法 页面倒计时
- (void)timeChange{
    //静态变量
    static int i = 3;
    //倒计时结束
    if (i == 0) {
        //跳转到主页面
        RootViewController *rootVc = [[RootViewController alloc]init];
        [self presentViewController:rootVc animated:YES completion:nil];
        //销毁定时器
        [_timer invalidate];
    }
    i--;
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
