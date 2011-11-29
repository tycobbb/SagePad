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
// --- "private" helper methods ---

// setup gesture recognizer for swipe right (to home view)
- (void)addSwipeGestureRecognizer {
    UISwipeGestureRecognizer *twoFingerSwipe = 
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handleSwipeRight:)];
    twoFingerSwipe.numberOfTouchesRequired = 2;
    [twoFingerSwipe setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:twoFingerSwipe];
    [twoFingerSwipe release];
}

// setup gesture recognizer for pinch zoom
- (void)addPinchGestureRecognizer {
    UIPinchGestureRecognizer *pinch =
    [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(handlePinch:)];
    [self.view addGestureRecognizer:pinch];
    [pinch release];
}

// initialize and start the networking service
- (void)initNetworkingService {
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds); // need to account for status bar...

    NSLog(@"Initializing Networking Service");
    networkingService = [[NetworkingService alloc] initWithInputTranslator:[[InputTranslator alloc] init]  
                                                      withOutputTranslator:[[OutputTranslator alloc] initWithDeviceWidth:width 
                                                                                                               andHeight:height]];
    NSLog(@"Pointer: about to call networkingService.startServer");
    [networkingService startServer];
    NSLog(@"Pointer: networkingService.startServer returned");
}

// --- "public" methods ---

// additional setup after loading the view
- (void)viewDidLoad {
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    
    [self addSwipeGestureRecognizer];
    [self addPinchGestureRecognizer];
    [self initNetworkingService];   
    
    // hide the navigation bar
}

// method to handle swipe event, direct back to the home view
- (void)handleSwipeRight:(UISwipeGestureRecognizer *)swipeRight {
    CGPoint location = [swipeRight locationInView:[swipeRight.view superview]];
    NSLog(@"Pointer: captured a swipe right at (%f, %f).", location.x, location.y);
    [[self navigationController] popViewControllerAnimated:YES];
}


- (void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    NSLog(@"Pointer: captured pinch with scale %f", [pinch scale]); 
    CGFloat scalef = [pinch scale];
    switch(pinch.state){
        case UIGestureRecognizerStateBegan:
            [networkingService translatePinchBegan:&scalef];
            break;
        case UIGestureRecognizerStateChanged:
            [networkingService translatePinchEvent:&scalef];
            break;
        default:
            break;
    }
    [networkingService translatePinchEvent:&scalef];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if([touches count] > 1) { 
        NSLog(@"Pointer: captured touch with >1 fingers");
        return;
    }
    CGPoint touchCoordinates = [[touches anyObject] locationInView:self.view];
    NSLog(@"Pointer: standard touch coordinates (%f, %f).", touchCoordinates.x, touchCoordinates.y);
    [networkingService translateTouchEvent:&touchCoordinates];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    // not sure what to do with cancelled touch, or how a touch is cancelled
}

- (void)viewDidUnload {
    [networkingService stopServer];
    [networkingService release];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [networkingService release];
    [InputTranslator release];
    [OutputTranslator release];
    [super dealloc];
}

@end
