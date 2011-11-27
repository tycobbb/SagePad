//
//  RootViewController.h
//  SagePad
//
//  Created by Matthew Cobb on 11/26/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigViewController.h"
#import "SagePadViewController.h"

@interface RootViewController : UIViewController {    
    ConfigViewController *configViewController;
    SagePadViewController *sagePadViewController;
}

- (IBAction)configButtonPressed:(id)sender;
- (IBAction)fileButtonPressed:(id)sender;

@end
