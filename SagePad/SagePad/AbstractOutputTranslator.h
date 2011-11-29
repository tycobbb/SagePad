//
//  AbstractOutputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractOutputTranslator

@required
- (void)translateTouchEvent:(CGPoint *)coordinates isFirst:(BOOL)first;

- (void)translatePinchEvent:(CGFloat *)scalef isFirst:(BOOL)first; 

@end
