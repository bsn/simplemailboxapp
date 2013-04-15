//
//  RBNetworking.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBNetworking : NSObject

- (void)getEmailsForPage:(NSUInteger)page completionBlock:(void (^)(NSDictionary* result))completionBlock errorBlock:(void (^)(NSError* error))errorBlock; // main API request

@end
