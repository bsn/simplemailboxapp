//
//  RBEmail.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBEmail.h"

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

        _ID = [[dict objectForKey:@"id"] integerValue];
        _state = kRBEmailStateInbox;
        _from = [dict objectForKey:@"from"];
        _to = [dict objectForKey:@"to"];
        _subject = [dict objectForKey:@"subject"];
        _body = [dict objectForKey:@"body"];
        _starred = [[dict objectForKey:@"starred"] boolValue];
        _messages = [[dict objectForKey:@"messages"] integerValue];
        _date = [dict objectForKey:@"received_at"];
    }

    return self;
}

@end
