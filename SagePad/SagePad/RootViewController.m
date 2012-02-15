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
        configViewController = [[ConfigViewController alloc] init];
        fileTableViewController = [[FileTableViewController alloc] init];
        sagePadViewController = [[SagePadViewController alloc] init];
        
        dropboxManager = [[DropboxManager alloc] init];
        dropboxManager.delegate = self;
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
    if(![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] link];
    }
    
    if([[DBSession sharedSession] isLinked]) {
        [dropboxManager requestFileList];        
    }
}

- (void)handleDirectoryMetadata:(DBMetadata *)metadata {
    fileTableViewController.rootMetadata = metadata;
    [[self navigationController] pushViewController:fileTableViewController animated:YES];
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
    [fileTableViewController release];
    
    [dropboxManager release];
    
    [super dealloc];
}

@end
