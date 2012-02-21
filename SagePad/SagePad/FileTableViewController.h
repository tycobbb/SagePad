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

@interface FileTableViewController : UITableViewController 
        <UITableViewDelegate, UITableViewDataSource, DBDirectoryDelegate> {
    
    FileTableViewController *childFileTableViewController;
}

@property (nonatomic, retain) DBDirectory *currentDirectory;

- (id)initWithStyle:(UITableViewStyle)style;

@end
