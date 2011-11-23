//
//  AbstractServer.h
//  SagePad
//
//  Created by Jakub Misterka on 11/22/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractInputTranslator.h"
#import "AbstractOutputTranslator.h"

@protocol AbstractServer <NSObject>

@required
- (id)initWithIp:(NSString *)_ipAddress andPortNumber:(NSInteger *)_portNumber;
- (void)startWithInputTranslator:(id<AbstractInputTranslator> *)_inputTranslator andOutputTranslator:(id<AbstractOutputTranslator> *)_outputTranslator;

- (NSString *)getIpAddress;
- (NSInteger *)getPortNumber;

- (id<AbstractInputTranslator>)getInputStreamTranslator;
- (id<AbstractOutputTranslator>)getOutputStreamTranslator;
    
@end
