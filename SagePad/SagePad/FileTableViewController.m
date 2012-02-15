//
//  FileTableViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "FileTableViewController.h"
#import "SagePadConstants.h"
#import "DBFileType.h"

@implementation FileTableViewController

@synthesize rootMetadata;

// --- "private" helper methods ---

- (void)parse:(DBMetadata *)metadata into:(DBDirectory *)directory {
    NSLog(@"Folder '%@' contains:", directory.name);
    for(DBMetadata *data in metadata.contents) {
        if(data.isDirectory) {
            [directory.contents addObject:[[DBDirectory alloc] initWithName: data.path]];
            [self parse:data into: [directory.contents lastObject]];
        } else {
            [directory.contents addObject:[[DBFileType alloc] initWithName:data.filename]];
            NSLog(@"\t%@", [[directory.contents lastObject] name]);
        }
    }
}

// --- "public" methods ---

- (id)init
{
    self = [super init];
    if (self) {
        rootDirectory = [[DBDirectory alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [rootDirectory release];
    rootDirectory = [[DBDirectory alloc] initWithName:rootMetadata.path];
    [self parse:rootMetadata into:rootDirectory];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FILE_TREE_CELL_ID];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FILE_TREE_CELL_ID] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSLog(@"GO: %@", ((DBFileType *)[rootDirectory.contents objectAtIndex:0]).name);
    //cell.textLabel.text = [[rootDirectory.contents objectAtIndex:indexPath.row] name];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [rootDirectory.contents count];
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {

    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [rootMetadata release];
    
    [super dealloc];
}


@end
