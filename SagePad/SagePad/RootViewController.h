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
#import "DBManagerDelegate.h"
#import "DBManager.h"

@interface RootViewController : UIViewController <DBManagerDelegate> {    
    ConfigViewController *configViewController;
    FileTableViewController *fileTableViewController;
    SagePadViewController *sagePadViewController;
    
    DBManager *dropboxManager;
}

- (IBAction)configButtonPressed:(id)sender;
- (IBAction)fileButtonPressed:(id)sender;

@end
