//
//  RBEmail.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import <Foundation/Foundation.h>

enum RBEmailState
{
    kRBEmailStateUnknown = 0,
    kRBEmailStateDeleted = 1,
    kRBEmailStateInbox = 2,
    kRBEmailStateArchived = 3
};
typedef enum RBEmailState RBEmailState;

@interface RBEmail : NSObject
{
@private
    NSInteger _ID;
    RBEmailState _state;
    __strong NSString *_from;
    __strong NSString *_to;
    __strong NSString *_subject;
    __strong NSString *_body;
    BOOL _starred;
    NSInteger _messages;
    __strong NSDate *_date;
}

@property (nonatomic, readonly) NSInteger ID;
@property (nonatomic, assign) RBEmailState state;
@property (nonatomic, readonly) NSString *from;
@property (nonatomic, readonly) NSString *to;
@property (nonatomic, readonly) NSString *subject;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) BOOL starred;
@property (nonatomic, readonly) NSInteger messages;
@property (nonatomic, readonly) NSDate *date;

- (id)initWithDict:(NSDictionary *)dict;

+ (RBEmailState)stateForSegmentIndex:(NSInteger)index;
+ (RBEmailState)stateForTriggerState:(NSInteger)state;

@end
