//
//  RCTopicEntity.m
//  JLRubyChina
//
//  Created by ccjoy-jimneylee on 13-12-10.
//  Copyright (c) 2013年 jimneylee. All rights reserved.
//

#import "RCTopicEntity.h"
#import "NSDate+RubyChina.h"
#import "RCNodeEntity.h"

@implementation RCTopicEntity

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    self = [super initWithDictionary:dic];
    if (self) {
        
        self.topicId = [dic[JSON_ID] unsignedLongValue];
        self.topicTitle = dic[JSON_TITLE];
        
        if (ForumBaseAPIType_RubyChina == FORUM_BASE_API_TYPE) {
            self.nodeId = [dic[JSON_NODE_ID] unsignedIntegerValue];
            self.nodeName = dic[JSON_NODE_NAME];
            self.createdAtDate = [NSDate dateFromSourceDateString:dic[JSON_CREATEED_AT]];
            self.updatedAtDate = [NSDate dateFromSourceDateString:dic[JSON_UPDATEED_AT]];
            self.repliedAtDate = [NSDate dateFromSourceDateString:dic[JSON_REPLIED_AT]];
            self.repliesCount = [dic[JSON_REPLIES_COUNT] unsignedLongValue];
            self.user = [RCUserEntity entityWithDictionary:dic[JSON_USER]];
            
            NSString* lastRepliedUserLoginId = dic[JSON_LAST_REPLY_USER_LOGIN];
            if (lastRepliedUserLoginId && [lastRepliedUserLoginId isKindOfClass:[NSString class]] && lastRepliedUserLoginId.length) {
                self.lastRepliedUser = [[RCUserEntity alloc] init];
                self.lastRepliedUser.hashId = [dic[JSON_LAST_REPLY_USER_ID] unsignedLongValue];
                self.lastRepliedUser.loginId = lastRepliedUserLoginId;
            }
        }
        else {
            RCNodeEntity* node = [RCNodeEntity entityWithDictionary:dic[JSON_NODE]];
            self.nodeId = node.nodeId;
            self.nodeName = node.nodeName;
            NSString* createTimestamp = dic[JSON_CREATED];
            if (createTimestamp) {
                self.createdAtDate = [NSDate dateWithTimeIntervalSince1970:[createTimestamp doubleValue]];
            }
            self.repliesCount = [dic[JSON_REPLIES] unsignedLongValue];
            self.user = [RCUserEntity entityWithDictionary:dic[JSON_MEMBER]];
            
            //TODO: for v2ex no replied user info
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)entityWithDictionary:(NSDictionary*)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    RCTopicEntity* entity = [[RCTopicEntity alloc] initWithDictionary:dic];
    return entity;
}

@end
