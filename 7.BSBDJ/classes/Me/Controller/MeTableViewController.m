//
//  MeTableViewController.m
//  7.BSBDJ
//
//  Created by Mac on 2020/9/4.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "MeTableViewController.h"
#import "SetTableViewController.h"
#import <SafariServices/SafariServices.h>

@interface MeTableViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *tv;
//创建数组
@property(strong,nonatomic) NSMutableArray *data;
@end

@implementation MeTableViewController
//懒加载
-(UITableView *)tv{
    //判断有没有实例化过
    if (!_tv) {
        //没有就实例化对象
        _tv = [[UITableView alloc]init];
        //绑定数据源
        _tv.dataSource = self;
        //绑定代理
        _tv.delegate = self;
        //设置位置大小
        _tv.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        //添加到主视图
        [self.view addSubview:_tv];
    }
    return _tv;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self tv];

    [self getWebUrl];

    
    //给数组赋值
    //self.data =[NSMutableArray arrayWithArray:@[@"iphone1",@"iphone2",@"iphone3"]];
    //NSLog(@"%@",self.data);
    //给导航栏添加一个设置按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"设置" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    //给按钮添加点击事件 点击跳转到设置页面
    [btn addTarget:self action:@selector(toSet) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.title = @"BSBDJ";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//发起请求
- (void)getWebUrl{
        //请求地址
    NSString *url = [NSString stringWithFormat:@"http://newhtrs.site.8dfish.com/api/bsbdj/web"];
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
                //[self setLaunchImg:result[@"data"][@"img"] :result[@"data"][@"url"]];
                //NSLog(@"%@",result[@"data"]);
                self.data = [NSMutableArray arrayWithObject:result[@"data"]];
                self.data = self.data[0];
                //NSLog(@"%@",self.data);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tv reloadData];
                });
                    
            }
        }

    }]resume];
}
//设置按钮的点击事件
- (void)toSet{
    NSLog(@"%@",self.data);
    //初始化一个设置视图
    SetTableViewController *setVc = [[SetTableViewController alloc] init];
    //隐藏设置视图的标签栏
    setVc.hidesBottomBarWhenPushed = YES;
    //跳转
    [self.navigationController pushViewController:setVc animated:YES];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    //return 0;
//}

//表格视图的数据源方法，返回每行的内容
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //重用池，避免创建重复对象
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abc"];
    //不存在就创建
    if (cell == nil) {
        //实例化绑定身份
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
    }
    //把数组赋值给表格
    //NSLog(@"%@",self.data);
    cell.textLabel.text = self.data[indexPath.row][@"name"];
    return cell;
}
//表格视图的数据源方法 表格有多少行
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //表格的数量就是数组的元素个数
    //NSLog(@"%lu",(unsigned long)self.data.count);
    return self.data.count;

}
//表格视图的数据源方法 返回字符串类型的表格头
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //return @"head";
//}
//表格视图的数据源方法 返回字符串类型的表格尾
//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    //return @"foot";
//}
//表格视图的代理方法 返回表格头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 80.0;
}
//表格视图的代理方法分 返回表格每一行的高度 一般不用
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}
//表格视图的代理方法 返回表格尾的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 80.0;
}
//表格视图的代理方法 当选中了表格就调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //通过传进来的indexpath获取到当前选中的是哪一行
    //NSString *st = self.data[indexPath.row];
    //输出当前选中的内容
    //NSLog(@"%@",st);
    NSURL *url = [NSURL URLWithString:self.data[indexPath.row][@"url"]];
    SFSafariViewController *safariVc = [[SFSafariViewController alloc]initWithURL:url];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController presentViewController:safariVc animated:YES completion:^{
        
    }];
}
//表格视图的代理方法 返回视图型的表格头 自定义表格头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //初始化一个按钮
    UIButton *bt = [UIButton buttonWithType:UIButtonTypeSystem];
    //bt.frame = CGRectMake(0, 0, 10, 10);
    //给按钮设置名字 和类型
    [bt setTitle:@"add" forState:UIControlStateNormal];
    //给按钮绑定点击事件 参数1 self 自身对象 参数2 @selector(addIphone:) 绑定的方法 冒号可以将当前按钮传进去 参数3 uicontroleventTouchInside 触发方法 点击触发
    [bt addTarget:self action:@selector(addIphone:) forControlEvents:UIControlEventTouchUpInside];
    //把这个按钮返回给表格头
    return bt;
}
//自定义的按钮点击事件 会将当前按钮传进来
-(void)addIphone:(UIButton *)bt{
    //判断当前是否编辑
    if (self.tv.isEditing == false) {
        //设置表格视图可以被编辑 然后在下一个方法中设置执行的事件是插入数据
        [self.tv setEditing:true];
        //把按钮的名字改成finish
        [bt setTitle:@"finish" forState:UIControlStateNormal];
        NSLog(@"111");
    }else{
        //关闭编辑状态
        [self.tv setEditing:false];
        NSLog(@"222");
    }
}
//设置点击按钮后触发的是插入数据事件
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    //返回编辑的模式是插入数据
    return UITableViewCellEditingStyleInsert;
}
//表格视图的代理方法 返回视图型的表格尾 自定义表格尾
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{}

//表格代理方法实现可以删除按钮
//设置该行可以被编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //根据indexpath获取当前选中的行
    NSString *st = self.data[indexPath.row];
    //如果当前选中的是iphone1这行 就返回false 不能被编辑
    if ([st  isEqual: @"iphone1"]) {
        return false;
    }
    return true;
}
//提交编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //判断当前的编辑模式是删除或者新增或者其他
    if (editingStyle == UITableViewCellEditingStyleDelete) {
            //删除数组
        [self.data removeObjectAtIndex:indexPath.row];
        //删除界面
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else if (editingStyle == UITableViewCellEditingStyleInsert){
        //新增数据
        [self.data insertObject:@"iphone4" atIndex:indexPath.row];
        //把新增的数据显示出来
        [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //或者刷新整个表格 但是一般不用 占内存
        //[tableView reloadData];
    }

}
//设置删除按钮样式
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//表格视图代理方法实现移动表格某一行
//设置表格可以移动 返回true
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}
//移动 sourceindepath 移动前的索引  destinationindexpath 移动后的索引
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //创建一个字符串赋值 根据sourceindexpath索引把要移动的那行的值赋值到字符串
    NSString *celldata = self.data[sourceIndexPath.row];
    //根据sourceindexpath索引删除数组的值
    [self.data removeObjectAtIndex:sourceIndexPath.row];
    //根据destinationindexpath索引把移动的那一行的值插入到数组中
    [self.data insertObject:celldata atIndex:destinationIndexPath.row];
}/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
