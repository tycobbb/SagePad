//
//  SagePadViewController.h
//  SagePad
//
//  Created by Jakub Misterka on 11/9/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "PointerService.h"

@interface SagePadViewController : UIViewController {
    PointerService *pointerService;
    DBRestClient *restClient; // dropbox client
}

@end



