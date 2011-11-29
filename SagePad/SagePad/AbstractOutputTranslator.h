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
- (void)notifyServer;

@optional
- (void)translateTouchEvent:(CGPoint *)coordinates isFirst:(BOOL)isFirst;
- (void)translatePinchEvent:(CGFloat *)scale isFirst:(BOOL)isFirst;

@end
