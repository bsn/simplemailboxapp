//
//  RBPagination.m
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "RBPagination.h"

@implementation RBPagination

@synthesize perPage = _perPage;
@synthesize currentPage = _currentPage;
@synthesize totalPages = _totalPages;

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super init];

    if (self != nil)
    {
        if (![dict isKindOfClass:[NSDictionary class]])
            dict = nil;

        _perPage = [[dict objectForKey:@"per_page"] integerValue];
        _currentPage = [[dict objectForKey:@"current_page"] integerValue];
        _totalPages = [[dict objectForKey:@"total"] integerValue];
    }

    return self;
}

@end
