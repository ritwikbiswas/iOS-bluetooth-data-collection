#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "BLE.h"

@interface TableViewController : UITableViewController <BLEDelegate>
{
    IBOutlet UIButton *btnConnect;
    
    //A0
    IBOutlet UISwitch *swAnalogIn;
    IBOutlet UILabel *lblAnalogIn;
    
    //A1
   
    IBOutlet UISwitch *swAnalogInTwo;
    IBOutlet UILabel *lblAnalogInTwo;
    
    //A2
    IBOutlet UISwitch *swAnalogInThree;
    IBOutlet UILabel *lblAnalogInThree;
    
    //A3
    IBOutlet UISwitch *swAnalogInFour;
    IBOutlet UILabel *lblAnalogInFour;
    
    
    //A4
    IBOutlet UISwitch *swAnalogInFive;
    IBOutlet UILabel *lblAnalogInFive;
    
    
    //A5
    IBOutlet UISwitch *swAnalogInSix;
    IBOutlet UILabel *lblAnalogInSix;
    
    
    //A6
    IBOutlet UISwitch *swAnalogInSeven;
    IBOutlet UILabel *lblAnalogInSeven;
    
    
    //A7
    IBOutlet UISwitch *swAnalogInEight;
    IBOutlet UILabel *lblAnalogInEight;
    
    
    //A8
    IBOutlet UISwitch *swAnalogInNine;
    IBOutlet UILabel *lblAnalogInNine;
    
    
    IBOutlet UILabel *connected_label;
    
    IBOutlet UILabel *accel_con;
    IBOutlet UILabel *us_3_con;
    IBOutlet UILabel *us_2_con;
    IBOutlet UILabel *us_1_con;
    
    IBOutlet UIActivityIndicatorView *indConnecting;
    IBOutlet UILabel *lblRSSI;
    
    //Labels of values
    IBOutlet UILabel *us1lbl;
    IBOutlet UILabel *us2lbl;
    IBOutlet UILabel *us3lbl;
    IBOutlet UILabel *a1;
    IBOutlet UILabel *a2;
    IBOutlet UILabel *a3;
    IBOutlet UILabel *a4;
    IBOutlet UILabel *a5;
    IBOutlet UILabel *a6;
    
    
    IBOutlet UISegmentedControl *segmentedController;
}

@property (strong, nonatomic) BLE *ble;

@property(nonatomic,retain) NSMutableArray *LiveData;


//Whether both sensors are switched on
//extern bool logic_switch_1, logic_switch_2, logic_switch_3, logic_switch_4, logic_switch_5, logic_switch_6, logic_switch_7, logic_switch_8, logic_switch_9;

//Whether the sensor is triggered or not
extern bool sensor_1, sensor_2, sensor_3, sensor_4, sensor_5, sensor_6, sensor_7, sensor_8, sensor_9;

//Whether to do And(F) or Or(T) 
extern bool switch_state;

@end
