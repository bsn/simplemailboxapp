//
//  RBCustomSegmentedControl.h
//  SimpleMailbox
//
//  Created by Andrey Toropchin on 16.04.13.
//  Copyright (c) 2013 Andrey Toropchin. All rights reserved.
//

@class RBCustomSegmentedControl;

@protocol RBCustomSegmentedControlDelegate
@optional
- (void)touchUpInsideSegmentIndex:(NSUInteger)segmentIndex;
- (void)touchDownAtSegmentIndex:(NSUInteger)segmentIndex;
@end

@interface RBCustomSegmentedControl : UIView

@property (nonatomic, strong) NSMutableArray* buttons;
@property (nonatomic, assign) NSUInteger segmentCount;
@property (nonatomic, assign) NSInteger selectedItem;
@property (nonatomic, weak) NSObject <RBCustomSegmentedControlDelegate> *delegate;

- (id)initWithSegmentCount:(NSUInteger)segmentCount segmentsize:(CGSize)segmentsize dividerImage:(UIImage *)dividerImage tag:(NSInteger)objectTag delegate:(NSObject <RBCustomSegmentedControlDelegate> *)customSegmentedControlDelegate;
- (void)dimAllButtonsExcept:(UIButton *)button;

@end
