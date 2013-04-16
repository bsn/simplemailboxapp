//
//  RBPagination.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RBPagination : NSObject
{
@private
    NSInteger _perPage;
    NSInteger _currentPage;
    NSInteger _totalPages;
}

@property (nonatomic, readonly) NSInteger perPage;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, readonly) NSInteger totalPages;

- (id)initWithDict:(NSDictionary *)dict;

@end
