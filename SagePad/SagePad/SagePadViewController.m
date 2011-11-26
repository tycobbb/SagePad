//
//  SagePadViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 10/20/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "SagePadViewController.h"
#import "InputTranslator.h"
#import "OutputTranslator.h"

@implementation SagePadViewController 
// example synthesizing properties 
//@synthesize touchLabel

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// additional setup after loading the view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // setup gesture recognizer to swipe right to home view
    UISwipeGestureRecognizer *twoFingerSwipe = 
        [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleSwipeRight:)];
    twoFingerSwipe.numberOfTouchesRequired = 2;
    [twoFingerSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:twoFingerSwipe];
    [twoFingerSwipe release];
    
    // instantiate and start networking service upon entering the pointer view
    NSLog(@"Initializing Networking Service");
    networkingService = [[NetworkingService alloc] initWithIp:@"localhost" 
                   withPortNumber:30000 
              withInputTranslator:[[InputTranslator alloc] init] 
             withOutputTranslator:[[OutputTranslator alloc] init]];
    NSLog(@"SagePadViewController: about to call networkingService.startServer");
    [networkingService startServer];
    NSLog(@"SagePadViewController: networkingService.startServer returned");

}

// method to handle swipe event, direct back to the home view
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)swipeRight {
    CGPoint location = [swipeRight locationInView:[swipeRight.view superview]];
    NSLog(@"Captured a swipe left at (%f, %f).", location.x, location.y);
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchCoordinates = [[touches anyObject] locationInView:self.view];
    [networkingService translateTouchEvent:&touchCoordinates];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // not sure what to do with cancelled touch, or how a touch is cancelled
}

- (void)viewDidUnload {
    [networkingService release];
    // example setting properties to nil upon unload
    //    [self setTouchLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}

- (void)dealloc {
    // example release properties during dealloc
//    [touchLabel release];
    [super dealloc];
}

@end
