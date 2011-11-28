//
//  ConfigViewController.h
//  SagePad
//
//  Created by Matthew Cobb on 11/26/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigViewController : UIViewController <UITextFieldDelegate> {    
    NSCharacterSet *decimalDigitCharacterSet;
    NSCharacterSet *alphanumericCharacterSet;
}

@property (nonatomic, retain) IBOutlet UITextField *ipTextField;
@property (nonatomic, retain) IBOutlet UITextField *portTextField;
@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *colorTextField;
@property (nonatomic, retain) IBOutlet UISlider *sensitvitySlider;
@property (nonatomic, retain) IBOutlet UITextField *sensitivityTextField;

- (IBAction)sensitivitySliderValueChanged:(UISlider *)sender;
- (IBAction)saveConfiguration:(id)sender;

@end
