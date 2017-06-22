//
//  managerStream.m
//  微信聊天
//
//  Created by Edge on 2017/6/21.
//  Copyright © 2017年 Edge. All rights reserved.
//

/*
 1、导入头文件
 2、创建对象
 3、设置参数或者代理
 4、写代理方法
 5、激活
 
 */

#import "managerStream.h"
#import "DDLog.h"
#import "XMPPLogging.h"
#import "DDTTYLogger.h"

@interface managerStream()<XMPPStreamDelegate>
// 密码
@property(nonatomic,strong)NSString *passward;
@end
@implementation managerStream

//  单利
static managerStream *share;
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        share = [[managerStream alloc]init];
        //  设置打印日志
       //  [DDLog addLogger:[DDTTYLogger sharedInstance] withLogLevel:XMPP_LOG_FLAG_SEND_RECV];
    });
    return share;

}

#pragma mark 懒加载
//  配置stream流
-(XMPPStream *)XMPPStream{
    if (!_XMPPStream) {
        //  1、创建对象
        _XMPPStream = [[XMPPStream alloc]init];
        //  设置属性
        _XMPPStream.hostName = @"127.0.0.1";
        _XMPPStream.hostPort = 5222;
        //  设置代理
        [_XMPPStream addDelegate:self delegateQueue:dispatch_get_main_queue()];// 执行这句的代码就是代理之一
       
    }
    return _XMPPStream;
}
//  配置XMPPReconnect
-(XMPPReconnect *)XMPPReconnect{
    if (!_XMPPReconnect) {
        
        //  创建对象
        _XMPPReconnect = [[XMPPReconnect alloc]initWithDispatchQueue:dispatch_get_main_queue()];
        
        //  设置参数(重连时间)
        _XMPPReconnect.reconnectTimerInterval = 2;
    }
    return _XMPPReconnect;
}

//  心跳检测
-(XMPPAutoPing *)XMPPAutoPing{

    if (!_XMPPAutoPing) {
        
        _XMPPAutoPing = [[XMPPAutoPing alloc]initWithDispatchQueue:dispatch_get_main_queue()];
        
        //  设置参数
        _XMPPAutoPing.pingInterval = 3.0;
    }
    return _XMPPAutoPing;
    
}

#pragma mark 自定义方法
//  登录连接服务器(需要设置myjid和密码才可以登录)
-(void)logininToservers:(XMPPJID *)XMPPJID passward:(NSString *)passward{
    //  设置myjid
    [self.XMPPStream setMyJID:XMPPJID];
    //  连接服务器
    [self.XMPPStream connectWithTimeout:-1 error:nil];
    
    //  保存密码
    self.passward = passward;
    
    //  激活所有功能
    [self activity];
}

-(void)activity{
// 1、自动连接激活
    [self.XMPPReconnect activate:self.XMPPStream];
//  2、心跳检测激活
    [self.XMPPAutoPing activate:self.XMPPStream];

}


#pragma  mark delegate
// 通过代理判断是否连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    NSLog(@"连接成功");
    //  连接成功够账号认证（登录）
    [self.XMPPStream authenticateWithPassword:self.passward error:nil];
    //  匿名登录
 //   [self.XMPPStream authenticateAnonymously:nil];
    //  注册
//    [self.XMPPStream registerWithPassword:<#(NSString *)#> error:<#(NSError *__autoreleasing *)#>];

}
//  登录成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    
    XMPPPresence *presence = [XMPPPresence presence];
    //  添加出席状态（dad 勿扰 chat 找我聊天 away离开房间 xa离开房间一段时间）
    [presence addChild:[DDXMLElement elementWithName:@"show" stringValue:@"chat"]];
    
    //  自定义状态文字(客户端可见)
    [presence addChild:[DDXMLElement elementWithName:@"status" stringValue:@"超级无聊"]];
    
    //  通过stream告诉服务器你要出席
    [self.XMPPStream sendElement:presence];
}

//  通过代理接收方法
-(void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    
    UILocalNotification *noti = [[UILocalNotification alloc]init];
    
    [noti setAlertAction:[NSString stringWithFormat:@"%@:%@",message.from,message.body]];
    //  弹出本地通知
    [[UIApplication sharedApplication]presentLocalNotificationNow:noti];
  
   // NSLog(@"%@",message.body);
   
//    //  设置图标
    [noti setApplicationIconBadgeNumber:1];

}
@end
