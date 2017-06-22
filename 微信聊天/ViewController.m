//
//  ViewController.m
//  微信聊天
//
//  Created by Edge on 2017/6/21.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   //连接服务器
    [[managerStream shareManager]logininToservers:[XMPPJID jidWithUser:@"zhangsan" domain:@"127.0.0.1" resource:nil] passward:@"123456"];
    
    //NSLog(@"here");

}




@end
