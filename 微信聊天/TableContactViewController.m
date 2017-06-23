//
//  TableContactViewController.m
//  微信聊天
//
//  Created by Edge on 2017/6/22.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import "TableContactViewController.h"

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
   
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    NSLog(@"%lu",(unsigned long)self.contractArr.count);
    return self.contractArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    XMPPUserCoreDataStorageObject *contract = self.contractArr[indexPath.row];
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"content_cell"];
    
    UILabel *nameLabel = [cell viewWithTag:1002];
    
    nameLabel.text = contract.jidStr;
    
    return cell;

}

//  当coredata数据变化时候
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //获取到数据
    self.contractArr = self.fetchResualtController.fetchedObjects;
    //刷新数据
    [self.tableView reloadData];
}
@end
