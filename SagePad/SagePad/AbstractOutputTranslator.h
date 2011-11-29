//
//  AbstractOutputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractOutputTranslator <NSObject>

@optional
- (void)translateTouchEvent:(CGPoint *)coordinates isFirst:(BOOL)isFirst;
- (void)translatePinchEvent:(CGFloat *)scale isFirst:(BOOL)isFirst;

@required
- (void)notifyServer;

@end
