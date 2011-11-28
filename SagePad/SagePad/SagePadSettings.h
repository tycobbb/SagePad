//
//  SagePadSettings.h
//  SagePad
//
//  Created by Matthew Cobb on 11/27/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SagePadSettings : NSObject

@property (readonly, nonatomic) NSString *ipAddress;
@property (readonly, nonatomic) NSNumber *portNumber;
@property (readonly, nonatomic) NSString *pointerName;
@property (readonly, nonatomic) NSString *pointerColor;
@property (readonly, nonatomic) NSNumber *sensitivity;
@property (readonly, nonatomic, retain) NSMutableDictionary *dictionary;

- (void)refreshSettings;
- (void)writeCurrentDictionary;
- (void)writeValue:(id)value forKey:(NSString *)key;

@end
