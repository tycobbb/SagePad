//
//  ConfigViewController.m
//  SagePad
//
//  Created by Matthew Cobb on 11/26/11.
//  Copyright 2011 UIC. All rights reserved.
//

#import "ConfigViewController.h"

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

- (BOOL)validateIpField:(NSString *)resultString {
    NSArray *ipChunks = [resultString componentsSeparatedByString:@"."];
    NSInteger numChunks = ipChunks.count;
    if(numChunks < 5) {
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

- (BOOL)validatePortField:(NSString *)resultString {
    NSCharacterSet *portCharacterSet = [NSCharacterSet characterSetWithCharactersInString:resultString];
    return [decimalDigitCharacterSet isSupersetOfSet:portCharacterSet] && resultString.length < 6;
}

- (BOOL)validateNameField:(NSString *)resultString {
    return resultString.length < 21;
}

- (BOOL)validateColorField:(NSString *)resultString {
    NSString *colorValue = [resultString substringFromIndex:1];
    NSCharacterSet *colorValueCharacterSet = [NSCharacterSet characterSetWithCharactersInString:colorValue];
    if([resultString characterAtIndex:0] == '#')
        return colorValue.length < 7 && [alphanumericCharacterSet isSupersetOfSet:colorValueCharacterSet];
    else       
        return resultString.length == 0;
}

- (BOOL)validateSensitivityField:(NSString *)resultString {
    NSCharacterSet *sensitivtyCharacterSet = [NSCharacterSet characterSetWithCharactersInString:resultString];
    return [decimalDigitCharacterSet isSupersetOfSet:sensitivtyCharacterSet] && resultString.length < 3;
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
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)newString {
    NSInteger leftEnd = range.location, rightBegin = range.location + range.length;
    NSString *resultString = [NSString stringWithFormat:@"%@%@%@", [textField.text substringToIndex:leftEnd], 
                                 newString, [textField.text substringFromIndex:rightBegin]];
    
    if(textField == ipTextField) return [self validateIpField:resultString];
    if(textField == portTextField) return [self validatePortField:resultString];
    if(textField == sensitivityTextField && [self validateSensitivityField:resultString]) {
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
