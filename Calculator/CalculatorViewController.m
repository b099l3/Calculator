//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Iain Smith on 19/11/2011.
//  Copyright (c) 2011 b099l3. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display = _display;
@synthesize brainHistoryDisplay = _brainHistoryDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}
- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = sender.currentTitle;
    
    if ([sender.currentTitle isEqualToString:@"."]) {
        if (self.userIsInTheMiddleOfEnteringANumber) {
            NSRange range = [self.display.text rangeOfString:@"."];
            if (range.location != NSNotFound) {
                digit = @"";
            }
        }
    }
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed 
{
    NSRange range = [self.brainHistoryDisplay.text rangeOfString:@" ="];
    if (range.location != NSNotFound) {
        self.brainHistoryDisplay.text = [NSString stringWithFormat:@"%@", [self.brainHistoryDisplay.text substringToIndex:[self.brainHistoryDisplay.text length] - 2]];
    }
    
    
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.brainHistoryDisplay.text = [self.brainHistoryDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %@", self.display.text]];
}

- (IBAction)operationPressed:(UIButton *)sender 
{
    NSRange range = [self.brainHistoryDisplay.text rangeOfString:@" ="];
    if (range.location != NSNotFound) {
        self.brainHistoryDisplay.text = [NSString stringWithFormat:@"%@", [self.brainHistoryDisplay.text substringToIndex:[self.brainHistoryDisplay.text length] - 2]];
    }
    
    if (self.userIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
    self.display.text = [NSString stringWithFormat:@"%g",result];
    self.brainHistoryDisplay.text = [self.brainHistoryDisplay.text stringByAppendingString:[NSString stringWithFormat:@" %@", sender.currentTitle]];
    self.brainHistoryDisplay.text = [self.brainHistoryDisplay.text stringByAppendingString:@" ="];
    
}

- (IBAction)clearPressed:(id)sender 
{
    [self.brain clearProgramStack];
    self.display.text = @"0";
    self.brainHistoryDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backPressed {
    if ( [self.display.text length] > 1 && [self.display.text doubleValue] != 0 )
    {        
        self.display.text = [NSString stringWithFormat:@"%@", [self.display.text substringToIndex:[self.display.text length] - 1]];
    } else if ([self.display.text length] == 1 || [self.display.text doubleValue] == 0 )
    {
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (void)viewDidUnload {
    [self setBrainHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
