//
//  RootViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 11/26/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sagePadViewController = [[SagePadViewController alloc] init];
        configViewController = [[ConfigViewController alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    // setup gesture recognizer to swipe right to home view
    UISwipeGestureRecognizer *twoFingerSwipe = 
        [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleSwipeLeft:)];
    twoFingerSwipe.numberOfTouchesRequired = 2;
    [twoFingerSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:twoFingerSwipe];
    [twoFingerSwipe release];
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)swipeLeft {
    [[self navigationController] pushViewController:sagePadViewController animated:YES];
}

- (IBAction)configButtonPressed:(id)sender {
    [[self navigationController] pushViewController:configViewController animated:YES];
}

- (IBAction)fileButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"File Upload" 
                                                    message:@"This feature is not yet implemented." 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Swag"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [sagePadViewController release];
    [configViewController release];
    
    [super dealloc];
}

@end
