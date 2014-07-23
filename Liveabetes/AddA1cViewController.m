//
//  AddA1cViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/21/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "AddA1cViewController.h"

@interface AddA1cViewController ()
@property (weak, nonatomic) IBOutlet UITextField *a1cTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation AddA1cViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)datePickerChanged:(id)sender
{
    [self updateTimeLabelToTimePicker];
}
- (IBAction)backgroundClick:(id)sender
{
    [self.a1cTextField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateTimeLabelToTimePicker];
}

- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    
    return _dateFormatter;
}

-(void)updateTimeLabelToTimePicker
{
    self.dateLabel.text = [self.dateFormatter stringFromDate:self.datePicker.date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender != self.saveButton) return;
    if (self.context == nil) {
        NSLog(@"context is nil!");
    }
    if (self.a1cTextField.text.length > 0) {
        NSLog(@"creating new a1c");
        A1c *newA1c = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"A1c"
                                   inManagedObjectContext:self.context];
        newA1c.a1c = [NSNumber numberWithFloat:[self.a1cTextField.text floatValue]];
        newA1c.date = self.datePicker.date;
        
        self.a1c = newA1c;
    }
}


@end
