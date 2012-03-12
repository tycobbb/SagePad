//
//  RootViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 11/26/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "RootViewController.h"
#import "SagePadConstants.h"
#import "SagePadSettings.h"
#import "InputTranslator.h"
#import "OutputTranslator.h"
#import "Client.h"
#import "FtpClient.h"

@interface RootViewController ()
    - (NetworkingService *)initNetworkingService;
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        configViewController = [[ConfigViewController alloc] init];
        fileTableViewController = [[FileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        sagePadViewController = [[SagePadViewController alloc] init];
        
        NetworkingService *networkingService = [self initNetworkingService];
        fileTableViewController.networkingService = networkingService;
        sagePadViewController.networkingService = networkingService;
        [networkingService release];
    }
    
    return self;
}

// initialize and start the networking service
- (NetworkingService *)initNetworkingService {
    CGFloat width = CGRectGetWidth(sagePadViewController.view.bounds);
    CGFloat height = CGRectGetHeight(sagePadViewController.view.bounds); // need to account for status bar...
    
    SagePadSettings *sagePadSettings = [[SagePadSettings alloc] init];
    InputTranslator *inputTranslator = [[InputTranslator alloc] init];
    OutputTranslator *outputTranslator = [[OutputTranslator alloc] initWithDeviceWidth:width andHeight:height];
    Client *client = [[Client alloc] initWithIp:[sagePadSettings.ipAddress copy]
                                  andPortNumber:[sagePadSettings.portNumber integerValue]];
    FtpClient *ftpClient = [[FtpClient alloc] initWithIp:[sagePadSettings.ipAddress copy]];
    NetworkingService *networkingService = [[NetworkingService alloc] initWithInputTranslator:inputTranslator 
                                                                          andOutputTranslator:outputTranslator
                                                                                    andClient:client
                                                                                 andFtpClient:ftpClient];
    [sagePadSettings release];
    [inputTranslator release];
    [outputTranslator release];
    [client release];
    [ftpClient release];
    
    return networkingService;
    //[networkingService startClient];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
        
    // setup gesture recognizer to swipe right to home view
    UISwipeGestureRecognizer *twoFingerSwipe = 
        [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(handleSwipeLeft:)];
    twoFingerSwipe.numberOfTouchesRequired = 2;
    [twoFingerSwipe setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:twoFingerSwipe];
    [twoFingerSwipe release];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
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
        NSLog(@"attempt to create root");
        pushDirectory = [[DBDirectory alloc] initAsRoot];
        pushDirectory.delegate = self;
    }
}

- (void)handleDirectoryReady {
    fileTableViewController.currentDirectory = pushDirectory;
    [[self navigationController] pushViewController:fileTableViewController animated:YES];
}

- (void)handleDirectoryLoadFailure:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Connect to Dropbox" 
                                                    message:[error localizedDescription]
                                                   delegate:self 
                                          cancelButtonTitle:@"Okay"
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
    [fileTableViewController release];
    [pushDirectory release];
        
    [super dealloc];
}

@end
