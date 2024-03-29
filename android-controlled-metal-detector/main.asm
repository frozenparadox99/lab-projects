#include<reg51.h>
 
unsigned char ch1;
unsigned char s;
 
sbit m1f=P2^0;             // in1 pin of motor1
sbit m1b=P2^1;             // in2 pin of motor1
sbit m2f=P2^2;             // in1 pin of motor2
sbit m2b=P2^3;             // in2 pin of motor2
  
void delay(unsigned int)  ;        //function for creating delay
char rxdata(void);                 //function for receiving a character through serial port of 8051 
void txdata(unsigned char); //function for sending a character through serial port of 8051 
 
void main(void)
 {
unsigned char i;
unsigned char msg1[]={"robot is moving forward"};
unsigned char msg2[]={"robot is moving backward"};
unsigned char msg3[]={"robot is moving right"};
unsigned char msg4[]={"robot is moving left"};
unsigned char msg5[]={"robot is stopped"};
 
TMOD=0x20;   //timer 1 , mode 2 , auto reload
SCON=0x50;    //8bit data , 1 stop bit , REN enabled
TH1=0xfd;     //timer value for 9600 bits per second(bps)
TR1=1;            
 
while(1)             //repeat forever
{
     s=rxdata(); //receive serial data from hc-05 bluetooth module
if(s=='f') //move both the motors in forward direction
     {
         m1f=1;
   delay(1);
         m1b=0;
   delay(1);
         m2f=1;
   delay(1);
         m2b=0;
   delay(1);
        for(i=0;msg1[i]!='\0';i++)
{
    txdata(msg1[i]);
} 
 
    }
 
     else if(s=='b')  
     {
         m1f=0;
    delay(1);
         m1b=1;
    delay(10);
         m2f=0;
    delay(10);
         m2b=1;
    delay(10);
    for(i=0;msg2[i]!='\0';i++)   
         {
   txdata(msg2[i]);
    }
     }
 
     else if(s=='r')
     {
         m1f=1;
         delay(1);
         m1b=0;   
   delay(10);
         m2f=0;
   delay(10);
         m2b=1;
delay(10);
for(i=0;msg3[i]!='\0';i++)   
{
    txdata(msg3[i]);
} 
                }
 
     else if(s=='l')
     {
         m1f=0;
         delay(1);
         m1b=1;
    delay(1);
         m2f=1;
    delay(1);
         m2b=0;
    delay(1);
    for(i=0;msg4[i]!='\0';i++)
        {
    txdata(msg4[i]);
   } 
    }
 
     else if(s=='s')  
     {
         m1f=0;
         delay(1);
         m1b=0;
    delay(1);
         m2f=0;
    delay(1);
         m2b=0;
   delay(1);
   for(i=0;msg5[i]!='\0';i++)
        {
  txdata(msg5[i]);
   }
    }
      txdata('\n');  
     
                    }
}
 
char rxdata()
{
  while(RI==0);   //wait till RI becomes HIGH
  RI=0;           //make RI low
  ch1=SBUF;      //copy received data 
  return ch1;     //return the received data to main function.
}
 
void txdata(unsigned char x)
{
   SBUF=x; //copy data to be transmitted to SBUF
   while(TI==0); //wait till TI becomes high
   TI=0; //mae TI low for next transmission
}
 
void delay(unsigned int z)
{
  unsigned int p ,q;
  for(p=0 ; p<z ; p++)    //repeat for 'z' times
  {
    for(q=0 ; q<1375 ; q++);   //repeat for 1375 times
  }
}