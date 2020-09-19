//
//  FirstTableViewController.m
//  7.BSBDJ
//
//  Created by Mac on 2020/9/14.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "FirstTableViewController.h"
#import "TopicTableViewCell.h"

@interface FirstTableViewController ()<UITableViewDelegate,UITableViewDataSource>
//可变数组，存放帖子
@property(nonatomic,strong) NSMutableArray *topicsArray;
//上拉加载新数据表格底视图
@property(nonatomic,strong) UIView *footer;
//上拉加载新数据表格文字内容
@property(nonatomic,strong) UILabel *footerLabel;
//是否正在刷新 1 刷新中 0 不在刷新中
@property(nonatomic,assign) NSInteger footRefreshing;
//分页请求数据的页码
@property(nonatomic,assign) NSInteger page;
@end

@implementation FirstTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 400;
    //第一次请求帖子
    [self getTopics];
    //设置上拉加载新数据
    [self setFootRefreshView];
}
//第一次加载帖子
- (void)getTopics{
    self.footRefreshing = 1;
    //请求的页码为1
    self.page = 1;
    //请求地址
    NSString *url = [NSString stringWithFormat:@"http://newhtrs.site.8dfish.com/api/bsbdj/getForumPostList?category_id=5&page=%ld&psize=3",(long)self.page];
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
                    //用addObjectsFromArray往已经初始化的可变数组添加新元素
                    NSArray *firstArray = result[@"data"][@"list"];
                    self.topicsArray = [NSMutableArray array];
                    [self.topicsArray addObjectsFromArray:firstArray];
                    [self.tableView reloadData];
                    //页码+1
                    self.page ++;
                    self.footRefreshing = 0;
                });
            }
        }else{
            NSLog(@"%@",error);
            self.page --;
            self.footRefreshing = 0;
        }

    }]resume];
}
//设置上拉加载新数据
- (void)setFootRefreshView{
    self.footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    self.footerLabel = [[UILabel alloc]initWithFrame:self.footer.bounds];
    self.footerLabel.text = @"上拉加载更多";
    self.footerLabel.textAlignment = NSTextAlignmentCenter;
    [self.footer addSubview:self.footerLabel];
    self.tableView.tableFooterView = self.footer;
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    //return self.topicsArray.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    
    //NSLog(@"%lu",(unsigned long)self.topicsArray.count);
    return self.topicsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSString *topicsTitle =self.topicsArray[indexPath.row][@"title"];
    NSString *topicsContent = self.topicsArray[indexPath.row][@"content"];
    cell.textLabel.text = topicsTitle;
    cell.detailTextLabel.text =topicsContent;
    return cell;
     */
    static NSString *ID = @"cell";
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TopicTableViewCell class]) owner:nil options:nil].firstObject;
    }
    NSString *topicsTitle =self.topicsArray[indexPath.row][@"title"];
    NSString *topicsContent = self.topicsArray[indexPath.row][@"content"];
    if (![self.topicsArray[indexPath.row][@"image"] isEqual: @""]) {
        NSString *topicContentImage = self.topicsArray[indexPath.row][@"image"][0];
        [cell.contentImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:topicContentImage]]]];
    }
    cell.titleLabel.text = topicsTitle;
    cell.contentLabel.text =topicsContent;

    return cell;
}
//监听表格滑动 滑动到最底 上拉加载视图出现时 发起请求加载新数据
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%ld",(long)self.footRefreshing);
    //如果当前正在刷新 返回
    if (self.footRefreshing == 1) return;
    //if (self.tableView.contentSize.height == 30) return;
    //当scollView的Y偏移量大于等于offsetY时 说明表格底已经完全出现
    CGFloat Y = self.tableView.contentSize.height - self.tableView.frame.size.height;
    //NSLog(@"%f-%f-%f-%f",self.tableView.contentSize.height,self.tableView.frame.size.height,self.tableView.contentOffset.y,Y);
    //执行上拉刷新操作
    if (self.tableView.contentOffset.y > Y) {
        //NSLog(@"%f",Y);
        //设置正在刷新
        self.footRefreshing = 1;
        self.footerLabel.text = @"正在加载中...";
        //发起请求
        [self getMoreTopics];
        
    }
    //if (self.footRefreshing) return;
    //if (self.tableView.contentOffset.y > 0) {
        //NSLog(@"%f",self.tableView.contentOffset.y);
        //self.footRefreshing = 1;
        //self.footerLabel.text = @"正在加载中...";
        //[self getMoreTopics];
    //}
}
//设置结束刷新
- (void)endFootRefresh{
    self.footRefreshing = 0;
    self.footerLabel.text = @"上拉加载更多";
}
//加载更多帖子
- (void)getMoreTopics{
    //NSLog(@"%ld",(long)self.page);
    //请求地址
    NSString *url = [NSString stringWithFormat:@"http://newhtrs.site.8dfish.com/api/bsbdj/getForumPostList?category_id=5&page=%ld&psize=3",(long)self.page];
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
                    NSArray *newTopicArray = result[@"data"][@"list"];
                    //NSLog(@"%@",self.topicsArray);
                    //NSLog(@"%@",newTopicArray);
                    //判断加载的数据是否为空 为空则返回
                    if (newTopicArray.count == 0) {
                        self.footerLabel.text = @"已经到底了";
                        [self endFootRefresh];
                    }else{
                        //NSLog(@"%@",result[@"data"][@"list"]);
                        //把新加载的数据添加进帖子数组中
                        [self.topicsArray addObjectsFromArray:result[@"data"][@"list"]];
                        [self.tableView reloadData];
                        self.page ++ ;
                        [self endFootRefresh];
                    }
                });
            }
        }else{
            NSLog(@"%@",error);
            self.page -- ;
        }

    }]resume];
    
}
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
