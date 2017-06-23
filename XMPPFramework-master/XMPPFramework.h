//
//  This file is designed to be customized by YOU.
//  
//  Copy this file and rename it to "XMPPFramework.h". Then add it to your project.
//  As you pick and choose which parts of the framework you need for your application, add them to this header file.
//  
//  Various modules available within the framework optionally interact with each other.
//  E.g. The XMPPPing module utilizes the XMPPCapabilities module to advertise support XEP-0199.
// 
//  However, the modules can only interact if they're both added to your xcode project.
//  E.g. If XMPPCapabilities isn't a part of your xcode project, then XMPPPing shouldn't attempt to reference it.
// 
//  So how do the individual modules know if other modules are available?
//  Via this header file.
// 
//  If you #import "XMPPCapabilities.h" in this file, then _XMPP_CAPABILITIES_H will be defined for other modules.
//  And they can automatically take advantage of it.
//

//  CUSTOMIZE ME !
//  THIS HEADER FILE SHOULD BE TAILORED TO MATCH YOUR APPLICATION.

//  The following is standard:

#import "XMPP.h"

//自动重连
#import "XMPPReconnect.h"

//心跳检测
#import "XMPPAutoPing.h"

//好友系统

#import "XMPPRoster.h"
#import "XMPPRosterCoreDataStorage.h"

//好友实体
#import "XMPPUserCoreDataStorageObject.h"

//4.消息记录
#import "XMPPMessageArchiving.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
//  消息实体
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
//  最近联系人实体
#import "XMPPMessageArchiving_Contact_CoreDataObject.h"
//5.文件接收
//#import "XMPPIncomingFileTransfer.h"

#import "XMPPIncomingFileTransfer.h"
//6.文件发送
//#import "XMPPOutgoingFileTransfer.h"



//7.头像 个人资料
#import "xmppvCardTempModule.h"

//个人资料内存对象
#import "XMPPvCardTemp.h"

//存储器
#import "XMPPvCardCoreDataStorage.h"

//个人资料的实体对象
#import "XMPPvCardCoreDataStorageObject.h"

//头像模块
#import "XMPPvCardAvatarModule.h"

//头像实体对象
#import "XMPPvCardAvatarCoreDataStorageObject.h"

//多人聊天，聊天室
#import "XMPPMUC.h"
#import "XMPPRoom.h"
#import "XMPPRoomCoreDataStorage.h"
