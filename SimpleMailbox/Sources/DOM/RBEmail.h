//
//  RBEmail.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBEmail : NSObject
{
@private
    NSInteger _ID;
    __strong NSString *_from;
    __strong NSString *_to;
    __strong NSString *_subject;
    __strong NSString *_body;
    BOOL _starred;
    NSInteger _messages;
    NSDate *_date;
}

@property (nonatomic, readonly) NSInteger ID;
@property (nonatomic, readonly) NSString *from;
@property (nonatomic, readonly) NSString *to;
@property (nonatomic, readonly) NSString *subject;
@property (nonatomic, readonly) NSString *body;
@property (nonatomic, readonly) BOOL starred;
@property (nonatomic, readonly) NSInteger messages;
@property (nonatomic, readonly) NSDate *date;

- (id)initWithDict:(NSDictionary *)dict;

@end
