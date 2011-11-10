//
//  SagePadViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 10/20/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "SagePadViewController.h"

@implementation SagePadViewController
@synthesize touchBeginLabel;
@synthesize touchMovedLabel;
@synthesize touchFinishedLabel;

NSInputStream *inputStream;
NSOutputStream *outputStream;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)handleNewTouch:(CGPoint *)touchCoordinates {
    self.touchBeginLabel.text = [NSString stringWithFormat:@"Began touch at: (%4.0f,%4.0f)", touchCoordinates->x, touchCoordinates->y];
}

- (void)handleMovedTouch:(CGPoint *)touchCoordinates {
    self.touchMovedLabel.text = [NSString stringWithFormat:@"Moved to: (%4.0f,%4.0f)", touchCoordinates->x, touchCoordinates->y];
}

- (void)handleFinishedTouch:(CGPoint *)touchCoordinates {
    self.touchFinishedLabel.text = [NSString stringWithFormat:@"Finished touch at: (%4.0f,%4.0f)", touchCoordinates->x, touchCoordinates->y];
}

- (void)viewDidUnload
{
    [self setTouchBeginLabel:nil];
    [self setTouchMovedLabel:nil];
    [self setTouchFinishedLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)initNetworkCommunication {
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"localhost", 5000, &readStream, &writeStream);
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (IBAction)connectServer:(id)sender {
    [self initNetworkCommunication];
    while(!outputStream.hasSpaceAvailable){}
    if(outputStream.hasSpaceAvailable){
        NSString *response  = [NSString stringWithFormat:@"GET SAGE HTTP/1.1"];
        NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
        [outputStream write:[data bytes] maxLength:[data length]];
    }
    while(!inputStream.hasBytesAvailable){}
    if(inputStream.hasBytesAvailable){
        uint8_t buffer[1024];
        int len;
        
        while ([inputStream hasBytesAvailable]) {
            len = [inputStream read:buffer maxLength:sizeof(buffer)];
            if (len > 0) {
                
                NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                
                if (nil != output) {
                    NSLog(@"server said: %@", output);
                    //self.connectInfo.text = output;
                }
            }
        }
    }
    
}

- (void)dealloc {
    [touchBeginLabel release];
    [touchMovedLabel release];
    [touchFinishedLabel release];
    [super dealloc];
}
@end
