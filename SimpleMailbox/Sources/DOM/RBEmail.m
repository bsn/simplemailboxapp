//
//  RBEmail.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBEmail.h"
#import "MCSwipeTableViewCell.h"
#import "NSDate+Helper.h"

#define RB_ID_KEY @"id"
#define RB_FROM_KEY @"from"
#define RB_TO_KEY @"to"
#define RB_SUBJ_KEY @"subject"
#define RB_BODY_KEY @"body"
#define RB_STARRED_KEY @"starred"
#define RB_MESSAGES_KEY @"messages"
#define RB_DATE_KEY @"received_at"

#define RB_STATE_KEY @"state"

@implementation RBEmail

@synthesize ID = _ID;
@synthesize state = _state;
@synthesize from = _from;
@synthesize to = _to;
@synthesize subject = _subject;
@synthesize body = _body;
@synthesize starred = _starred;
@synthesize messages = _messages;
@synthesize date = _date;

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];

    if (self != nil)
    {
        if (![dict isKindOfClass:[NSDictionary class]])
            dict = nil;

        _ID = [[dict objectForKey:RB_ID_KEY] integerValue];
        _state = kRBEmailStateInbox;
        _from = [dict objectForKey:RB_FROM_KEY];
        _to = [dict objectForKey:RB_TO_KEY];
        _subject = [dict objectForKey:RB_SUBJ_KEY];
        _body = [dict objectForKey:RB_BODY_KEY];
        _starred = [[dict objectForKey:RB_STARRED_KEY] boolValue];
        _messages = [[dict objectForKey:RB_MESSAGES_KEY] integerValue];
        _date = [NSDate dateWithString:[dict objectForKey:RB_DATE_KEY]];
    }

    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:[NSNumber numberWithInt:_ID] forKey:RB_ID_KEY];
    [encoder encodeObject:[NSNumber numberWithInt:_state] forKey:RB_STATE_KEY];
    [encoder encodeObject:_from forKey:RB_FROM_KEY];
    [encoder encodeObject:_to forKey:RB_TO_KEY];
    [encoder encodeObject:_subject forKey:RB_SUBJ_KEY];
    [encoder encodeObject:_body forKey:RB_BODY_KEY];
    [encoder encodeObject:[NSNumber numberWithBool:_starred] forKey:RB_STARRED_KEY];
    [encoder encodeObject:[NSNumber numberWithInt:_messages] forKey:RB_MESSAGES_KEY];
    [encoder encodeObject:_date forKey:RB_DATE_KEY];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    if (self != nil)
    {
        _ID = [[decoder decodeObjectForKey:RB_ID_KEY] integerValue];
        _state = [[decoder decodeObjectForKey:RB_STATE_KEY] integerValue];;
        _from = [decoder decodeObjectForKey:RB_FROM_KEY];
        _to = [decoder decodeObjectForKey:RB_TO_KEY];
        _subject = [decoder decodeObjectForKey:RB_SUBJ_KEY];
        _body = [decoder decodeObjectForKey:RB_BODY_KEY];
        _starred = [[decoder decodeObjectForKey:RB_STARRED_KEY] boolValue];
        _messages = [[decoder decodeObjectForKey:RB_MESSAGES_KEY] integerValue];
        _date = [decoder decodeObjectForKey:RB_DATE_KEY];
    }
    
    return self;
}

+ (RBEmailState)stateForSegmentIndex:(NSInteger)index
{
    return (index + 1);
}

+ (RBEmailState)stateForTriggerState:(NSInteger)state
{
    switch (state)
    {
        case MCSwipeTableViewCellState1:
            return kRBEmailStateArchived;

        case MCSwipeTableViewCellState3:
            return kRBEmailStateDeleted;

        default:
            return kRBEmailStateInbox;
    }
}

@end
