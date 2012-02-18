//
//  FileTableViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 2/14/12.
//  Copyright 2012 UIC. All rights reserved.
//

#import "FileTableViewController.h"
#import "SagePadConstants.h"
#import "DBManager.h"

@implementation FileTableViewController

@synthesize currentDirectory = _currentDirectory;

// --- "private" helper methods ---

// --- "public" methods ---

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if(self) {
        dropboxManager = [[DBManager alloc] init];
        dropboxManager.delegate = self;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];

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
            childFileTableViewController.currentDirectory = [_currentDirectory.children objectAtIndex:indexPath.row];
            [[self navigationController] pushViewController:childFileTableViewController animated:YES];
            break;
        } case 1: {
            NSLog(@"Should download selected item and push to wall");
            break;
        } default:
            break;
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
    [_currentDirectory release];
    
    [super dealloc];
}


@end
