//
//  RBCell.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

#import "MCSwipeTableViewCell.h"

@class RBEmail;

@interface RBCell : MCSwipeTableViewCell

- (void)setEmail:(RBEmail *)email;

@end
