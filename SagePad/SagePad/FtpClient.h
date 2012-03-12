//
//  FtpClient.h
//  SagePad
//
//  Created by Jakub Misterka on 3/12/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Client.h"
#import "AbstractFtpClient.h"

@interface FtpClient : Client <AbstractFtpClient> {
    
@private
    
    NSFileManager *fileManager;
    
}

@end
