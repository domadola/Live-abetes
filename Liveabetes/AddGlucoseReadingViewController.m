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
        GlucoseReading *reading = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"GlucoseReading"
                                            inManagedObjectContext:self.context];
        reading.mgdl = [NSNumber numberWithInt:[self.glucoseNumber.text intValue]];
        reading.date = self.timePicker.date;

        self.reading = reading;
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

-(NSDateFormatter *)timeFormatter
{
    if (!_timeFormatter) {
        _timeFormatter = [[NSDateFormatter alloc] init];
        [_timeFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [_timeFormatter setDateStyle:NSDateFormatterNoStyle];
    }
    
    return _timeFormatter;
}

-(void)updateTimeLabelToTimePicker
{
    self.timeLabel.text = [self.timeFormatter stringFromDate:self.timePicker.date];
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
