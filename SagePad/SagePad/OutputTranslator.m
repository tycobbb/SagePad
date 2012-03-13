//
//  OutputTranslator.m
//  SagePad
//
//  Created by Matthew Cobb on 11/19/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "OutputTranslator.h"
#import "InputTranslator.h"

@interface OutputTranslator ()

- (void)initRegex;

- (void)setPreviousTouch:(CGPoint *)newTouch;
- (void)calculateNewSageLocation:(CGPoint *)newTouch;

- (MEDIA_TYPE)getMediatype:(NSString *)path;

- (void)formatPointerMsgAndNotifyClient:(NSInteger)outputType;
- (void)formatPointerMsgAndNotifyClient:(NSInteger)outputType withParam1:(NSString *)param1 
                              andParam2:(NSString *)param2; 
- (void)formatPointerMsgAndNotifyClient:(NSInteger)outputType withParam1:(NSString *)param1 
                              andParam2:(NSString *)param2 
                              andParam3:(NSString *)param3;
- (void)formatFileMsgAndNotifyClient:(NSInteger)outputType withMediatype:(MEDIA_TYPE)mediatype
                         andFilename:(NSString *)filename
                         andFilesize:(NSInteger)filesize;

- (void)notifyOutputReady:(NSString *)output withSize:(SAGE_MSG_SIZE)size;

@end

@implementation OutputTranslator

@synthesize delegate = _delegate;
@synthesize sageConfiguration = _sageConfiguration;

// --- "public" methods ---
- (id)initWithDeviceWidth:(CGFloat)deviceWidth andHeight:(CGFloat)deviceHeight {
    self = [super init];
    if (self) {
        settings = [[SagePadSettings alloc] init];

        xAtom = deviceWidth; // not yet the atomic values...
        yAtom = deviceHeight;        
        
        pointerAlreadyShared = NO;        
        previousTouch.x = 0;
        previousTouch.y = 0;
        sageLocation.x = 0;
        sageLocation.y = 0;
        firstPinch = 0;
        
        fileManager = [[NSFileManager alloc] init];
    }
    
    return self;
}

- (void)initRegex {
    pictureRegex = [[NSRegularExpression alloc] initWithPattern:@"bmp|svg|tif|tiff|png|jpg|bmp|gif|xpm|jpeg" 
                                                        options:NSRegularExpressionCaseInsensitive 
                                                          error:NULL];
    videoRegex = [[NSRegularExpression alloc] initWithPattern:@"avi|mov|mpg|mpeg|mp4|mkv|flv|wmv" 
                                                      options:NSRegularExpressionCaseInsensitive 
                                                        error:NULL];
    pdfRegex = [[NSRegularExpression alloc] initWithPattern:@"pdf" 
                                                    options:NSRegularExpressionCaseInsensitive 
                                                      error:NULL];
    pluginRegex = [[NSRegularExpression alloc] initWithPattern:@"so|dll|dylib" 
                                                       options:NSRegularExpressionCaseInsensitive 
                                                         error:NULL];
}

- (void)handleSageConfiguration:(SageConfiguration *)configuration {
    _sageConfiguration = configuration;

    xAtom = _sageConfiguration.width / xAtom * [settings.sensitivity floatValue] / 100.0; // now the atomic values are set correctly
    yAtom = _sageConfiguration.height / yAtom * [settings.sensitivity floatValue] / 100.0;
}

- (void)sharePointer {
    [self formatPointerMsgAndNotifyClient:POINTER_SHARE withParam1:settings.pointerName andParam2:settings.pointerColor];
    pointerAlreadyShared = YES;
}

- (void)unsharePointer {
    [self formatPointerMsgAndNotifyClient:POINTER_UNSHARE];
    pointerAlreadyShared = NO;
}

- (void)translateMove:(CGPoint *)newTouch isFirst:(BOOL)isFirst {
    if(!pointerAlreadyShared) return;
    if(isFirst) {
        [self setPreviousTouch:newTouch];
        return;
    }
    
    [self calculateNewSageLocation:newTouch];    
    [self formatPointerMsgAndNotifyClient:POINTER_MOVING 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translatePinch:(CGFloat *)scale {
    if(!pointerAlreadyShared) return;
    CGFloat changeScale = *scale - 1;
    if (changeScale < 0) changeScale *= 10;
    [self formatPointerMsgAndNotifyClient:POINTER_WHEEL 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]
                            andParam3:[NSString stringWithFormat:@"%d", (NSInteger)changeScale]];
}

- (void)translatePress:(CGPoint *)newTouch {
    if(!pointerAlreadyShared) return;
    [self setPreviousTouch:newTouch];
    [self formatPointerMsgAndNotifyClient:POINTER_PRESS 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translateDrag:(CGPoint *)newTouch {
    if(!pointerAlreadyShared) return;
    [self calculateNewSageLocation:newTouch];    
    [self formatPointerMsgAndNotifyClient:POINTER_DRAGGING 
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translateRelease:(CGPoint *)newTouch {
    if(!pointerAlreadyShared) return;
    [self formatPointerMsgAndNotifyClient:POINTER_RELEASE
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)translateClick:(CGPoint *)newTouch {
    if(!pointerAlreadyShared) return;
    [self formatPointerMsgAndNotifyClient:POINTER_CLICK
                           withParam1:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.x] 
                            andParam2:[NSString stringWithFormat:@"%d", (NSInteger)sageLocation.y]];
}

- (void)sendFileHeader:(NSString *)path {
    [self formatFileMsgAndNotifyClient:0 
                         withMediatype:[self getMediatype:path] 
                           andFilename:path
                           andFilesize:[[fileManager attributesOfItemAtPath:path error:NULL] fileSize]];
}

- (void) dealloc {
    [settings release];
    [fileManager release];
    [_sageConfiguration release];
    
    [pictureRegex release];
    [videoRegex release];
    [pdfRegex release];
    [pluginRegex release];
    
    [super dealloc];
}

// --- "private" helper methods ---
//   -- coordinate calculation helpers
- (void)setPreviousTouch:(CGPoint *)newTouch {
    previousTouch.x = newTouch->x;
    previousTouch.y = newTouch->y;
}

- (void)calculateNewSageLocation:(CGPoint *)newTouch {
    CGFloat sageX = sageLocation.x + (newTouch->x - previousTouch.x) * xAtom;
    CGFloat sageY = sageLocation.y + (newTouch->y - previousTouch.y) * yAtom;
    
    if(sageX > _sageConfiguration.width) sageX = _sageConfiguration.width;
    else if(sageX < 0) sageX = 0;    
    if(sageY > _sageConfiguration.height) sageY = _sageConfiguration.height;
    else if(sageY < 0) sageY = 0;
    
    sageLocation.x = sageX;
    sageLocation.y = sageY;
    
    [self setPreviousTouch:newTouch];
}

// --- file helpers ---
- (MEDIA_TYPE)getMediatype:(NSString *)path {
    NSString *extension = [[path componentsSeparatedByString:@"."] lastObject];
    NSRange extensionRange = NSMakeRange(0, [extension length]);
    
    NSTextCheckingResult *match;
    match = [pictureRegex firstMatchInString:extension options:0 range:extensionRange];
    if(match) return MEDIA_TYPE_IMAGE;
    match = [videoRegex firstMatchInString:extension options:0 range:extensionRange];
    if(match) return MEDIA_TYPE_VIDEO;
    match = [pdfRegex firstMatchInString:extension options:0 range:extensionRange];
    if(match) return MEDIA_TYPE_PDF;
    match = [videoRegex firstMatchInString:extension options:0 range:extensionRange];
    if(match) return MEDIA_TYPE_PLUGIN;
    return MEDIA_TYPE_UNKNOWN;
}

//  -- output message formatters
- (void)formatPointerMsgAndNotifyClient:(NSInteger)outputType {
    [self notifyOutputReady:[NSString stringWithFormat:@"%d %u", outputType, _sageConfiguration.pointerId]
                   withSize:SML_MSG_SIZE];
}

- (void)formatPointerMsgAndNotifyClient:(NSInteger)outputType withParam1:(NSString *)param1 
                              andParam2:(NSString *)param2 {
    [self notifyOutputReady:[NSString stringWithFormat:@"%d %u %@ %@", outputType, _sageConfiguration.pointerId, param1, param2]
                   withSize:SML_MSG_SIZE];
}

- (void)formatPointerMsgAndNotifyClient:(NSInteger)outputType withParam1:(NSString *)param1 
                              andParam2:(NSString *)param2 
                              andParam3:(NSString *)param3 {
    [self notifyOutputReady:[NSString stringWithFormat:@"%d %u %@ %@ %@", outputType, _sageConfiguration.pointerId, param1, param2, param3]
                   withSize:SML_MSG_SIZE];
}

- (void)formatFileMsgAndNotifyClient:(NSInteger)outputType withMediatype:(MEDIA_TYPE)mediatype
                         andFilename:(NSString *)filename
                         andFilesize:(NSInteger)filesize {
    [self notifyOutputReady:[NSString stringWithFormat:@"%d %d %@ %d", outputType, mediatype, filename, filesize]
                   withSize:LRG_MSG_SIZE];
}

- (void)notifyOutputReady:(NSString *)output withSize:(SAGE_MSG_SIZE)size {
    [_delegate handleOutputReady:output withSize:size];
}

@end
