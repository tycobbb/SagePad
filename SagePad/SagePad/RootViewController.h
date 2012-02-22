//
//  RootViewController.h
//  SagePad
//
//  Created by Matthew Cobb on 11/26/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigViewController.h"
#import "FileTableViewController.h"
#import "SagePadViewController.h"
#import "DBFileTypeDelegate.h"
#import "DBDirectory.h"

@interface RootViewController : UIViewController <DBFileTypeDelegate> {    
    ConfigViewController *configViewController;
    FileTableViewController *fileTableViewController;
    SagePadViewController *sagePadViewController;
    
    DBDirectory *pushDirectory;
}

- (IBAction)configButtonPressed:(id)sender;
- (IBAction)fileButtonPressed:(id)sender;

@end
