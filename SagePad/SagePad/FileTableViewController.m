//
//  FileTableViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "FileTableViewController.h"
#import "NetworkingService.h"
#import "SagePadConstants.h"
#import "DBManager.h"
#import "DBBasicFile.h"

@implementation FileTableViewController

@synthesize currentDirectory = _currentDirectory;

// --- "private" helper methods ---

// --- "public" methods ---

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self) {

    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [[self tableView] reloadData];
}

// UITableViewDataSource protocol implementation
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FILE_TREE_CELL_ID];
    if(cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FILE_TREE_CELL_ID] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSMutableArray *dataSection = (indexPath.section == 0) ? _currentDirectory.children : _currentDirectory.files;
    cell.textLabel.text = [[dataSection objectAtIndex:indexPath.row] name];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? [_currentDirectory.children count] : [_currentDirectory.files count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch(section) {
        case 0:
            if([_currentDirectory.children count] == 0) {
                return ([_currentDirectory.files count] == 0) ? DIRECTORY_EMPTY_SECTION_TITLE : @"";
            } else {
                return DIRECTORY_SECTION_TITLE;
            }
            break;
        case 1:
            return ([_currentDirectory.files count] == 0) ? @"" : FILES_SECTION_TITLE;
            break;
        default:
            return @"";
    }
}

// UITableViewDelegate protocol implementation
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section) {
        case 0: {
            if(!childFileTableViewController) childFileTableViewController = [[FileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            
            DBDirectory *pushDirectory = [_currentDirectory.children objectAtIndex:indexPath.row];
            pushDirectory.delegate = self;
            
            childFileTableViewController.currentDirectory = pushDirectory;
            [pushDirectory populate];
            break;
        } case 1: {
            DBBasicFile *dropboxFile = [_currentDirectory.files objectAtIndex:indexPath.row];
            [dropboxFile download];
            break;
        } default:
            break;
    }
}

- (void)handleDirectoryReady {
    [[self navigationController] pushViewController:childFileTableViewController animated:YES];
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

- (void)handleFileLoaded:(NSString *)path {
    NSLog(@"Got file at: %@", path);
    
}

- (void)handleFileLoadFailure:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to Download File" 
                                                    message:[error localizedDescription]
                                                   delegate:self 
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
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
    [_currentDirectory release];
    
    [super dealloc];
}


@end
