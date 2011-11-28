//
//  ConfigViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 11/26/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "ConfigViewController.h"
#import "SagePadSettings.h"
#import "SagePadConstants.h"

@implementation ConfigViewController

@synthesize ipTextField;
@synthesize portTextField;
@synthesize nameTextField;
@synthesize colorTextField;
@synthesize sensitvitySlider;
@synthesize sensitivityTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        decimalDigitCharacterSet = NSCharacterSet.decimalDigitCharacterSet;
        alphanumericCharacterSet = NSCharacterSet.alphanumericCharacterSet;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// --- "private" helper methods ---

- (BOOL)validateIpField:(NSString *)resultString forSave:(BOOL)forSave {
    if(resultString.length == 0) return YES;
    NSArray *ipChunks = [resultString componentsSeparatedByString:@"."];
    NSInteger numChunks = ipChunks.count;
    if(numChunks < 5) {
        if(forSave && numChunks < 4) return NO;
        NSString *ipChunk;
        NSCharacterSet *ipChunkCharacterSet;
        for(NSUInteger i=0 ; i<numChunks ; i++) {
            ipChunk = [ipChunks objectAtIndex:i];
            ipChunkCharacterSet = [NSCharacterSet characterSetWithCharactersInString:ipChunk];
            if(ipChunk.length > 3 || ![decimalDigitCharacterSet isSupersetOfSet:ipChunkCharacterSet]) 
                return NO;
        }
        return YES;
    } // else, too many periods in the ip
    return NO;
}

- (BOOL)validatePortField:(NSString *)resultString forSave:(BOOL)forSave {
    NSCharacterSet *portCharacterSet = [NSCharacterSet characterSetWithCharactersInString:resultString];
    if([decimalDigitCharacterSet isSupersetOfSet:portCharacterSet]) 
        return (forSave) ? YES : resultString.length < 6;
    return NO;
}

- (BOOL)validateNameField:(NSString *)resultString forSave:(BOOL)forSave {
    return (forSave) ? YES : resultString.length < 21;
}

- (BOOL)validateColorField:(NSString *)resultString forSave:(BOOL)forSave {
    if(resultString.length == 0) return YES;
    NSString *colorValue = (resultString.length < 1) ? @"" : [resultString substringFromIndex:1];
    NSCharacterSet *colorValueCharacterSet = [NSCharacterSet characterSetWithCharactersInString:colorValue];
    if([resultString characterAtIndex:0] == '#' && [alphanumericCharacterSet isSupersetOfSet:colorValueCharacterSet])
        return (forSave) ? colorValue.length == 6 : colorValue.length < 7;
    else
        return (forSave) ? NO : resultString.length == 0;
}

- (BOOL)validateSensitivityField:(NSString *)resultString forSave:(BOOL)forSave {
    NSCharacterSet *sensitivtyCharacterSet = [NSCharacterSet characterSetWithCharactersInString:resultString];
    if([decimalDigitCharacterSet isSupersetOfSet:sensitivtyCharacterSet])
        return (forSave) ? YES : resultString.length < 3;
    return NO;
}

- (BOOL)colorField:(UITextField *)textField {
    
    return YES;
}

// --- "public" methods ---

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ipTextField setDelegate:self];
    [portTextField setDelegate:self];
    [nameTextField setDelegate:self];
    [colorTextField setDelegate:self];
    [sensitivityTextField setDelegate:self];
    sensitvitySlider.minimumValue = 0.01;
    
    SagePadSettings *sagePadSettings = [[SagePadSettings alloc] init];
    ipTextField.text = sagePadSettings.ipAddress;
    portTextField.text = [sagePadSettings.portNumber stringValue];
    nameTextField.text = sagePadSettings.pointerName;
    colorTextField.text = sagePadSettings.pointerColor;
    sensitivityTextField.text = [sagePadSettings.sensitivity stringValue];
    [sagePadSettings release];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)newString {
    NSInteger leftEnd = range.location, rightBegin = range.location + range.length;
    NSString *resultString = [NSString stringWithFormat:@"%@%@%@", [textField.text substringToIndex:leftEnd], 
                                 newString, [textField.text substringFromIndex:rightBegin]];
    
    if(textField == ipTextField) return [self validateIpField:resultString forSave:NO];
    if(textField == portTextField) return [self validatePortField:resultString forSave:NO];
    if(textField == nameTextField) return [self validateNameField:resultString forSave:NO];
    if(textField == colorTextField) return [self validateColorField:resultString forSave:NO];
    if(textField == sensitivityTextField && [self validateSensitivityField:resultString forSave:NO]) {
        sensitvitySlider.value = (CGFloat)resultString.floatValue / 100;
        return YES;
    }
    // should never reach
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sensitivitySliderValueChanged:(UISlider *)sender {
    NSInteger roundedValue = (NSInteger)(sender.value * 100);
    sensitivityTextField.text = [NSString stringWithFormat:@"%d", roundedValue];
}

- (IBAction)saveConfiguration:(id)sender {
    BOOL errorExists = NO;
    if(![self validateIpField:ipTextField.text forSave:YES]) errorExists |= [self colorField:ipTextField];
    if(![self validatePortField:portTextField.text forSave:YES]) errorExists |= [self colorField:portTextField];
    if(![self validateNameField:nameTextField.text forSave:YES]) errorExists |= [self colorField:nameTextField];    
    if(![self validateColorField:colorTextField.text forSave:YES]) errorExists |= [self colorField:colorTextField];
    if(![self validateSensitivityField:sensitivityTextField.text forSave:YES]) errorExists |= [self colorField:sensitivityTextField];

    if(!errorExists) {
        NSMutableDictionary *settings = [SagePadSettings initDictionary];
        if(ipTextField.text.length > 0) [settings setValue:ipTextField.text forKey:SERVER_IP_KEY];
        if(portTextField.text.length > 0) [settings setValue:portTextField.text forKey:SERVER_PORT_KEY];
        
        if(nameTextField.text.length > 0) [settings setValue:nameTextField.text forKey:POINTER_NAME_KEY];
        if(colorTextField.text.length > 0) [settings setValue:colorTextField.text forKey:POINTER_COLOR_KEY];
        if(sensitivityTextField.text.length > 0) [settings setValue:sensitivityTextField.text forKey:POINTER_SENSITIVITY_KEY];
        
        [SagePadSettings writeSettingsDictionary:settings];
        [settings release];
    }
}

- (void)viewDidUnload {
    [self setIpTextField:nil];
    [self setPortTextField:nil];
    [self setNameTextField:nil];
    [self setColorTextField:nil];
    [self setSensitvitySlider:nil];
    [self setSensitivityTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)dealloc {
    [ipTextField release];
    [portTextField release];
    [nameTextField release];
    [colorTextField release];
    [sensitvitySlider release];
    [sensitivityTextField release];
    [super dealloc];
}

@end
