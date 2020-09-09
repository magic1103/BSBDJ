//
//  FriendTrendViewController.m
//  7.BSBDJ
//
//  Created by Mac on 2020/9/4.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "FriendTrendViewController.h"
#import "LoginViewController.h"

@interface FriendTrendViewController ()
@property (nonatomic,strong)UITextField *userNameText;
@property (nonatomic,strong)UITextField *passWordText;
@end

@implementation FriendTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        //LoginViewController *loginVc = [[LoginViewController alloc]init];
        //[self.navigationController pushViewController:loginVc animated:YES];
    //[self presentViewController:loginVc animated:YES completion:nil];
    //[self.view.window.rootViewController presentViewController:loginVc animated:YES completion:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //判断本地有没有存用户数据
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfo = [user objectForKey:@"oneUser"];
    if (userInfo) {
        //把用户信息传入到用户界面
        [self setUserVc:userInfo];
    }else{
        //如果不存在用户数据就显示登录的组件
        [self setLoginVc];
    }
}
//添加用户信息组件
- (void)setUserVc:(NSDictionary *)userInfo{
    //显示用户名
    UILabel *userName =[[UILabel alloc]initWithFrame:CGRectMake(20, 100, 100, 40)];
    userName.text = userInfo[@"data"][@"userinfo"][@"username"];
    [self.view addSubview:userName];
}
//添加登录的组件
- (void)setLoginVc{
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 100, 40)];
    UILabel *passWord = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 100, 40)];
    self.userNameText = [[UITextField alloc]initWithFrame:CGRectMake(120, 100, 180, 40)];
    self.passWordText = [[UITextField alloc]initWithFrame:CGRectMake(120, 150, 180, 40)];
    UIButton *submit = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 180, 40)];
    [userName setText:@"userName"];
    [passWord setText:@"passWord"];
    self.userNameText.borderStyle = UITextBorderStyleLine;
    self.passWordText.borderStyle = UITextBorderStyleLine;
    [submit setTitle:@"login" forState:UIControlStateNormal];
    submit.backgroundColor = [UIColor redColor];
    [self.view addSubview:userName];
    [self.view addSubview:passWord];
    [self.view addSubview:self.userNameText];
    [self.view addSubview:self.passWordText];
    [self.view addSubview:submit];
    
    [submit addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
}
//点击登录按钮的事件
- (void)login{
    if (self.userNameText.text == nil || self.passWordText.text == nil) {
        
    }
    //NSLog(@"%@",self.userNameText.text);
    //发送网络请求 把用户账号密码传入
    [self dataTask:self.userNameText.text :self.passWordText.text];
}
//网络请求
- (void)dataTask:(NSString *)userName :(NSString *)passWord{
    //请求地址
    NSString *loginUrl = [NSString stringWithFormat:@"http://newhtrs.site.8dfish.com/api/user/login?account=%@&password=%@",userName,passWord];
    NSURL *url = [NSURL URLWithString:loginUrl];
    //发送请求
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //判断请求有没有出错
        if (!error) {
            //请求返回的数据
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            //判断登录是否成功
            if ([result[@"code"] intValue] == 1) {
                //NSLog(@"%@---%@",result,[NSThread currentThread]);
                //NSLog(@"%@",result[@"code"]);
                //把用户信息保存到本地
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:result forKey:@"oneUser"];
                [user synchronize];
                //NSDictionary *userInfo = [user objectForKey:@"oneUser"];
                //NSLog(@"%@",userInfo[@"code"]);
            //登录失败
            }else{
                NSLog(@"账号或者密码错误!");
            }
        //请求出错执行的代码
        }else{
            NSLog(@"服务器错误!");
        }


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
