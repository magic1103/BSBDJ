//
//  ThirdTableViewController.m
//  7.BSBDJ
//
//  Created by Mac on 2020/9/14.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ThirdTableViewController.h"

@interface ThirdTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong) NSMutableArray *topicsArray;
@end

@implementation ThirdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getTopics];
}
- (void)getTopics{
    //请求地址
    NSString *url = [NSString stringWithFormat:@"http://newhtrs.site.8dfish.com/api/bsbdj/getForumPostList?category_id=1"];
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
                    self.topicsArray = result[@"data"][@"list"];
                    [self.tableView reloadData];
                });
            }
        }else{
            NSLog(@"%@",error);
        }

    }]resume];
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    //return self.topicsArray.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return self.topicsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSString *topicsTitle =self.topicsArray[indexPath.row][@"title"];
    cell.textLabel.text = topicsTitle;
    return cell;
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
