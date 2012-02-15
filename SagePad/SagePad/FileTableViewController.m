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
            [directory.children addObject:[[DBDirectory alloc] initWithName:data.path andParent:directory]];
            [self parse:data into:[directory.children lastObject]];
        } else {
            [directory.files addObject:[[DBFileType alloc] initWithName:data.filename]];
            NSLog(@"\t%@", [[directory.files lastObject] name]);
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
    rootDirectory = [[DBDirectory alloc] initWithName:rootMetadata.path andParent:nil];
    [self parse:rootMetadata into:rootDirectory];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FILE_TREE_CELL_ID];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FILE_TREE_CELL_ID] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSMutableArray *dataSection = (indexPath.section == 0) ? rootDirectory.children : rootDirectory.files;
    cell.textLabel.text = [[dataSection objectAtIndex:indexPath.row] name];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? [rootDirectory.children count] : [rootDirectory.files count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0:
            return DIRECTORY_SECTION_TITLE;
        case 1:
            return FILES_SECTION_TITLE;
        default:
            return @"";
    }
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
