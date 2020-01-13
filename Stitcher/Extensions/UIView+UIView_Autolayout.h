//
//  UIView+UIView_Autolayout.h
//  Stitcher
//
//  Created by Junyu Lin on 13/01/20.
//  Copyright © 2020 Junyu Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UIView_Autolayout)

-(void)anchors: (NSLayoutXAxisAnchor *) centerX centerXConstant: (int) centerXConstant withCenterY: (NSLayoutYAxisAnchor *) centerY centerYConstant: (int) centerYConstant withTop: (NSLayoutYAxisAnchor *) top topConstant: (int)topConstant withBottom: (NSLayoutYAxisAnchor *) bottom bottomConstant:(int) bottomConstant withLeft: (NSLayoutXAxisAnchor *) left leftConstant:(int) leftConstant withRight: (NSLayoutXAxisAnchor *) right rightConstant:(int) rightConstant;

@end

NS_ASSUME_NONNULL_END
