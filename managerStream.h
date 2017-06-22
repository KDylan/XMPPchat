//
//  managerStream.h
//  微信聊天
//
//  Created by Edge on 2017/6/21.
//  Copyright © 2017年 Edge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface managerStream : NSObject
//stream 流
@property(nonatomic,strong)XMPPStream *XMPPStream;
//  自动连接
@property(nonatomic,strong)XMPPReconnect *XMPPReconnect;
//  心跳检测(检测客户端是否在线)
@property(nonatomic,strong)XMPPAutoPing *XMPPAutoPing;



+(instancetype)shareManager;

//  连接服务器方式
-(void)logininToservers:(XMPPJID *)XMPPJID passward:(NSString *)passward;
@end
