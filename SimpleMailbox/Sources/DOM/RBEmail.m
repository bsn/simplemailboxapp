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
// Syntetic:
#define RB_STATE_KEY @"state"

#define RB_TITLE_LENGTH 27

static NSRegularExpression *sAddressRegExp = nil;

@interface RBEmail (Private)
+ (NSString *)_stringWithFrom:(NSString *)from to:(NSString *)to;
@end

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
@synthesize dateStr = _dateStr;
@synthesize titleStr = _titleStr;

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
        _dateStr = [NSDate dateStringWithDate:_date];
        _titleStr = [RBEmail _stringWithFrom:_from to:_to];
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
        _dateStr = [NSDate dateStringWithDate:_date];
        _titleStr = [RBEmail _stringWithFrom:_from to:_to];
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

#pragma mark -
#pragma mark *** Private Interface ***
#pragma mark -

+ (NSString *)_stringWithFrom:(NSString *)from to:(NSString *)to
{
    NSString* result = nil;

    if (sAddressRegExp == nil)
        sAddressRegExp = [[NSRegularExpression alloc] initWithPattern:@" <.*>" options:NSRegularExpressionCaseInsensitive error:nil];

    @autoreleasepool
    {
        NSMutableString *mutableFrom = [NSMutableString stringWithString:from];
        [sAddressRegExp replaceMatchesInString:mutableFrom options:NSMatchingReportProgress range:NSMakeRange(0, [from length]) withTemplate:@""];

        NSMutableString *mutableTo = [NSMutableString stringWithString:to];
        [sAddressRegExp replaceMatchesInString:mutableTo options:NSMatchingReportProgress range:NSMakeRange(0, [to length]) withTemplate:@""];

        NSArray *recepients = [mutableTo componentsSeparatedByString:@", "];
        if ([recepients count] > 1)
            result = [NSString stringWithFormat:@"%@ & %d others", mutableFrom, [recepients count]];
        else
            result = [NSString stringWithFormat:@"%@ to %@", mutableFrom, mutableTo];

        if ([result length] > RB_TITLE_LENGTH)
        {
            NSMutableArray *fromArray = [NSMutableArray arrayWithArray:[mutableFrom componentsSeparatedByString:@" "]];
            NSMutableArray *toArray = nil;
            if ([recepients count] == 1)
                toArray = [NSMutableArray arrayWithArray:[mutableTo componentsSeparatedByString:@" "]];
            BOOL shouldStop = NO;
            while ([result length] > RB_TITLE_LENGTH && !shouldStop)
            {
                NSMutableArray *array = ([fromArray count] >= [toArray count]) ? fromArray : toArray;
                if ([array count] > 1)
                    [array removeLastObject];

                if ([fromArray count] <= 1 && [toArray count] <= 1)
                    shouldStop = YES;

                if ([recepients count] > 1)
                    result = [NSString stringWithFormat:@"%@ & %d others", [fromArray componentsJoinedByString:@" "], [recepients count]];
                else
                    result = [NSString stringWithFormat:@"%@ to %@", [fromArray componentsJoinedByString:@" "], [toArray componentsJoinedByString:@" "]];
            }
        }
    }

    return result;
}

@end
