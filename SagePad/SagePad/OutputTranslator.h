//
//  OutputTranslator.h
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractOutputTranslator.h"
#import "SagePadSettings.h"
#import "SagePadConstants.h"
#import "SageConfiguration.h"

@interface OutputTranslator : NSObject <AbstractOutputTranslator> {
    @private
    SagePadSettings *settings;

    // pointer specific instance vars
    BOOL pointerAlreadyShared;
    CGPoint sageLocation; // current coordinates of the SAGE pointer
    CGPoint previousTouch; // coordinates of the previous touch location read
    CGFloat firstPinch;
    CGFloat xAtom;
    CGFloat yAtom;
    
    // ftp specific instance vars
    NSFileManager *fileManager;
    
    NSRegularExpression *pictureRegex;
    NSRegularExpression *videoRegex;
    NSRegularExpression *pdfRegex;
    NSRegularExpression *pluginRegex;                                    
}

@end
