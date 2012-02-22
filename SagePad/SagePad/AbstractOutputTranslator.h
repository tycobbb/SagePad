//
//  AbstractOutputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractOutputTranslator <NSObject>

@required
- (id)initWithDeviceWidth:(CGFloat)deviceWidth andHeight:(CGFloat)deviceHeight;
- (void)notifyClientOfOutput;

@optional
- (void)translateMove:(CGPoint *)newTouch isFirst:(BOOL)isFirst;
- (void)translatePinch:(CGFloat *)scale;
- (void)translatePress:(CGPoint *)newTouch;
- (void)translateDrag:(CGPoint *)newTouch;
- (void)translateRelease:(CGPoint *)newTouch;
- (void)translateClick:(CGPoint *)newTouch;

@end
