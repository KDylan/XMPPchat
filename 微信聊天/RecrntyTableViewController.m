//
//  RecrntyTableViewController.m
//  微信聊天
//
//  Created by Edge on 2017/6/23.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import "RecrntyTableViewController.h"
#import "chatViewController.h"
@interface RecrntyTableViewController ()<NSFetchedResultsControllerDelegate>
//查询控制器
@property(nonatomic,strong)NSFetchedResultsController *fetchResualtController;

//  数据数组
@property(nonatomic,strong)NSArray *recentArrs;
@end

@implementation RecrntyTableViewController

#pragma mark 懒加载
-(NSArray *)recentArrs{
    
    if (!_recentArrs) {
        _recentArrs = [NSArray array];
    }
    return _recentArrs;
}
-(NSFetchedResultsController *)fetchResualtController{
    if (!_fetchResualtController) {
        
        //  查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Contact_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        fetchRequest.entity = entity;
        //  谓词
//        NSPredicate *pre = [NSPredicate predicateWithFormat:@"bareJidStr"];
//        fetchRequest.predicate = pre;
        //  排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"mostRecentMessageTimestamp" ascending:YES];
        fetchRequest.sortDescriptors = @[sort];
        
        _fetchResualtController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"Recently"];
        _fetchResualtController.delegate = self;
    }
    return _fetchResualtController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //  查询聊天记录
    [self.fetchResualtController performFetch:nil];
    self.recentArrs =self.fetchResualtController.fetchedObjects;
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recentArrs.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recent_Cell"];
   
    XMPPMessageArchiving_Contact_CoreDataObject *contract = self.recentArrs[indexPath.row];
    UILabel *name = [cell viewWithTag:1002];
    name.text = contract.bareJidStr;
    
    UILabel *lastmessage = [cell viewWithTag:1003];
    lastmessage.text = contract.mostRecentMessageBody;
    
    return cell;
}



#pragma mark 代理
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    
    self.recentArrs = self.fetchResualtController.fetchedObjects;
    [self.tableView reloadData];
}

#pragma  mark 跳转
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //  获取目标控制器
    chatViewController *chatVC = segue.destinationViewController;
    // 拿出实体类
    XMPPMessageArchiving_Contact_CoreDataObject *contact = self.recentArrs[self.tableView.indexPathForSelectedRow.row];
    //  传递jid到咪表控制器
    chatVC.jid = contact.bareJid;
}

@end
