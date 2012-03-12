//
//  FileTableViewController.h
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "DBManagerDelegate.h"
#import "DBDirectory.h"
#import "NetworkingService.h"

@interface FileTableViewController : UITableViewController 
        <UITableViewDelegate, UITableViewDataSource, DBFileTypeDelegate> {
    
    FileTableViewController *childFileTableViewController;
}

@property (nonatomic, retain) DBDirectory *currentDirectory;
@property (nonatomic, retain) NetworkingService *networkingService;

- (id)initWithStyle:(UITableViewStyle)style;
- (id)initWithStyle:(UITableViewStyle)style andNetworkingService:(NetworkingService *)networkingService;

@end
