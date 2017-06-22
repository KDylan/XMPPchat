// 
// Core classes  -- 核心库
// 
// Jabber ID--身份证 username@domain/resource-->full
//           username@domain --->bare
// zhangsan@im.itheima.com/iOS
#import "XMPPJID.h"

// 包含Socket流的各种处理,以及xml的各种封装和解析
#import "XMPPStream.h"
// DDXMLElement
#import "XMPPElement.h"

// XMPP 三剑客
// Infomation/Query --> HTTP一个请求一个响应

#import "XMPPIQ.h"
// 真正意义的"消息"
#import "XMPPMessage.h"

// 出席
#import "XMPPPresence.h"

// 模块 所有功能模块的公共父类
#import "XMPPModule.h"

// 
// Authentication -- 授权
// 

#import "XMPPSASLAuthentication.h"
#import "XMPPCustomBinding.h"
#import "XMPPDigestMD5Authentication.h"
#import "XMPPSCRAMSHA1Authentication.h"
#import "XMPPPlainAuthentication.h"
#import "XMPPXFacebookPlatformAuthentication.h"
#import "XMPPAnonymousAuthentication.h"
#import "XMPPDeprecatedPlainAuthentication.h"
#import "XMPPDeprecatedDigestAuthentication.h"

// 
// Categories
// 

#import "NSXMLElement+XMPP.h"
