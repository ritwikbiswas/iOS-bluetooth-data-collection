#import "TableViewController.h"
//LightMap yo

@interface TableViewController ()

@end

@implementation TableViewController

@synthesize ble;

@synthesize LiveData;


//Whether to use the AND/OR switch or not

bool sensor_1 = false;
bool sensor_2 = false;
bool sensor_3 = false;
bool sensor_4 = false;

uint8_t time_1;
uint8_t time_2;
uint8_t time_3;
uint8_t time_4;

uint8_t iteration_1;
uint8_t iteration_2;
uint8_t iteration_3;
uint8_t iteration_4;

UInt16 Value, Value1, Value2, ypr_x, ypr_y, ypr_z, accel_x, accel_y, accel_z;

uint8_t ypr_x_sign, ypr_x_float_part, ypr_y_sign, ypr_y_float_part, ypr_z_sign, ypr_z_float_part, a_x_sign, a_x_float_part, a_y_sign, a_y_float_part, a_z_sign, a_z_float_part;

double yx, yy, yz, ax, ay, az;
unsigned long Value5, Value6;

float milliseconds;
NSString* up = @"";

int cache = 0;


bool switch_state = false;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //Initialize root_ref
    [super viewDidLoad];
    connected_label.hidden = true;
    ble = [[BLE alloc] init];
    [ble controlSetup];
    ble.delegate = self;
    accel_con.textColor = [UIColor redColor];
    us_1_con.textColor = [UIColor redColor];
    us_2_con.textColor = [UIColor redColor];
    us_3_con.textColor = [UIColor redColor];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BLE delegate

NSTimer *rssiTimer;

- (void)bleDidDisconnect
{
    NSLog(@"->Disconnected");

    [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
    [indConnecting stopAnimating];
    
    lblAnalogIn.enabled = false;
    lblAnalogInTwo.enabled = false;
    lblAnalogInThree.enabled = false;
    lblAnalogInFour.enabled = false;
    connected_label.hidden = true;
    
    accel_con.textColor = [UIColor redColor];
    us_1_con.textColor = [UIColor redColor];
    us_2_con.textColor = [UIColor redColor];
    us_3_con.textColor = [UIColor redColor];
    
    swAnalogIn.enabled = false;
    swAnalogInTwo.enabled = false;
    swAnalogInThree.enabled = false;
    swAnalogInFour.enabled = false;
    
    us1lbl.text = @"---";
    us2lbl.text = @"---";
    us3lbl.text = @"---";
    a1.text = @"---";
    a2.text = @"---";
    a3.text = @"---";
    a4.text = @"---";
    a5.text = @"---";
    a6.text = @"---";
    
    
    segmentedController.enabled = false;
    
    lblRSSI.text = @"---";
 //   lblAnalogIn.text = @"----";
    
    [rssiTimer invalidate];
}

// When RSSI is changed, this will be called
-(void) bleDidUpdateRSSI:(NSNumber *) rssi
{
    lblRSSI.text = rssi.stringValue;
}

-(void) readRSSITimer:(NSTimer *)timer
{
    [ble readRSSI];
}

// When disconnected, this will be called
-(void) bleDidConnect
{
    NSLog(@"->Connected");

    [indConnecting stopAnimating];
    
    lblAnalogIn.enabled = true;
    lblAnalogInTwo.enabled = true;
    lblAnalogInThree.enabled = true;
    lblAnalogInFour.enabled = true;

    
    swAnalogIn.enabled = true;
    swAnalogInTwo.enabled = true;
    swAnalogInThree.enabled = true;
    swAnalogInFour.enabled = true;
    connected_label.hidden = false;
    
    
    
    swAnalogIn.on = false;
    swAnalogInTwo.on = false;
    swAnalogInThree.on = false;
    swAnalogInFour.on = false;
    
    //Firebase *timestamp = [[Firebase alloc] initWithUrl:@"https://sbid.firebaseio.com/raw_data/time_stamp"];
    //[timestamp setValue: 0];
   


    
    // send reset
    UInt8 buf[] = {0x04, 0x00, 0x00};
    NSData *data = [[NSData alloc] initWithBytes:buf length:3];
    [ble write:data];

    // Schedule to read RSSI every 1 sec.
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

// When data is received, this will be called
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    Firebase *sensor1 = [[Firebase alloc] initWithUrl:@"https://sbid.firebaseio.com/raw_data/ultrasonic_data_1"];
    Firebase *sensor2 = [[Firebase alloc] initWithUrl:@"https://sbid.firebaseio.com/raw_data/ultrasonic_data_2"];
    Firebase *sensor3 = [[Firebase alloc] initWithUrl:@"https://sbid.firebaseio.com/raw_data/ultrasonic_data_3"];
    Firebase *sensor4 = [[Firebase alloc] initWithUrl:@"https://sbid.firebaseio.com/raw_data/accelerometer_data"];
    Firebase *timestamp = [[Firebase alloc] initWithUrl:@"https://sbid.firebaseio.com/raw_data/time_stamp"];
    
    NSLog(@"Length: %d", length);
    //NSString* up = [NSString stringWithFormat:@"BLAH"];

    // parse data, all commands are in 3-byte
    for (int i = 0; i < length; i+=3)
    {
//        bool both_switches_on = logic_switch_1 && logic_switch_2;
        
        NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);

        switch (data[i]){
                
            
            case 0x0B:
            {
               Value = (data[i+1] | data[i+2]<<8);
                NSLog(@"%d", Value);
                NSString* sensor1val = [@(Value) stringValue];
                //NSString* up = [NSString stringWithFormat:@"%d,%d,%d", Value,Value1,Value2];
                //[sensor1 setValue: up];
                us1lbl.text = [NSString stringWithFormat:@"%d", Value];
                
                us_1_con.textColor = [UIColor greenColor];
                break;
            }
                
            case 0x0C:
            {
                
                Value1 = (data[i+1] | data[i+2]<<8);
                
            
                NSString* sensor2val = [@(Value1) stringValue];
                //NSString* up = [NSString stringWithFormat:@"%d,%d,%d", Value,Value1,Value2];
                //[sensor1 setValue: up];
                //[sensor2 setValue: sensor2val];
                us2lbl.text = [NSString stringWithFormat:@"%d", Value1];
                
                us_2_con.textColor = [UIColor greenColor];
                break;
            }
            case 0x0D:
            {
                
                Value2 = (data[i+1] | data[i+2]<<8);
              
                NSString* sensor3val = [@(Value2) stringValue];
                //NSString* up = [NSString stringWithFormat:@"%d,%d,%d", Value,Value1,Value2];
                //[sensor1 setValue: up];
                //[sensor3 setValue: sensor3val];
                us3lbl.text = [NSString stringWithFormat:@"%d", Value2];
                
                us_3_con.textColor = [UIColor greenColor];
                break;
            }
            
            case 0x12:
            {
                

                ypr_x_sign = data[i+1];
                
                ypr_x_float_part = data[i+2];
                
                break;
                
            }
                
            case 0x1C:
            {
                
                ypr_x = (data[i+1] | data[i+2]<<8);
                
                yx = (double)ypr_x + (double)((double)ypr_x_float_part/100.0);
                if(ypr_x_sign == 0)
                    yx *= -1;
                
                NSLog(@"DOUBLEY: %f",yx);
                a1.text = [NSString stringWithFormat:@"%.2f", yx];
                //NSLog(@"YPR: %u",ypr_x);
                accel_con.textColor = [UIColor greenColor];
                
                
                break;
                
            }
                
            case 0x13:
            {
                
                
                ypr_y_sign = data[i+1];
                
                ypr_y_float_part = data[i+2];
                
                break;
                
            }
                
            case 0x1D:
            {
                
                ypr_y = (data[i+1] | data[i+2]<<8);
                
                yy = (double)ypr_y + (double)((double)ypr_y_float_part/100.0);
                if(ypr_y_sign == 0)
                    yy *= -1;
                
                NSLog(@"DOUBLE: %f",yy);
                a2.text = [NSString stringWithFormat:@"%.2f", yy];
                //NSLog(@"YPR: %u",ypr_x);
                accel_con.textColor = [UIColor greenColor];
                
                
                break;
            }
                
            case 0x14:
            {
                
                
                ypr_z_sign = data[i+1];
                
                ypr_z_float_part = data[i+2];
                
                break;
                
            }
                
            case 0x1E:
            {
                
                ypr_z = (data[i+1] | data[i+2]<<8);
                
                yz = (double)ypr_z + (double)((double)ypr_z_float_part/100.0);
                if(ypr_z_sign == 0)
                    yz *= -1;
                
                NSLog(@"DOUBLE: %f",yz);
                a3.text = [NSString stringWithFormat:@"%.2f", yz];
                //NSLog(@"YPR: %u",ypr_x);
                accel_con.textColor = [UIColor greenColor];
                
                
                break;
            }
                
            case 0x15:
            {
                
                
                a_x_sign = data[i+1];
                
                a_x_float_part = data[i+2];
                
                break;
                
            }
                
            case 0x1F:
            {
                
                accel_x = (data[i+1] | data[i+2]<<8);
                
                ax = (double)accel_x + (double)((double)a_x_float_part/100.0);
                if(a_x_sign == 0)
                    ax *= -1;
                
                NSLog(@"DOUBLE: %f",ax);
                a4.text = [NSString stringWithFormat:@"%.2f", ax];
                //NSLog(@"YPR: %u",ypr_x);
                accel_con.textColor = [UIColor greenColor];
                
                
                break;
            }
                
            case 0x16:
            {
                
                
                a_y_sign = data[i+1];
                
                a_y_float_part = data[i+2];
                
                break;
                
            }
                
            case 0x10:
            {
                
                accel_y = (data[i+1] | data[i+2]<<8);
                
                ay = (double)accel_y + (double)((double)a_y_float_part/100.0);
                if(a_y_sign == 0)
                    ay *= -1;
                
                NSLog(@"DOUBLE: %f",ay);
                a5.text = [NSString stringWithFormat:@"%.2f", ay];
                //NSLog(@"YPR: %u",ypr_x);
                accel_con.textColor = [UIColor greenColor];
                
                
                break;
            }
                
            case 0x17:
            {
                
                
                a_z_sign = data[i+1];
                
                a_z_float_part = data[i+2];
                
                break;
                
            }
                
            case 0x11:
            {
                
                
                accel_z = (data[i+1] | data[i+2]<<8);
                
                az = (double)accel_z + (double)((double)a_z_float_part/100.0);
                if(a_z_sign == 0)
                    az *= -1;
                
                NSLog(@"DOUBLE: %f",az);
                a6.text = [NSString stringWithFormat:@"%.2f", az];
                //NSLog(@"YPR: %u",ypr_x);
                accel_con.textColor = [UIColor greenColor];
                
                
                break;
            }

            case 0x0E:
            {
                time_1 = data[i+1];
                time_2 = data[i+2];
                //NSLog(@"%i",Value5);

                //NSString* time = [@(Value5) stringValue];
                
                //[timestamp setValue: time];
                break;
                
            }
            case 0x0F:
            {
                //unsigned long Value5;
                
                
                time_3 = data[i+1];
                time_4 = data[i+2];
                
                Value5 = (time_1 | time_2<<8 | time_3<<16 | time_4<<24);
                //NSLog(@"%i",Value5);
                //printf("Before: %lu\t", Value5);
                
                
                //NSString *time = @(Value5).stringValue;
                //NSString *time = [NSString stringWithFormat:@"%lu", Value5];
                
                
                break;
            }
            case 0x1A:
            {
                iteration_1 = data[i+1];
                iteration_2 = data[i+2];
                //NSLog(@"%i",Value5);
                
                //NSString* time = [@(Value5) stringValue];
                
                //[timestamp setValue: time];
                break;
                
            }
            case 0x1B:
            {
                iteration_3 = data[i+1];
                iteration_4 = data[i+2];
                Value6 = (iteration_1 | iteration_2<<8 | iteration_3<<16 | iteration_4<<24);
                
                double milliseconds = ([[NSDate date] timeIntervalSince1970]);
                NSLog(@"%f\n",milliseconds);
                NSDate * myDate = [NSDate dateWithTimeIntervalSince1970:milliseconds];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
                
                NSString *resultString = [formatter stringFromDate:[NSDate date]];
                
                NSString* current_data = [NSString stringWithFormat:@"%lu,%@,%lu,%d,%d,%d,%f,%f,%f,%hu,%hu,%hu", Value6,resultString,Value5,Value,Value1,Value2,yx,yy,yz,accel_x,accel_y,accel_z];
                
                up = [NSString stringWithFormat:@"%@\n%@", up, current_data];
                cache++;
                //NSLog(@"%i",cache);
                //NSLog(@"%@",up);
                if (cache == 20) {
                    cache = 0;
                    [timestamp setValue: up];
                    up = [NSString stringWithFormat:@""];
                    
                }
                
                
                //NSLog(@"%i",Value5);
                
                //NSString* time = [@(Value5) stringValue];
                
                //[timestamp setValue: time];
                break;
                
            }
          
                
            
            default: break;
                
        }
        
    }
}

#pragma mark - Actions

// Connect button will call to this
- (IBAction)btnScanForPeripherals:(id)sender
{
    
    if (ble.activePeripheral)
        if(ble.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[ble CM] cancelPeripheralConnection:[ble activePeripheral]];
            [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
            return;
        }
    
    if (ble.peripherals)
        ble.peripherals = nil;
    
    [btnConnect setEnabled:false];
    [ble findBLEPeripherals:2];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)2.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    [indConnecting startAnimating];
}

-(void) connectionTimer:(NSTimer *)timer
{
    [btnConnect setEnabled:true];
    [btnConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    if (ble.peripherals.count > 0)
    {
        [ble connectPeripheral:[ble.peripherals objectAtIndex:0]];
    }
    else
    {
        [btnConnect setTitle:@"Connect" forState:UIControlStateNormal];
        [indConnecting stopAnimating];
    }
}





@end
