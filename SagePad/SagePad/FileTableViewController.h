//
//  FileTableViewController.h
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "DBDirectory.h"

@interface FileTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource> {
    DBDirectory *rootDirectory;
}

@property (nonatomic, assign) DBMetadata *rootMetadata;

@end
