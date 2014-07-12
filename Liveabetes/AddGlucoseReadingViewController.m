//
//  AddGlucoseReadingViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/9/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "AddGlucoseReadingViewController.h"

@interface AddGlucoseReadingViewController ()
@property (weak, nonatomic) IBOutlet UITextField *glucoseNumber;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation AddGlucoseReadingViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender != self.saveButton) return;
    
    if (self.glucoseNumber.text.length > 0) {
        self.info = [[GlucoseInfo alloc] init];
        self.info.readingMgDl = [NSNumber numberWithInt:[self.glucoseNumber.text intValue]];
        //info.date = [[NSDate init] alloc];
        self.info.date = self.timePicker.date;
        self.info.completed = NO;
    }
}

- (IBAction)backgroundClick:(id)sender
{
    [self.glucoseNumber resignFirstResponder];
}

- (IBAction)timePickerValueChanged:(id)sender
{
    [self updateTimeLabelToTimePicker];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.glucoseNumber becomeFirstResponder];
    [self updateTimeLabelToTimePicker];
}

-(void)updateTimeLabelToTimePicker
{
    if(!self.dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
    }
    
    self.timeLabel.text = [self.dateFormatter stringFromDate:self.timePicker.date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
