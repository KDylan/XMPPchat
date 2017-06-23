//
//  chatViewController.m
//  微信聊天
//
//  Created by Edge on 2017/6/23.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import "chatViewController.h"

@interface chatViewController ()<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonContract;
@property (weak, nonatomic) IBOutlet UITextField *sendMssage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//  查询数据控制器
@property(nonatomic,strong)NSFetchedResultsController *fetchResultController;
//  查询结果数组
@property(nonatomic,strong)NSArray *chatArrs;
@end

@implementation chatViewController
#pragma mark 懒加载
-(NSFetchedResultsController *)fetchResultController{
    if (!_fetchResultController) {
        //  查询请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        // 1、实体
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject" inManagedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext];
        fetchRequest.entity = entity;
        //  2、谓词
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"bareJidStr = %@",self.jid.bare];
        fetchRequest.predicate = pre;
        //  3、排序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
        fetchRequest.sortDescriptors = @[sort];
        
        _fetchResultController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[XMPPMessageArchivingCoreDataStorage sharedInstance].mainThreadManagedObjectContext sectionNameKeyPath:nil cacheName:@"massages"];
        
        _fetchResultController.delegate = self;
    }
    return _fetchResultController;
}
-(NSArray *)chatArrs{
    if (!_chatArrs) {
        _chatArrs = [NSArray array];
    }
    return _chatArrs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //查询之前先清除缓存
    [NSFetchedResultsController deleteCacheWithName:@"massages"];
    //  查询聊天记录
    [self.fetchResultController performFetch:nil];
    self.chatArrs = self.fetchResultController.fetchedObjects;
    
    //  进来就滚动
    if (self.chatArrs.count>5) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatArrs.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
//  设置输入框代理
    self.sendMssage.delegate =self;
    //  注册通知改变键盘高度
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
   
}

-(void)keyBoardChange:(NSNotification *)not{

    //屏幕高度-键盘Y值=底部约束
    CGRect fream = [not.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
   self.bottonContract.constant = [UIScreen mainScreen].bounds.size.height-fream.origin.y+44;
    [self.view layoutIfNeeded];

}
#pragma mark textFiled代理
//  点击return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//  1、发送消息
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.jid];
    // 2、 给消息设置内容
    [message addBody:self.sendMssage.text];
    //  3、通过stream流
    [[managerStream shareManager].XMPPStream sendElement:message];
    
    //  清空输入框
    self.sendMssage.text = @"";
    return YES;
}
//  滚动隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.sendMssage endEditing:YES];
}
#pragma mark 查询代理

//  数据库发生变化
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    //排序
    NSSortDescriptor * sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];

    self.chatArrs = [_fetchResultController.fetchedObjects sortedArrayUsingDescriptors:@[sort]];
    
    [self.tableView reloadData];
    
    //  滚动
    if (self.chatArrs.count>5) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatArrs.count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}


#pragma mark tableView的代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
 
   // NSLog(@"%lu",(unsigned long)self.chatArrs.count);
    return self.chatArrs.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"here");
    //  获取数据
    XMPPMessageArchiving_Message_CoreDataObject *messageObject = self.chatArrs[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageObject.isOutgoing?@"rightCell":@"leftCell"];
  //  UIImageView *imageView = [cell viewWithTag:1001];
    
    UILabel *labelName = [cell viewWithTag:1002];
    labelName.text = messageObject.body;
    return cell;

}

@end
