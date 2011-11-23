//
//  OutputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OutputStreamTranslator.h"

@interface OutputTranslator : NSObject <AbstractOutputTranslator> {
    NSString *notificationName;
    
    NSInteger *sageHeight;
    NSInteger *sageWidth;
    NSInteger *pointerId;
}

@end
