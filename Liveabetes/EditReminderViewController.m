//
//  EditReminderViewController.m
//  Liveabetes
//
//  Created by Dom Lamendola on 7/24/14.
//  Copyright (c) 2014 Lamendola. All rights reserved.
//

#import "EditReminderViewController.h"

@interface EditReminderViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;
@property (weak, nonatomic) IBOutlet UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UISwitch *repeatDailySwitch;

@end

@implementation EditReminderViewController

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
    self.informationTextView.delegate = self;
    if (self.isEditing) {
        Reminder *reminder = self.reminder;
        self.informationTextView.text = reminder.notes;
        self.timePicker.date = reminder.time;
        self.repeatDailySwitch.selected = (BOOL)reminder.repeatDaily;
    } else {
        self.title = @"Add Reminder";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)repeatDailyEdit:(id)sender
{
    NSLog(@"111111");
    [self.informationTextView resignFirstResponder];
}
- (IBAction)datePickerEdit:(id)sender
{
    NSLog(@"222222");
    [self.informationTextView resignFirstResponder];
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
    
    if (sender == self.saveButton) {
        if (!self.isEditing) {
            self.reminder = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Reminder"
                             inManagedObjectContext:self.context];

        } 
        self.reminder.notes = self.informationTextView.text;
        self.reminder.time = self.timePicker.date;
        self.reminder.repeatDaily = [NSNumber numberWithBool:[self.repeatDailySwitch isOn]];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
            UILocalNotification *localNotif = [[UILocalNotification alloc] init];
            if (localNotif == nil)
                return;
            localNotif.fireDate = self.reminder.time;
            localNotif.timeZone = [NSTimeZone defaultTimeZone];
            
            localNotif.alertBody = [NSString stringWithFormat:@"%@", self.reminder.notes];
//            localNotif.alertAction = NSLocalizedString(@"View Details", nil);
            
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            
            if (self.reminder.repeatDaily) {
                localNotif.repeatInterval = NSDayCalendarUnit;
            }
            
            
//            NSDictionary *infoDict = [NSDictionary dictionaryWithObject:item.eventName forKey:ToDoItemKey];
//            localNotif.userInfo = infoDict;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//        });
    }
}


@end
