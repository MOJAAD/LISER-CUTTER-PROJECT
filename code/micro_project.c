/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
? Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http: // www.hpinfotech.com
Project :
Version :
Date    :
Author  :
Company :
Comments:
Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/
//========================================LIBRARIES==========================================//
#include <mega32.h>
#include <glcd.h>
#include <font5x7.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>
//====================================DEFINE FUNCTIONS=======================================//
int keypad(void);
void mainmenu(void);
void about(void);
void items(void);
void mandd(void);
void show(int num);
void edit(int number);
void apply(void);
char value(char putx,char puty);
void sethed(char varx1,char vary1,char varx2,char vary2);
void applyR(int j);
void applyL();
void applyC();
void applyS();
//void defaultitems(void);
//======================================GLOBAL VALUE========================================//
flash char shift[4]= { 0xFE , 0xFD , 0xFB , 0xF7} ;
eeprom char  store[5][6];
eeprom int delay;
flash char stepmove[8]={8,9,1,3,2,6,4,12};
char rotateV=0,rotateH=0;
//======================================MAIN FUNCTION========================================//
void main(void)
{
int j=0;
GLCDINIT_t glcd_init_data;

DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;
// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;
// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
MCUCSR=(0<<ISC2);
// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);
// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
// Graphic Display Controller initialization
// The KS0108 connections are specified in the
// Project|Configure|C Compiler|Libraries|Graphic Display menu:
// DB0 - PORTA Bit 0
// DB1 - PORTA Bit 1
// DB2 - PORTA Bit 2
// DB3 - PORTA Bit 3
// DB4 - PORTA Bit 4
// DB5 - PORTA Bit 5
// DB6 - PORTA Bit 6
// DB7 - PORTA Bit 7
// E - PORTB Bit 0
// RD /WR - PORTB Bit 1
// RS - PORTB Bit 2
// /RST - PORTB Bit 3
// CS1 - PORTB Bit 4
// CS2 - PORTB Bit 5
// Specify the current font for displaying text
glcd_init_data.font=font5x7;
// No function is used for reading
// image data from external memory
glcd_init_data.readxmem=NULL;
// No function is used for writing
// image data to external memory
glcd_init_data.writexmem=NULL;
glcd_init(&glcd_init_data);
                                                                //welcome
glcd_clear();
glcd_rectround(2,2,124,60, 5);
glcd_outtextxy(5,15, " IN THE NAME OF GOD");
glcd_outtextxy(5,25,"      WELCOME!");
for(j=0;j<10;j++) {
   delay_ms(10);
   glcd_bar(10+10*j, 40, 20+10*j, 50);
}
glcd_clear();

//defaultitems();
while (1)
      {
          mainmenu();
      }
}
//=====================================MENU FUNCTION========================================//
void mainmenu(void){
int j=0;
glcd_clear();
glcd_outtextxy(4,5,"ENTER  MOOD :");
glcd_rectround(2,20,124,55, 2);
glcd_outtextxy(5,25,"1.ITEMS");
glcd_outtextxy(5,35,"2.MOTOR & DIMENSION");
glcd_outtextxy(5,45,"3.APPLY !");
glcd_outtextxy(5,55,"4.ABOUT PROJECT");
  j=keypad();
  switch(j){
    case 0:
        glcd_clear();
        glcd_outtextxy(4,5,"PLEASE SELECT:");
        glcd_rectround(2,20,124,45, 2);
        glcd_outtextxy(5,25,"1.SHOW ALL");
        glcd_outtextxy(5,35,"2.SHOW ITEMS");
        j=keypad();
        glcd_clear();
        if(j==0){
            show(5);
            delay_ms(500);
        }
        else if (j==1){
            items();
        }
        break;
    case 1:
        mandd();
        break;
    case 2:
       apply();
        break;
    case 3:
        about();
  }
}
//====================================KEYPAD FUNCTION=======================================//
int keypad(void){
int i=0,column=0,temp=16;
while(1){
            for  (i=0;i<4;i++){
            PORTC = shift[i] ;
            delay_us(10);
            if(PINC.4==0){column=0;while(PINC.4==0){}return i*4 + column;}
            if(PINC.5==0){column=1;while(PINC.5==0){}temp=i*4 + column;if(temp==9){temp=-1;}return temp;}
            if(PINC.6==0){column=2;while(PINC.6==0){}return i*4 + column;}
            if(PINC.7==0){column=3;while(PINC.7==0){}return i*4 + column;}
            }
        }
}
//====================================ABOUT FUNCTION========================================//
void about(void){
glcd_clear();
glcd_rectround(1,1,126,62, 5);
glcd_outtextxy(5,10,"CONTROL LISER CUTTER");
glcd_outtextxy(55,30,"BY:");
glcd_outtextxy(7,40,"MOHAMMAD JAVAD ADEL");
delay_ms(800);
glcd_clear();
}
//====================================ITEMS FUNCTION=========================================//
void items(void){
int j=0,adad=1;
char flag1=1,flag2=1,itm[15];
while(flag1){
if(flag2==1){
glcd_clear();
glcd_rectround(0,0,42,15,2);
glcd_rectround(42,0,43,15,2);
glcd_rectround(85,0,42,15,2);
glcd_rectround(0,16,128,33, 2);
glcd_rectround(0,50,42,15,2);
glcd_rectround(42,50,43,15,2);
glcd_rectround(85,50,42,15,2);
sprintf(itm,"ITEM %d",adad);
glcd_outtextxy(43,3,itm);
glcd_outtextxy(2,20,"DATA:");
sprintf(itm," '%c' ",store[adad-1][0]);
glcd_outtextxy(60,20,itm);
sprintf(itm,"%d %d %d",store[adad-1][1],store[adad-1][2],store[adad-1][3]);
glcd_outtextxy(30,30,itm);
sprintf(itm,"%d %d",store[adad-1][4],store[adad-1][5]);
glcd_outtextxy(35,40,itm);
glcd_outtextxy(3,3,"< PRE");
glcd_outtextxy(87,3,"NEXT >");
glcd_outtextxy(2,53," BacK");
glcd_outtextxy(44,53,"* SHOW");
glcd_outtextxy(87,53,"/ EDIT");
}
j=keypad();
switch(j){
    case 15:
        glcd_clear();
        edit(adad-1);
        flag2=1;
        break;
    case 14:
        glcd_clear();
        show(adad-1);
        delay_ms(500);
        flag2=1;
        break;
    case 13:
        adad--;
        if(adad<1){
            adad=5;
        }
        flag2=0;
        sprintf(itm,"ITEM %d",adad);
        glcd_outtextxy(43,3,itm);
        sprintf(itm," '%c' ",store[adad-1][0]);
        glcd_outtextxy(60,20,itm);
        sprintf(itm,"%d %d %d   ",store[adad-1][1],store[adad-1][2],store[adad-1][3]);
        glcd_outtextxy(30,30,itm);
        sprintf(itm,"%d %d     ",store[adad-1][4],store[adad-1][5]);
        glcd_outtextxy(35,40,itm);
        break;
    case 12:
        adad++;
        if(adad>5){
            adad=1;
        }
        flag2=0;
        sprintf(itm,"ITEM %d",adad);
        glcd_outtextxy(43,3,itm);
        sprintf(itm," '%c' ",store[adad-1][0]);
        glcd_outtextxy(60,20,itm);
        sprintf(itm,"%d %d %d   ",store[adad-1][1],store[adad-1][2],store[adad-1][3]);
        glcd_outtextxy(30,30,itm);
        sprintf(itm,"%d %d     ",store[adad-1][4],store[adad-1][5]);
        glcd_outtextxy(35,40,itm);
        break;
    case 10:
        flag1=0;
        flag2=0;
        break;
}
}
}
//==============================SPEED & DIMENSIONS FUNCTION==================================//
void mandd(void){
int j=0;
glcd_clear();
glcd_outtextxy(4,5,"PLEASE SELECT:");
glcd_rectround(2,20,124,55, 2);
glcd_outtextxy(5,25,"1.SET SPEED");
glcd_outtextxy(5,35,"2.SET DIMENSIONS");
glcd_outtextxy(5,45,"3.BACK");
  j=keypad();
  switch(j){
    case 0:
        glcd_clear();
        glcd_rectround(2,2,124,63, 2);
        glcd_outtextxy(5,10,"ENTER NEW VALUE(ms):");
        glcd_outtextxy(5,20,"THEN PRESS   ""EN"" ");
        delay=value(5,30);
        break;
    case 1:
        glcd_clear();
        glcd_rectround(2,2,124,63, 2);
        glcd_outtextxy(20,10,"THE DEFAUT IS:");
        glcd_outtextxy(45,30,"128*64");
        glcd_outtextxy(5,50,"THIS IS UNCHANGEABLE");
        delay_ms(500);
        break;
    case 2:
        break;
  }

}
//====================================APPLY FUNCTION=========================================//
void apply(void){
int j=0;
char flag=1,temp=0;
glcd_clear();
while(1){
glcd_outtextxy(4,5,"PLEASE SELECT:");
glcd_rectround(2,20,124,45, 2);
glcd_outtextxy(5,25,"1.APPLY ALL");
glcd_outtextxy(5,35,"2.APPLY ONE ITEM");
j=keypad();
if(j==0){
    glcd_clear();
    glcd_rectround(2,2,124,60, 5);
    glcd_outtextxy(20,20, " APPLYING... !");
    for(temp=0;temp<10;temp++) {
        delay_ms(20);
        glcd_bar(10+10*temp, 40, 20+10*temp, 50);
        }
    glcd_clear();
    for(j=0;j<5;j++){
    temp=store[j][0];
        switch(temp){
            case 'R':
                applyR(j);
                delay_ms(500);
                break;
            case 'L':
                applyL();
                break;
            case 'C':
                applyC();
                break;
            case 'S':
                applyS();
                break;
        }
        }
    break;
}
else if (j==1){
    while(flag){
    glcd_clear();
    glcd_rectround(0,0,128,64, 5);
    glcd_outtextxy(2,20,"SELECT ITEM:");
    glcd_outtextxy(2,30,"1)ITEM 1  2)ITEM 2");
    glcd_outtextxy(2,40,"3)ITEM 3  4)ITEM 4");
    glcd_outtextxy(2,50,"5)ITEM 5");
    j=keypad();
    if(j<=4 && j>=0){
        glcd_clear();
        glcd_rectround(2,2,124,60, 5);
        glcd_outtextxy(20,20, " APPLYING... !");
        for(temp=0;temp<10;temp++) {
            delay_ms(20);
            glcd_bar(10+10*temp, 40, 20+10*temp, 50);
            }
        }
        glcd_clear();
        flag=0;
        temp=store[j][0];
        switch(temp){
            case 'R':
                applyR(j);
                delay_ms(500);
                break;
            case 'L':
                applyL();
                break;
            case 'C':
                applyC();
                break;
            case 'S':
                applyS();
                break;
        }
    }
break;
}
}
}
//=================================INITIAL ITEMS FUNCTION=====================================//
/*
void defaultitems(void){
store[0][0]='R';
store[0][1]=10;x1
store[0][2]=30;  y1
store[0][3]=80;    x2
store[0][4]=50;      y2
store[0][5]=' ';

store[1][0]='L';
store[1][1]=100;
store[1][2]=10;
store[1][3]=10;
store[1][4]=60;
store[1][5]=' ';

store[2][0]='C';
store[2][1]=40;
store[2][2]=40;
store[2][3]=20;
store[2][4]=' ';
store[2][5]=' ';

store[3][0]='S';
store[3][1]=60;
store[3][2]=30;
store[3][3]=0;
store[3][4]=120;
store[3][5]=20;

store[4][0]='S';
store[4][1]=60;
store[4][2]=30;
store[4][3]=20;
store[4][4]=120;
store[4][5]=20;

delay=50;
}
*/
//====================================SHOW FUNCTION=========================================//
void show(int num){
char type,counter=0;
type=store[num][0];
switch (type){
    case 'R':
        glcd_rectangle(store[num][1],store[num][2],store[num][3],store[num][4]);
        break;
    case 'L':
        glcd_line(store[num][1],store[num][2],store[num][3],store[num][4]);
        break;
    case 'C':
        glcd_circle(store[num][1],store[num][2],store[num][3]);
        break;
    case 'S':
        glcd_arc(store[num][1],store[num][2],store[num][3],store[num][4],store[num][5]);
        break;
}
if(num==5){
for(counter=0;counter<5;counter++){
show(counter);
}
}
}
//=====================================EDIT FUNCTION=========================================//
void edit(int number){
char flag=1,itm[15],buffer[6];
int j=0;
glcd_rectround(0,0,42,15,2);
glcd_rectround(42,0,43,15,2);
glcd_rectround(85,0,42,15,2);
glcd_outtextxy(3,3," BacK");
glcd_outtextxy(87,3,"NEXT >");
sprintf(itm,"ITEM %d",number+1);
glcd_outtextxy(43,3,itm);
glcd_rectround(0,16,128,48, 2);
while(flag>0){
switch(flag){
    case 1:
        glcd_outtextxy(2,20,"SELECT TYPE:");
        glcd_outtextxy(2,30,"1-rectangle  2-line");
        glcd_outtextxy(2,40,"3-circle    4-sector");
        j=keypad();
        switch(j){
            case 0:
                buffer[0]='R';
                glcd_outtextxy(2,30,"1-rectangle        ");
                glcd_outtextxy(2,40,"                    ");
                break;
            case 1:
                buffer[0]='L';
                glcd_outtextxy(2,30,"             2-line");
                glcd_outtextxy(2,40,"                    ");
                break;
            case 2:
                buffer[0]='C';
                glcd_outtextxy(2,30,"                    ");
                glcd_outtextxy(2,40,"3-circle            ");
                break;
            case 3:
                buffer[0]='S';
                glcd_outtextxy(2,30,"                    ");
                glcd_outtextxy(2,40,"            4-sector");
                break;
        }
        j=keypad();
        if(j==12){
            flag++;
        }
        break;
    case  2:
        glcd_outtextxy(2,20,"ENTR DATA & PRESS EN");
        glcd_outtextxy(2,30,"X1=         Y1=    ");
        glcd_outtextxy(2,40,"                    ");
        buffer[1]=value(25,30);
        buffer[2]=value(95,30);
        if(buffer[0]=='R' || buffer[0]=='L'){
        glcd_outtextxy(2,40,"X2=         Y2=     ");
        buffer[3]=value(25,40);
        buffer[4]=value(95,40);
        }
        else if(buffer[0]=='C'){
        glcd_outtextxy(2,40,"Radius=            ");
        buffer[3]=value(50,50);
        }
        else if(buffer[0]=='S'){
        glcd_outtextxy(2,40,"<1=         <2=     ");
        buffer[3]=value(25,40);
        buffer[4]=value(97,40);
        glcd_outtextxy(2,50,"Radius=            ");
        buffer[5]=value(50,50);
        }
        glcd_outtextxy(2,20,"COMPLETED => PRESS >");
        j=keypad();
        if(j==12){
            flag++;
        }
        break;
    case 3:
        glcd_outtextxy(87,3,"SV: EN");
        glcd_outtextxy(2,20,"DATA:               ");
        sprintf(itm," '%c' ",buffer[0]);
        glcd_outtextxy(60,20,itm);
        sprintf(itm,"%d %d %d   ",buffer[1],buffer[2],buffer[3]);
        glcd_outtextxy(2,30,"                    ");
        glcd_outtextxy(30,30,itm);
        sprintf(itm,"%d %d     ",buffer[4],buffer[5]);
        glcd_outtextxy(2,40,"                    ");
        glcd_outtextxy(35,40,itm);
        glcd_outtextxy(2,50,"                    ");
        j=keypad();
        if(j==11){
            flag++;
            if(flag==4){
                for(j=0;j<6;j++){
                    store[number][j]=buffer[j];
                }
            glcd_clear();
            glcd_outtextxy(47,30,"SAVED!");
            delay_ms(500);
            glcd_clear();
            flag=0;
            }
        }
        break;
}
if(j==10){flag=0;}
}
}
//==================================GET VALUE FUNCTION=======================================//
char value(char putx,char puty){
char itm[15],number=0;
int temp2=0,num=0;
glcd_outtextxy(putx,puty,"_    ");
while(1){
    temp2=keypad();
    if(temp2>9){
        if(temp2==11 && num<256){
               number=num;
               return number;
        }
        else{
        glcd_outtextxy(87,3,"WRONG ");
        num=0;
        glcd_outtextxy(putx,puty,"_   ");
        delay_ms(300);
        glcd_outtextxy(87,3,"NEXT >");
        }
    }
    else{
        temp2++;
        num=num*10 + temp2;
        if(num<256){
        sprintf(itm,"%d  ",num);
        glcd_outtextxy(putx,puty,itm);
        }
        else{
        glcd_outtextxy(87,3,"WRONG ");
        num=0;
        glcd_outtextxy(putx,puty,"_   ");
        delay_ms(300);
        glcd_outtextxy(87,3,"NEXT >");
        }
    }
}
}
//===============================APPLY RECTANGLE FUNCTION===================================//
void applyR(int j){
char i;
sethed(0,0,store[j][1],store[j][2]);
DDRB.6=1;    // OUTPUT
PORTB.6=1;  // --> 5V
DDRD=0x0f;
for(i=store[j][1]+1 ; i<=store[j][3] ; i++,rotateH++){
    glcd_setpixel(i-1,store[j][2]);
    if(rotateH>7){rotateH=0;}
    PORTD=stepmove[rotateH];
    delay_ms(delay);
}
DDRD=0xf0;
for(i=store[j][2]+1; i<=store[j][4] ; i++ ,rotateV++){
    glcd_setpixel(store[j][3],i-1);
    if(rotateV>7){rotateV=0;}
    PORTD=stepmove[rotateV]<<4;
    delay_ms(delay);
}
DDRD=0x0f;
for(i=store[j][3] ; i>=store[j][1] ; i-- ,rotateH--){
    glcd_setpixel(i,store[j][4]);
    if(rotateH>7){rotateH=7;}
    PORTD=stepmove[rotateH];
    delay_ms(delay);
}
DDRD=0xf0;
rotateV--;
for(i=store[j][4] ; i>=store[j][2] ; i-- ,rotateV--){
    glcd_setpixel(store[j][1],i);
    if(rotateV>7){rotateV=7;}
    PORTD=stepmove[rotateV]<<4;
    delay_ms(delay);
}
DDRD=0x00;
PORTB.6=0;

sethed(store[j][1],store[j][2],0,0);
rotateH=0;rotateV=0;
}
//=================================APPLY CIRCLE FUNCTION=====================================//
void applyC(void){
glcd_clear();
glcd_rectround(1,1,126,62, 5);
glcd_outtextxy(5,10,"Applying circle...");
glcd_outtextxy(5,30,"It's not available!");
delay_ms(500);
glcd_clear();
}
//==================================APPLY LINE FUNCTION======================================//
void applyL(void){
glcd_clear();
glcd_rectround(1,1,126,62, 5);
glcd_outtextxy(5,10,"Applying line...   ");
glcd_outtextxy(5,30,"It's not available!");
delay_ms(500);
glcd_clear();
}
//================================APPLY SECTOR FUNCTION=====================================//
void applyS(void){
glcd_clear();
glcd_rectround(1,1,126,62, 5);
glcd_outtextxy(5,10,"Applying sector...");
glcd_outtextxy(5,30,"It's not available!");
delay_ms(500);
glcd_clear();
}
//==================================SET HEADER FUNCTION=====================================//
void sethed(char varx1,char vary1,char varx2,char vary2){
DDRD=0x0f; // 0b 0000 1111
if(varx1<=varx2){
    for(varx1=varx1+1 ; varx1<=varx2 ; varx1++ ,rotateH++){
        glcd_clrpixel(varx1-1,vary1);
        glcd_setpixel(varx1,vary1);
        if(rotateH>7){rotateH=0;}
        PORTD=stepmove[rotateH];  // 0b 0000 1000
        delay_ms(delay);
    }
}
else{
    for(varx1=varx1-1 ; varx1>=varx2 && varx1!=255 ; varx1-- ,rotateH--){
        glcd_clrpixel(varx1+1,vary1);
        glcd_setpixel(varx1,vary1);
        if(rotateH>7){rotateH=7;}
        PORTD=stepmove[rotateH];
        delay_ms(delay);
    }
}
DDRD=0xf0; // 0b 1111 0000 motor Y
if(vary1<=vary2){
        for(vary1=vary1+1; vary1<=vary2 ; vary1++ ,rotateV++){
        glcd_clrpixel(varx2,vary1-1);
        glcd_setpixel(varx2,vary1);
        if(rotateV>7){rotateV=0;}
        PORTD=stepmove[rotateV]<<4; // 0b 0000 1000 ==> 0b 1000 0000
        delay_ms(delay);
    }
}
else{
    for(vary1=vary1-1 ; vary1>=vary2 && vary1!=255 ; vary1--,rotateV--){
        glcd_clrpixel(varx2,vary1+1);
        glcd_setpixel(varx2,vary1);
        if(rotateV>7){rotateV=7;}
        PORTD=stepmove[rotateV]<<4;
        delay_ms(delay);
    }
}
DDRD=0x00;
}
//==========================================END=============================================//

