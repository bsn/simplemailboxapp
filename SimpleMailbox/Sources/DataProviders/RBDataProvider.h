//
//  RBDataProvider.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RBNetworking;

@interface RBDataProvider : NSObject
{
@private
    __strong RBNetworking *_networking;
}

@property (nonatomic, readonly) RBNetworking *networking;

+ (RBDataProvider *)sharedProvider;

@end
