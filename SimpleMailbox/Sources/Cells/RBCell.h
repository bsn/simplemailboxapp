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
{
@private
    UILabel *_topLabel;
    UILabel *_subjLabel;
    UILabel *_bodyLabel;
    UIImageView *_favImageView;
    UILabel *_dateLabel;
    UILabel *_counterLabel;
    UIImageView *_rightIconView;
    UIView *_separatorLineView;
}

- (void)setEmail:(RBEmail *)email;

@end
