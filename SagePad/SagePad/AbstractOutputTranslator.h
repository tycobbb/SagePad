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
- (void)notifyServerOfOutput;

@optional
- (void)translateMove:(CGPoint *)newTouch isFirst:(BOOL)isFirst;
- (void)translatePinch:(CGFloat *)scale isFirst:(BOOL)isFirst;
- (void)translatePress:(CGPoint *)newTouch;
- (void)translateDrag:(CGPoint *)newTouch;

@end
