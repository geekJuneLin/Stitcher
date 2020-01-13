//
//  UIView+UIView_Autolayout.m
//  Stitcher
//
//  Created by Junyu Lin on 13/01/20.
//  Copyright © 2020 Junyu Lin. All rights reserved.
//

#import "UIView+UIView_Autolayout.h"


@implementation UIView (UIView_Autolayout)

-(void)anchors: (NSLayoutXAxisAnchor *) centerX centerXConstant: (int) centerXConstant withCenterY: (NSLayoutYAxisAnchor *) centerY centerYConstant: (int) centerYConstant withTop: (NSLayoutYAxisAnchor *) top topConstant: (int)topConstant withBottom: (NSLayoutYAxisAnchor *) bottom bottomConstant:(int) bottomConstant withLeft: (NSLayoutXAxisAnchor *) left leftConstant:(int) leftConstant withRight: (NSLayoutXAxisAnchor *) right rightConstant:(int) rightConstant{
    
    [self.centerXAnchor constraintEqualToAnchor:centerX constant:centerXConstant].active = true;
    [self.centerYAnchor constraintEqualToAnchor:centerY constant:centerYConstant].active = true;
    [self.topAnchor constraintEqualToAnchor:top constant:topConstant].active = true;
    [self.bottomAnchor constraintEqualToAnchor:bottom constant:bottomConstant].active = true;
    [self.leftAnchor constraintEqualToAnchor:left constant:leftConstant].active = true;
    [self.rightAnchor constraintEqualToAnchor:right constant:rightConstant].active = true;
}

@end
