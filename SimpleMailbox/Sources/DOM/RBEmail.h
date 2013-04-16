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
    kRBEmailStateInbox = 0,
    kRBEmailStateArchived = 1,
    kRBEmailStateDeleted = 3
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
    __strong NSString *_date;
}

@property (nonatomic, readonly) NSInteger ID;
@property (nonatomic, assign) RBEmailState state;
@property (nonatomic, readonly) NSString *from;
@property (nonatomic, readonly) NSString *to;
@property (nonatomic, readonly) NSString *subject;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) BOOL starred;
@property (nonatomic, readonly) NSInteger messages;
@property (nonatomic, readonly) NSString *date;

- (id)initWithDict:(NSDictionary *)dict;

@end
