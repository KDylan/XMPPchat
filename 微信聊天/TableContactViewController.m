//
//  TableContactViewController.m
//  微信聊天
//
//  Created by Edge on 2017/6/22.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import "TableContactViewController.h"
#import "chatViewController.h"
@interface TableContactViewController ()<NSFetchedResultsControllerDelegate,XMPPRosterDelegate>
//查询控制器
@property(nonatomic,strong)NSFetchedResultsController *fetchResualtController;
// 好友数组
@property(nonatomic,strong)NSArray *contractArr;

@end

@implementation TableContactViewController

-(NSArray *)contractArr{

    if (!_contractArr) {
        _contractArr = [NSArray array];
    }
    return _contractArr;
}

-(NSFetchedResultsController *)fetchResualtController{
   
    if (!_fetchResualtController) {
        
    //1 创建查询请求
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    //  1.1 实体
    NSEntityDescription *entiy = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject" inManagedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
    
    fetchRequest.entity = entiy;
    //  1.2 谓词(筛选)
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"subscription = %@",@"both"];
    
    fetchRequest.predicate = pre;
    //  1.3 排序
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"jidStr" ascending:YES];
    fetchRequest.sortDescriptors = @[sort];
    
   //2.创建fetchedResultsController对象
        _fetchResualtController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[XMPPRosterCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"contacts"];
        //  设置代理
        _fetchResualtController.delegate = self;
    }
   
    return _fetchResualtController;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //  好友设置代理
    [[managerStream shareManager].XMPPRoster addDelegate:self delegateQueue:dispatch_queue_create(0, 0)];
    //  查询操作
    [self.fetchResualtController performFetch:nil];
    //  获取数据
    self.contractArr = self.fetchResualtController.fetchedObjects;
    //  刷新数据
    [self.tableView reloadData];
    
    //  去掉多余cell的显示
    self.tableView.tableFooterView = [UIView new];
   
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
   // NSLog(@"%lu",(unsigned long)self.contractArr.count);
    return self.contractArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    XMPPUserCoreDataStorageObject *contract = self.contractArr[indexPath.row];
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content_cell"];
    
    UILabel *nameLabel = [cell viewWithTag:1002];
    
    nameLabel.text = contract.jidStr;
    
    return cell;

}
//删除方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //  获取数据
        XMPPUserCoreDataStorageObject *contract = self.contractArr[indexPath.row];
        
        [[managerStream shareManager].XMPPRoster removeUser:contract.jid];
    }
}




//  当coredata数据变化时候
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //获取到数据
    self.contractArr = self.fetchResualtController.fetchedObjects;
    //刷新数据
    [self.tableView reloadData];
}

//  添加好友
- (IBAction)addFriends:(id)sender {
    
    [[managerStream shareManager].XMPPRoster addUser:[XMPPJID jidWithUser:@"admin" domain:@"127.0.0.1" resource:nil] withNickname:@"加一下"];
    
}

//  当有好友验证请求调用这个代理
-(void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence{
    //  同意添加
    [[managerStream shareManager].XMPPRoster acceptPresenceSubscriptionRequestFrom:[XMPPJID jidWithUser:@"admin" domain:@"127.0.0.1" resource:nil] andAddToRoster:YES];
}

// 跳转方法(segue)跳转走这里

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)cell{
    
    chatViewController *chatVC = segue.destinationViewController;
    // 参数
    XMPPUserCoreDataStorageObject *contact = self.contractArr[self.tableView.indexPathForSelectedRow.row];
    // 数据传递
    chatVC.jid = contact.jid;
    
}
@end
