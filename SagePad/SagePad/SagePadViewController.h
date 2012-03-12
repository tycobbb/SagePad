//
//  SagePadViewController.h
//  SagePad
//
//  Created by Jakub Misterka on 11/9/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "NetworkingService.h"

@interface SagePadViewController : UIViewController {
    DBRestClient *restClient; // dropbox client
}

@property (nonatomic, retain) NetworkingService *networkingService;

@end



