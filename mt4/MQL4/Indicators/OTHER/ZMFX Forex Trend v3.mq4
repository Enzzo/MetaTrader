//+------------------------------------------------------------------+
//|                                           ZCOMFX daily trend.mq4 |
//|                                                                  |
/*

It shows a direction of 4 pairs (EUR/USD, GBP/USD, AUD/USD, USD/CHF by indicators EMA and Stochastic.

*/
//+------------------------------------------------------------------+
#property copyright "ZCOMFX"

#property indicator_chart_window
#define Pref "ZCOMFX"

extern string note="Write 8 pairs to show trend:";
extern   string symbol1="EURUSD";
extern   string symbol2="GBPUSD";
extern   string symbol3="AUDUSD";
extern   string symbol4="NZDUSD";
extern   string symbol5="EURGBP";
extern   string symbol6="USDCAD";
extern   string symbol7="USDJPY";
extern   string symbol8="USDCHF";
extern   int EMA1_period=10;
extern   int EMA2_period=50;
extern   int EMA3_period=200;
extern   int Stochastic_period=30;
extern   int CCI_period=50;
extern   int RSI_period=14;
extern   int MACD_period=20;
   string note1="macd:";
 int FastEMA=12;
 int SlowEMA=26;
 int SignalSMA=9;
extern string note2="Coordinates:";
extern int X=40;
extern int Y=20;
 int RowStep=12;
 int ColStep=17;
extern int Corner=1; 
 int FSize=10;
//extern int H=0;
 string note3="Colors, two themes:";
 color RectClr=Gray;
extern color TxtClr=White;
extern color High_up_color=Lime;
extern color UpClr=DarkGreen;
extern color DnClr=FireBrick;
extern color High_down_color=Red;
 bool White_Chart_Theme=false;
 color RectClr1=Gray;
 color TxtClr1=Gray;
 color UpClr1=Lime;
 color DnClr1=Red;
 color FlatClr=DodgerBlue;


int TimeX;
double PriceY;

int codeAO, codeAO2, codeAO3, codeAO4, codeAO5, codeAO6, codeao7, codeao8,
    codeAC, codeMACD, 
    codeSTO, codeSTO2, codeSTO3, codeSTO4, codeSTO5, codeSTO6, codesto7, codesto8,
    codecci, codecci2, codecci3, codecci4, codecci5, codecci6, codecci7, codecci8,
    codersi, codersi2, codersi3, codersi4, codersi5, codersi6, codersi7, codersi8,
    codemacd, codemacd2, codemacd3, codemacd4, codemacd5, codemacd6, codemacd7, codemacd8;

color ClrAO, ClrAO2, ClrAO3, ClrAO4, ClrAO5, ClrAO6, clrao7, clrao8, 
      ClrAC, ClrMACD, 
      ClrSTO, ClrSTO2, ClrSTO3, ClrSTO4, ClrSTO5, ClrSTO6, clrsto7, clrsto8,
      clrcci, clrcci2, clrcci3, clrcci4, clrcci5, clrcci6, clrcci7, clrcci8,
      clrrsi, clrrsi2, clrrsi3, clrrsi4, clrrsi5, clrrsi6, clrrsi7, clrrsi8,
      clrmacd, clrmacd2, clrmacd3, clrmacd4, clrmacd5, clrmacd6, clrmacd7, clrmacd8;


//bool Alert_=False;
//color Alert_Clr=Red;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
     ObjectCreate("mywebsite",OBJ_LABEL,0,0,0);

      
      if(White_Chart_Theme)
            {
                RectClr=RectClr1;
                TxtClr=TxtClr1;
                UpClr=UpClr1;
                DnClr=DnClr1;
            }
       
       DrawPanel();
      
      
//----

   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   Delete_My_Obj(Pref);
     ObjectDelete("mywebsite");   
  
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
    
   int    counted_bars=IndicatorCounted();
//----
ObjectSetText("mywebsite","ZMFX Trend v3", 10, "Arial", DodgerBlue);
ObjectSet("mywebsite",OBJPROP_XDISTANCE,40);
ObjectSet("mywebsite",OBJPROP_YDISTANCE,12);
ObjectSet("mywebsite", OBJPROP_CORNER, 1);


  double ema1,ema2,sto, cci, rsi, macd, macds, ema3;
   ema1=iMA(symbol1,NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema2=iMA(symbol1,NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema3=iMA(symbol1,NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto =iStochastic(symbol1,NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);   
   cci =iCCI(symbol1,NULL,CCI_period,PRICE_CLOSE,0); 
   rsi =iRSI(symbol1,NULL,RSI_period,PRICE_CLOSE,0); 
   macd=iMACD(symbol1,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
  macds=iMACD(symbol1,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);

      if ( ema2>ema1 && ema1>ema3 )       {codeAO=233; ClrAO=High_up_color; } 
      else 
      if ( ema2<ema1 && ema1<ema3 )       {codeAO=234; ClrAO=High_down_color; } 
      else
      if ( ema2>ema1 )       {codeAO=233; ClrAO=UpClr; } 
      else
      if ( ema2<ema1 )       {codeAO=234; ClrAO=DnClr; } 
  
      if ( sto>80 ) {codeSTO=233; ClrSTO=High_up_color;}     
      if ( sto>50 && sto<80 )    {codeSTO=233; ClrSTO=UpClr;}
      if ( sto<50 && sto>20)     {codeSTO=234; ClrSTO=DnClr;}
      if ( sto<20 ) {codeSTO=234; ClrSTO=High_down_color;}
      
      if ( cci>0 && cci<100 )     {codecci=233; clrcci=UpClr;}
      if ( cci<0 && cci>-100 )     {codecci=234; clrcci=DnClr;}
      if ( cci>100)    {codecci=233; clrcci=High_up_color;}
      if ( cci<-100)   {codecci=234; clrcci=High_down_color;}
      
      if ( rsi>50 && rsi<65 )    {codersi=233; clrrsi=UpClr;}
      if ( rsi<50 && rsi>35 )    {codersi=234; clrrsi=DnClr;}
      if ( rsi<35 ) {codersi=234; clrrsi=High_down_color; }
      if ( rsi>65 ) {codersi=233; clrrsi=High_up_color; }
      
      if ( macd>0 && macd<macds )     {codemacd=233; clrmacd=UpClr;}
      if ( macd<0 && macd>macds )     {codemacd=234; clrmacd=DnClr;}
      if ( macd<0 && macd<macds ) {codemacd=234; clrmacd=High_down_color;}
      if ( macd>0 && macd>macds ) {codemacd=233; clrmacd=High_up_color;}
      

   double ema12,ema22,sto2, cci2, rsi2, macd2, macd2s, ema32;
   ema12=iMA(symbol2,NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema22=iMA(symbol2,NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema32=iMA(symbol2,NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto2=iStochastic(symbol2,NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);      
   cci2 =iCCI(symbol2,NULL,CCI_period,PRICE_CLOSE,0);  
   rsi2 =iRSI(symbol2,NULL,RSI_period,PRICE_CLOSE,0); 
   macd2=iMACD(symbol2,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
  macd2s=iMACD(symbol2,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   
      if ( ema22>ema12 && ema12>ema32 )       {codeAO2=233; ClrAO2=High_up_color; } 
      else 
      if ( ema22<ema12 && ema12<ema32 )       {codeAO2=234; ClrAO2=High_down_color; } 
      else
      if ( ema22>ema12 )       {codeAO2=233; ClrAO2=UpClr; } 
      else
      if ( ema22<ema12 )       {codeAO2=234; ClrAO2=DnClr; } 
      
      if ( sto2>80 ) {codeSTO2=233; ClrSTO2=High_up_color;}     
      if ( sto2>50 && sto2<80 )    {codeSTO2=233; ClrSTO2=UpClr;}
      if ( sto2<50 && sto2>20)     {codeSTO2=234; ClrSTO2=DnClr;}
      if ( sto2<20 ) {codeSTO2=234; ClrSTO2=High_down_color;}
      
      if ( cci2>0 && cci2<100 )     {codecci2=233; clrcci2=UpClr;}
      if ( cci2<0 && cci2>-100 )     {codecci2=234; clrcci2=DnClr;}
      if ( cci2>100)    {codecci2=233; clrcci2=High_up_color;}
      if ( cci2<-100)   {codecci2=234; clrcci2=High_down_color;}
      
      if ( rsi2>50 && rsi2<65 )    {codersi2=233; clrrsi2=UpClr;}
      if ( rsi2<50 && rsi2>35 )    {codersi2=234; clrrsi2=DnClr;}
      if ( rsi2<35 ) {codersi2=234; clrrsi2=High_down_color; }
      if ( rsi2>65 ) {codersi2=233; clrrsi2=High_up_color; }
      if ( macd2>0 && macd2<macd2s )     {codemacd2=233; clrmacd2=UpClr;}
      if ( macd2<0 && macd2>macd2s )     {codemacd2=234; clrmacd2=DnClr;}
      if ( macd2<0 && macd2<macd2s ) {codemacd2=234; clrmacd2=High_down_color;}
      if ( macd2>0 && macd2>macd2s ) {codemacd2=233; clrmacd2=High_up_color;}

         
   double ema13,ema23,sto3, cci3, rsi3,macd3,macd3s,ema33;
   ema13=iMA(symbol3,NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema23=iMA(symbol3,NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema33=iMA(symbol3,NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto3=iStochastic(symbol3,NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);      
   cci3 =iCCI(symbol3,NULL,CCI_period,PRICE_CLOSE,0);  
   rsi3 =iRSI(symbol3,NULL,RSI_period,PRICE_CLOSE,0); 
   macd3=iMACD(symbol3,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
  macd3s=iMACD(symbol3,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
  
      if ( ema23>ema13 && ema13>ema33 )       {codeAO3=233; ClrAO3=High_up_color; } 
      else 
      if ( ema23<ema13 && ema13<ema33 )       {codeAO3=234; ClrAO3=High_down_color; } 
      else
      if ( ema23>ema13 )       {codeAO3=233; ClrAO3=UpClr; } 
      else
      if ( ema23<ema13 )       {codeAO3=234; ClrAO3=DnClr; } 
      
      if ( sto3>80 ) {codeSTO3=233; ClrSTO3=High_up_color;}     
      if ( sto3>50 && sto3<80 )    {codeSTO3=233; ClrSTO3=UpClr;}
      if ( sto3<50 && sto3>20)     {codeSTO3=234; ClrSTO3=DnClr;}
      if ( sto3<20 ) {codeSTO3=234; ClrSTO3=High_down_color;}
      
      if ( cci3>0 && cci3<100 )     {codecci3=233; clrcci3=UpClr;}
      if ( cci3<0 && cci3>-100 )     {codecci3=234; clrcci3=DnClr;}
      if ( cci3>100)    {codecci3=233; clrcci3=High_up_color;}
      if ( cci3<-100)   {codecci3=234; clrcci3=High_down_color;}
      
      if ( rsi3>50 && rsi3<65 )    {codersi3=233; clrrsi3=UpClr;}
      if ( rsi3<50 && rsi3>35 )    {codersi3=234; clrrsi3=DnClr;}
      if ( rsi3<35 ) {codersi3=234; clrrsi3=High_down_color; }
      if ( rsi3>65 ) {codersi3=233; clrrsi3=High_up_color; }
      if ( macd3>0 && macd3<macd3s )     {codemacd3=233; clrmacd3=UpClr;}
      if ( macd3<0 && macd3>macd3s )     {codemacd3=234; clrmacd3=DnClr;}
      if ( macd3<0 && macd3<macd3s ) {codemacd3=234; clrmacd3=High_down_color;}
      if ( macd3>0 && macd3>macd3s ) {codemacd3=233; clrmacd3=High_up_color;}


   double ema14,ema24,sto4, cci4, rsi4,macd4,macd4s,ema34;
   ema14=iMA(symbol4,NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema24=iMA(symbol4,NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema34=iMA(symbol4,NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto4=iStochastic(symbol4,NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);      
   cci4 =iCCI(symbol4,NULL,CCI_period,PRICE_CLOSE,0);  
   rsi4 =iRSI(symbol4,NULL,RSI_period,PRICE_CLOSE,0); 
   macd4=iMACD(symbol4,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
  macd4s=iMACD(symbol4,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   
      if ( ema24>ema14 && ema14>ema34 )       {codeAO4=233; ClrAO4=High_up_color; } 
      else 
      if ( ema24<ema14 && ema14<ema34 )       {codeAO4=234; ClrAO4=High_down_color; } 
      else
      if ( ema24>ema14 )       {codeAO4=233; ClrAO4=UpClr; } 
      else
      if ( ema24<ema14 )       {codeAO4=234; ClrAO4=DnClr; } 
      
      if ( sto4>80 ) {codeSTO4=233; ClrSTO4=High_up_color;}     
      if ( sto4>50 && sto4<80 )    {codeSTO4=233; ClrSTO4=UpClr;}
      if ( sto4<50 && sto4>20)     {codeSTO4=234; ClrSTO4=DnClr;}
      if ( sto4<20 ) {codeSTO4=234; ClrSTO4=High_down_color;}
      
      if ( cci4>0 && cci4<100 )     {codecci4=233; clrcci4=UpClr;}
      if ( cci4<0 && cci4>-100 )     {codecci4=234; clrcci4=DnClr;}
      if ( cci4>100)    {codecci4=233; clrcci4=High_up_color;}
      if ( cci4<-100)   {codecci4=234; clrcci4=High_down_color;}
      
      if ( rsi4>50 && rsi4<65 )    {codersi4=233; clrrsi4=UpClr;}
      if ( rsi4<50 && rsi4>35 )    {codersi4=234; clrrsi4=DnClr;}
      if ( rsi4<35 ) {codersi4=234; clrrsi4=High_down_color; }
      if ( rsi4>65 ) {codersi4=233; clrrsi4=High_up_color; }
      if ( macd4>0 && macd4<macd4s )     {codemacd4=233; clrmacd4=UpClr;}
      if ( macd4<0 && macd4>macd4s )     {codemacd4=234; clrmacd4=DnClr;}
      if ( macd4<0 && macd4<macd4s ) {codemacd4=234; clrmacd4=High_down_color;}
      if ( macd4>0 && macd4>macd4s ) {codemacd4=233; clrmacd4=High_up_color;}


   double ema15,ema25,sto5, cci5, rsi5,macd5,macd5s,ema35;
   ema15=iMA(symbol5,NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema25=iMA(symbol5,NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema35=iMA(symbol5,NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto5=iStochastic(symbol5,NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);      
   cci5 =iCCI(symbol5,NULL,CCI_period,PRICE_CLOSE,0);  
   rsi5 =iRSI(symbol5,NULL,RSI_period,PRICE_CLOSE,0); 
   macd5=iMACD(symbol5,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
  macd5s=iMACD(symbol5,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   
      if ( ema25>ema15 && ema15>ema35 )       {codeAO5=233; ClrAO5=High_up_color; } 
      else 
      if ( ema25<ema15 && ema15<ema35 )       {codeAO5=234; ClrAO5=High_down_color; } 
      else
      if ( ema25>ema15 )       {codeAO5=233; ClrAO5=UpClr; } 
      else
      if ( ema25<ema15 )       {codeAO5=234; ClrAO5=DnClr; } 
      
      if ( sto5>80 ) {codeSTO5=233; ClrSTO5=High_up_color;}     
      if ( sto5>50 && sto5<80 )    {codeSTO5=233; ClrSTO5=UpClr;}
      if ( sto5<50 && sto5>20)     {codeSTO5=234; ClrSTO5=DnClr;}
      if ( sto5<20 ) {codeSTO5=234; ClrSTO5=High_down_color;}
      
      if ( cci5>0 && cci5<100 )     {codecci5=233; clrcci5=UpClr;}
      if ( cci5<0 && cci5>-100 )     {codecci5=234; clrcci5=DnClr;}
      if ( cci5>100)    {codecci5=233; clrcci5=High_up_color;}
      if ( cci5<-100)   {codecci5=234; clrcci5=High_down_color;}
      
      if ( rsi5>50 && rsi5<65 )    {codersi5=233; clrrsi5=UpClr;}
      if ( rsi5<50 && rsi5>35 )    {codersi5=234; clrrsi5=DnClr;}
      if ( rsi5<35 ) {codersi5=234; clrrsi5=High_down_color; }
      if ( rsi5>65 ) {codersi5=233; clrrsi5=High_up_color; }
      if ( macd5>0 && macd5<macd5s )     {codemacd5=233; clrmacd5=UpClr;}
      if ( macd5<0 && macd5>macd5s )     {codemacd5=234; clrmacd5=DnClr;}
      if ( macd5<0 && macd5<macd5s ) {codemacd5=234; clrmacd5=High_down_color;}
      if ( macd5>0 && macd5>macd5s ) {codemacd5=233; clrmacd5=High_up_color;}


   double ema16,ema26,sto6, cci6, rsi6,macd6,macd6s,ema36;
   ema16=iMA(symbol6,NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema26=iMA(symbol6,NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema36=iMA(symbol6,NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto6=iStochastic(symbol6,NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);      
   cci6 =iCCI(symbol6,NULL,CCI_period,PRICE_CLOSE,0);  
   rsi6 =iRSI(symbol6,NULL,RSI_period,PRICE_CLOSE,0); 
   macd6=iMACD(symbol6,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
  macd6s=iMACD(symbol6,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
  
      if ( ema26>ema16 && ema16>ema36 )       {codeAO6=233; ClrAO6=High_up_color; } 
      else 
      if ( ema26<ema16 && ema16<ema36 )       {codeAO6=234; ClrAO6=High_down_color; } 
      else
      if ( ema26>ema16 )       {codeAO6=233; ClrAO6=UpClr; } 
      else
      if ( ema26<ema16 )       {codeAO6=234; ClrAO6=DnClr; } 
      
      if ( sto6>80 ) {codeSTO6=233; ClrSTO6=High_up_color;}     
      if ( sto6>50 && sto6<80 )    {codeSTO6=233; ClrSTO6=UpClr;}
      if ( sto6<50 && sto6>20)     {codeSTO6=234; ClrSTO6=DnClr;}
      if ( sto6<20 ) {codeSTO6=234; ClrSTO6=High_down_color;}
      
      if ( cci6>0 && cci6<100 )     {codecci6=233; clrcci6=UpClr;}
      if ( cci6<0 && cci6>-100 )     {codecci6=234; clrcci6=DnClr;}
      if ( cci6>100)    {codecci6=233; clrcci6=High_up_color;}
      if ( cci6<-100)   {codecci6=234; clrcci6=High_down_color;}
      
      if ( rsi6>50 && rsi6<65 )    {codersi6=233; clrrsi6=UpClr;}
      if ( rsi6<50 && rsi6>35 )    {codersi6=234; clrrsi6=DnClr;}
      if ( rsi6<35 ) {codersi6=234; clrrsi6=High_down_color; }
      if ( rsi6>65 ) {codersi6=233; clrrsi6=High_up_color; }
      if ( macd6>0 && macd6<macd6s )     {codemacd6=233; clrmacd6=UpClr;}
      if ( macd6<0 && macd6>macd6s )     {codemacd6=234; clrmacd6=DnClr;}
      if ( macd6<0 && macd6<macd6s ) {codemacd6=234; clrmacd6=High_down_color;}
      if ( macd6>0 && macd6>macd6s ) {codemacd6=233; clrmacd6=High_up_color;}
      
   double ema17,ema27,sto7, cci7, rsi7,macd7,macd7s,ema37;
   ema17=iMA(symbol7,NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema27=iMA(symbol7,NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema37=iMA(symbol7,NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto7 =iStochastic(symbol7,NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);   
   cci7 =iCCI(symbol7,NULL,CCI_period,PRICE_CLOSE,0);  
   rsi7 =iRSI(symbol7,NULL,RSI_period,PRICE_CLOSE,0); 
   macd7=iMACD(symbol7,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
  macd7s=iMACD(symbol7,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   
      if ( ema27>ema17 && ema17>ema37 )       {codeao7=233; clrao7=High_up_color; } 
      else 
      if ( ema27<ema17 && ema17<ema37 )       {codeao7=234; clrao7=High_down_color; } 
      else
      if ( ema27>ema17 )       {codeao7=233; clrao7=UpClr; } 
      else
      if ( ema27<ema17 )       {codeao7=234; clrao7=DnClr; } 

      if ( sto7>80 ) {codesto7=233; clrsto7=High_up_color;}     
      if ( sto7>50 && sto7<80 )    {codesto7=233; clrsto7=UpClr;}
      if ( sto7<50 && sto7>20)     {codesto7=234; clrsto7=DnClr;}
      if ( sto7<20 ) {codesto7=234; clrsto7=High_down_color;}
      
      if ( cci7>0 && cci7<100 )     {codecci7=233; clrcci7=UpClr;}
      if ( cci7<0 && cci7>-100 )     {codecci7=234; clrcci7=DnClr;}
      if ( cci7>100)    {codecci7=233; clrcci7=High_up_color;}
      if ( cci7<-100)   {codecci7=234; clrcci7=High_down_color;}
      
      if ( rsi7>50 && rsi7<65 )    {codersi7=233; clrrsi7=UpClr;}
      if ( rsi7<50 && rsi7>35 )    {codersi7=234; clrrsi7=DnClr;}
      if ( rsi7<35 ) {codersi7=234; clrrsi7=High_down_color; }
      if ( rsi7>65 ) {codersi7=233; clrrsi7=High_down_color; }
      if ( macd7>0 && macd7<macd7s )     {codemacd7=233; clrmacd7=UpClr;}
      if ( macd7<0 && macd7>macd7s )     {codemacd7=234; clrmacd7=DnClr;}
      if ( macd7<0 && macd7<macd7s ) {codemacd7=234; clrmacd7=High_down_color;}
      if ( macd7>0 && macd7>macd7s ) {codemacd7=233; clrmacd7=High_up_color;}
      
   double ema18,ema28,sto8, cci8, rsi8,macd8,macd8s,ema38;
   ema18=iMA(symbol8,NULL,EMA2_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema28=iMA(symbol8,NULL,EMA1_period,0,MODE_EMA,PRICE_CLOSE,0);
   ema38=iMA(symbol8,NULL,EMA3_period,0,MODE_EMA,PRICE_CLOSE,0);
   sto8 =iStochastic(symbol8,NULL,Stochastic_period,3,3,MODE_SMA,0,MODE_MAIN,0);   
   cci8 =iCCI(symbol8,NULL,CCI_period,PRICE_CLOSE,0);  
   rsi8 =iRSI(symbol8,NULL,RSI_period,PRICE_CLOSE,0); 
   macd8=iMACD(symbol8,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_MAIN,0);
  macd8s=iMACD(symbol8,NULL,MACD_period,26,9,PRICE_CLOSE,MODE_SIGNAL,0);
   
      if ( ema28>ema18 && ema18>ema38 )       {codeao8=233; clrao8=High_up_color; } 
      else 
      if ( ema28<ema18 && ema18<ema38 )       {codeao8=234; clrao8=High_down_color; } 
      else
      if ( ema28>ema18 )       {codeao8=233; clrao8=UpClr; } 
      else
      if ( ema28<ema18 )       {codeao8=234; clrao8=DnClr; } 

      if ( sto8>80 ) {codesto8=233; clrsto8=High_up_color;}     
      if ( sto8>50 && sto8<80 )    {codesto8=233; clrsto8=UpClr;}
      if ( sto8<50 && sto8>20)     {codesto8=234; clrsto8=DnClr;}
      if ( sto8<20 ) {codesto8=234; clrsto8=High_down_color;}
      
      if ( cci8>0 && cci8<100 )     {codecci8=233; clrcci8=UpClr;}
      if ( cci8<0 && cci8>-100 )     {codecci8=234; clrcci8=DnClr;}
      if ( cci8>100)    {codecci8=233; clrcci8=High_up_color;}
      if ( cci8<-100)   {codecci8=234; clrcci8=High_down_color;}
      
      if ( rsi8>50 && rsi8<65 )    {codersi8=233; clrrsi8=UpClr;}
      if ( rsi8<50 && rsi8>35 )    {codersi8=234; clrrsi8=DnClr;}
      if ( rsi8<35 ) {codersi8=234; clrrsi8=High_down_color; }
      if ( rsi8>65 ) {codersi8=233; clrrsi8=High_up_color; }
      if ( macd8>0 && macd8<macd8s )     {codemacd8=233; clrmacd8=UpClr;}
      if ( macd8<0 && macd8>macd8s )     {codemacd8=234; clrmacd8=DnClr;}
      if ( macd8<0 && macd8<macd8s ) {codemacd8=234; clrmacd8=High_down_color;}
      if ( macd8>0 && macd8>macd8s ) {codemacd8=233; clrmacd8=High_up_color;}
 


 //     if (iAC( NULL , Period(), 1)<iAC( NULL , Period(), 0)) 
  //       {codeAC=217; ClrAC=UpClr;} else
  //       {codeAC=218; ClrAC=DnClr;} /* */
       
  //    if( i0.007( NULL , Period(),  
  //          FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, 1)< iMACD( NULL , Period(),  
 //           FastEMA, SlowEMA, SignalSMA, PRICE_CLOSE, MODE_MAIN, 0) ) 
  //        {codeMACD=217; ClrMACD=UpClr;} else
  //       {codeMACD=218; ClrMACD=DnClr;} 
         
          
     /* if(Alert_)
            {
               
               if(codeAO==217 && codeAC==217 && codeMACD==217)
                  {Alert(Symbol()+" "+PeriodToStr(Period())
                  +" : AO, AC and MACD are UP at "+TimeToStr(TimeCurrent(),TIME_MINUTES)); 
                  ObjectDelete(Pref+"Unidirection Alert"); }
               
               if(codeAO==218 && codeAC==218 && codeMACD==218)
                  {Alert(Symbol()+" "+PeriodToStr(Period())
                  +" : AO, AC and MACD are DOWN at "+TimeToStr(TimeCurrent(),TIME_MINUTES) ); 
                  ObjectDelete(Pref+"Unidirection Alert"); }
               
            }
          
      if(ObjectFind(Pref+"Unidirection Alert")<0)
            Alert_=!Alert_;
      if(Alert_)Alert_Clr=UpClr; else Alert_Clr=DnClr;*/ 
      
           
      DrawPanel();
//----


   return(0);
  }
//+------------------------------------------------------------------+
int DrawText( string name, datetime T, double P, string Text, int code=0, color Clr=Green,  int Fsize=10, int Win=0)
   { 
      if (name=="") name="Text_"+T;
      
      int Error=ObjectFind(name);// Запрос 
   if (Error!=Win)// Если объекта в ук. окне нет :(
    { 
      ObjectCreate(name, OBJ_TEXT, Win, T, P);
      }
      
      ObjectSet(name, OBJPROP_TIME1, T);
      ObjectSet(name, OBJPROP_PRICE1, P);
      
      if(code==0)
      ObjectSetText(name, Text ,Fsize,"Arial",Clr);
      else
      ObjectSetText(name, CharToStr(code), Fsize,"Wingdings",Clr);
   }
   
//--------------------------------------
void DrawPanel()
{     if(Y<0) Y=0;
      //if(Y>(WindowPriceMax()-WindowPriceMin())/Point-H)
      // Y=(WindowPriceMax()-WindowPriceMin())/Point-H;
      
     // TimeX=Time[WindowFirstVisibleBar()]+X*Period()*60; 
     // PriceY=WindowPriceMax()-Y*Point;
      
     // DrawRect( Pref+"Rect", TimeX, PriceY, TimeX+TimeW ,PriceY-PriceH, RectClr, 1, "");
      
     // DrawText( Pref+"Allow Hand Moving", TimeX+1*Period()*60, PriceY-1*Point, "", 73, HandClr );
      //DrawText( Pref+"Unidirection Alert", TimeX+1*Period()*60, PriceY-(1+StepS)*Point, "", 37, Alert_Clr );
      
     // DrawText( Pref+"AO", TimeX+4*Period()*60, PriceY-1*Point, "AO", 0,TxtClr );//0, 10, 0
    //  DrawText( Pref+"AC", TimeX+4*Period()*60, PriceY-(1+StepS)*Point, "AC", 0,TxtClr );
     // DrawText( Pref+"MACD", TimeX+3*Period()*60, PriceY-(1+2*StepS)*Point, "MACD", 0,TxtClr );
      
     // DrawText( Pref+"AO direction", TimeX+8*Period()*60, PriceY-1*Point, "", codeAO, ClrAO );
     // DrawText( Pref+"AC direction", TimeX+8*Period()*60, PriceY-(1+StepS)*Point, "", codeAC, ClrAC );
     // DrawText( Pref+"MACD direction", TimeX+8*Period()*60, PriceY-(1+2*StepS)*Point, "", codeMACD, ClrMACD );

       DrawLabels(Pref+"AOl",  Corner, X+0, Y+10, symbol1, 0,TxtClr, 0, 10);
       DrawLabels(Pref+"AO2",  Corner, X+60, Y+10, symbol2, 0,TxtClr, 0, 10);
       DrawLabels(Pref+"AO3",  Corner, X+120, Y+10, symbol3, 0,TxtClr, 0, 10);
       DrawLabels(Pref+"AO4",  Corner, X+180, Y+10, symbol4, 0,TxtClr, 0, 10);
       DrawLabels(Pref+"AO7",  Corner, X+240, Y+10, symbol5, 0,TxtClr, 0, 10);
       DrawLabels(Pref+"AO8",  Corner, X+300, Y+10, symbol6, 0,TxtClr, 0, 10);
       DrawLabels(Pref+"AO9",  Corner, X+360, Y+10, symbol7, 0,TxtClr, 0, 10);
       DrawLabels(Pref+"AO10",  Corner, X+420, Y+10, symbol8, 0,TxtClr, 0, 10);
       
       
       DrawLabels(Pref+"AO5",  Corner, X-30, Y+40, "MA", 0,TxtClr, 0, 10);
       DrawLabels(Pref+"AO6",  Corner, X-30, Y+90, "Stoch", 0,TxtClr, 0, 10);
       DrawLabels(Pref+"cci",  Corner, X-30, Y+140, "CCI", 0,TxtClr, 0, 10);
       DrawLabels(Pref+"rsi",  Corner, X-30, Y+190, "RSI", 0,TxtClr, 0, 10);
       DrawLabels(Pref+"macd",  Corner, X-30, Y+240, "MACD", 0,TxtClr, 0, 10);

//     DrawLabels(Pref+" ",  Corner, X, Y+RowStep, " ",0, TxtClr, 0, FSize);
//     DrawLabels(Pref+"MACD",  Corner, X, Y+RowStep*2, " ", 0,TxtClr, 0, FSize);
     
       DrawLabels(Pref+"AO direction",  Corner, X-ColStep+30, Y+30, "", codeAO,ClrAO, 0, 20);
       DrawLabels(Pref+"AO2 direction",  Corner, X-ColStep+90, Y+30, "", codeAO2,ClrAO2, 0, 20);
       DrawLabels(Pref+"AO3 direction",  Corner, X-ColStep+150, Y+30, "", codeAO3,ClrAO3, 0, 20);
       DrawLabels(Pref+"AO4 direction",  Corner, X-ColStep+210, Y+30, "", codeAO4,ClrAO4, 0, 20);
       DrawLabels(Pref+"AO9 direction",  Corner, X-ColStep+270, Y+30, "", codeAO5,ClrAO5, 0, 20);
       DrawLabels(Pref+"AO1 direction",  Corner, X-ColStep+330, Y+30, "", codeAO6,ClrAO6, 0, 20);
       DrawLabels(Pref+"AO10 direction",  Corner, X-ColStep+390, Y+30, "", codeao7,clrao7, 0, 20);
       DrawLabels(Pref+"AO11 direction",  Corner, X-ColStep+450, Y+30, "", codeao8,clrao8, 0, 20);
       
       DrawLabels(Pref+"AO5 direction",  Corner, X-ColStep+30, Y+80, "", codeSTO,ClrSTO, 0, 20);
       DrawLabels(Pref+"AO6 direction",  Corner, X-ColStep+90, Y+80, "", codeSTO2,ClrSTO2, 0, 20);
       DrawLabels(Pref+"AO7 direction",  Corner, X-ColStep+150, Y+80, "", codeSTO3,ClrSTO3, 0, 20);
       DrawLabels(Pref+"AO8 direction",  Corner, X-ColStep+210, Y+80, "", codeSTO4,ClrSTO4, 0, 20);
       DrawLabels(Pref+"AO81 direction",  Corner, X-ColStep+270, Y+80, "", codeSTO5,ClrSTO5, 0, 20);
       DrawLabels(Pref+"AO82 direction",  Corner, X-ColStep+330, Y+80, "", codeSTO6,ClrSTO6, 0, 20);
       DrawLabels(Pref+"AO87 direction",  Corner, X-ColStep+390, Y+80, "", codesto7,clrsto7, 0, 20);
       DrawLabels(Pref+"AO88 direction",  Corner, X-ColStep+450, Y+80, "", codesto8,clrsto8, 0, 20);

       DrawLabels(Pref+"cci direction",   Corner, X-ColStep+30, Y+130, "",  codecci, clrcci, 0, 20);
       DrawLabels(Pref+"cci2 direction",  Corner, X-ColStep+90, Y+130, "",  codecci2,clrcci2, 0, 20);
       DrawLabels(Pref+"cci3 direction",  Corner, X-ColStep+150, Y+130, "", codecci3,clrcci3, 0, 20);
       DrawLabels(Pref+"cci4 direction",  Corner, X-ColStep+210, Y+130, "", codecci4,clrcci4, 0, 20);
       DrawLabels(Pref+"cci5 direction",  Corner, X-ColStep+270, Y+130, "", codecci5,clrcci5, 0, 20);
       DrawLabels(Pref+"cci6 direction",  Corner, X-ColStep+330, Y+130, "", codecci6,clrcci6, 0, 20);
       DrawLabels(Pref+"cci57 direction",  Corner, X-ColStep+390, Y+130, "", codecci7,clrcci7, 0, 20);
       DrawLabels(Pref+"cci68 direction",  Corner, X-ColStep+450, Y+130, "", codecci8,clrcci8, 0, 20);

       DrawLabels(Pref+"rsi direction",   Corner, X-ColStep+30, Y+180, "",  codersi, clrrsi, 0, 20);
       DrawLabels(Pref+"rsi2 direction",  Corner, X-ColStep+90, Y+180, "",  codersi2,clrrsi2, 0, 20);
       DrawLabels(Pref+"rsi3 direction",  Corner, X-ColStep+150, Y+180, "", codersi3,clrrsi3, 0, 20);
       DrawLabels(Pref+"rsi4 direction",  Corner, X-ColStep+210, Y+180, "", codersi4,clrrsi4, 0, 20);
       DrawLabels(Pref+"rsi5 direction",  Corner, X-ColStep+270, Y+180, "", codersi5,clrrsi5, 0, 20);
       DrawLabels(Pref+"rsi6 direction",  Corner, X-ColStep+330, Y+180, "", codersi6,clrrsi6, 0, 20);
       DrawLabels(Pref+"rsi57 direction",  Corner, X-ColStep+390, Y+180, "", codersi7,clrrsi7, 0, 20);
       DrawLabels(Pref+"rsi68 direction",  Corner, X-ColStep+450, Y+180, "", codersi8,clrrsi8, 0, 20);

       DrawLabels(Pref+"macdrsi direction",   Corner, X-ColStep+30, Y+230, "",  codemacd, clrmacd, 0, 20);
       DrawLabels(Pref+"macdrsi2 direction",  Corner, X-ColStep+90, Y+230, "",  codemacd2,clrmacd2, 0, 20);
       DrawLabels(Pref+"macdrsi3 direction",  Corner, X-ColStep+150, Y+230, "", codemacd3,clrmacd3, 0, 20);
       DrawLabels(Pref+"macdrsi4 direction",  Corner, X-ColStep+210, Y+230, "", codemacd4,clrmacd4, 0, 20);
       DrawLabels(Pref+"macdrsi5 direction",  Corner, X-ColStep+270, Y+230, "", codemacd5,clrmacd5, 0, 20);
       DrawLabels(Pref+"macdrsi6 direction",  Corner, X-ColStep+330, Y+230, "", codemacd6,clrmacd6, 0, 20);
       DrawLabels(Pref+"macdrsi57 direction",  Corner, X-ColStep+390, Y+230, "", codemacd7,clrmacd7, 0, 20);
       DrawLabels(Pref+"macdrsi68 direction",  Corner, X-ColStep+450, Y+230, "", codemacd8,clrmacd8, 0, 20);

//     DrawLabels(Pref+"AC direction",  Corner, X-ColStep, Y+RowStep, "", codeAC, ClrAC, 0, FSize);
//     DrawLabels(Pref+"MACD direction",  Corner, X-ColStep, Y+RowStep*2, "", codeMACD, ClrMACD, 0, FSize);
      
   

      
      

}

//---------------------------------
int DrawRect( string name, datetime T1, double P1,datetime T2, double P2,
                    color Clr=Green, int Width=1, string Text="", int Win=0)
   { 
      if (name=="") name="Text_"+T1;
      
      int Error=ObjectFind(name);// Запрос 
    if (Error!=Win)// Если объекта в ук. окне нет :(
    {  
      ObjectCreate(name, OBJ_RECTANGLE, Win,T1,P1,T2,P2);//создание трендовой линии
    }
     
    ObjectSet(name, OBJPROP_TIME1 ,T1);
    ObjectSet(name, OBJPROP_PRICE1,P1);
    ObjectSet(name, OBJPROP_TIME2 ,T2);
    ObjectSet(name, OBJPROP_PRICE2,P2);
    ObjectSet(name,OBJPROP_BACK, false);
    ObjectSet(name,OBJPROP_STYLE,0);
    ObjectSet(name, OBJPROP_COLOR , Clr);
    ObjectSet(name, OBJPROP_WIDTH , Width);
    ObjectSetText(name,Text);
    

    
    }
///-----------------------
void Delete_My_Obj(string Prefix)
   {//Alert(ObjectsTotal());
   for(int k=ObjectsTotal()-1; k>=0; k--)  // По количеству всех объектов 
     {
      string Obj_Name=ObjectName(k);   // Запрашиваем имя объекта
      string Head=StringSubstr(Obj_Name,0,StringLen(Prefix));// Извлекаем первые сим

      if (Head==Prefix)// Найден объект, ..
         {
         ObjectDelete(Obj_Name);
         //Alert(Head+";"+Prefix);
         }                
        
     }
   }
///=====================
string PeriodToStr(int Per)
   {
      switch(Per)                 // Расчёт  для..     
      {                              // .. различных ТФ     
      case     1: return("M1"); break;// Таймфрейм М1      
      case     5: return("M5"); break;// Таймфрейм М5      
      case    15: return("M15"); break;// Таймфрейм М15      
      case    30: return("M30"); break;// Таймфрейм М30      
      case    60: return("H1"); break;// Таймфрейм H1      
      case   2340: return("H4"); break;// Таймфрейм H4      
      case  1440: return("D1"); break;// Таймфрейм D1      
      case 10080: return("W1"); break;// Таймфрейм W1      
      case 43200: return("МN"); break;// Таймфрейм МN     
      }
 }
//==================================
/*int CalculeH()
   {
      switch(Period())                 // Расчёт  для..     
      {                              // .. различных ТФ     
      case     1: return(15); break;// Таймфрейм М1      
      case     5: return(15); break;// Таймфрейм М5      
      case    15: return(30); break;// Таймфрейм М15      
      case    30: return(45); break;// Таймфрейм М30      
      case    60: return(60); break;// Таймфрейм H1      
      case   2340: return(180); break;// Таймфрейм H4      
      case  1440: return(270); break;// Таймфрейм D1      
      case 10080: return(450); break;// Таймфрейм W1      
      case 43200: return(900); break;// Таймфрейм МN     
      }   
    }*/
    
int DrawLabels(string name, int corn, int X, int Y, string Text, int code=0, color Clr=Green, int Win=0, int FSize=10)
   {
     int Error=ObjectFind(name);// Запрос 
   if (Error!=Win)// Если объекта в ук. окне нет :(
    {  
      ObjectCreate(name,OBJ_LABEL,Win, 0,0); // Создание объекта
    }
     
     ObjectSet(name, OBJPROP_CORNER, corn);     // Привязка к углу   
     ObjectSet(name, OBJPROP_XDISTANCE, X);  // Координата Х   
     ObjectSet(name,OBJPROP_YDISTANCE,Y);// Координата Y   
     ObjectSetText(name,Text,FSize,"Arial",Clr);
          if(code==0)
      ObjectSetText(name, Text ,FSize,"Arial",Clr);
      else
      ObjectSetText(name, CharToStr(code), FSize,"Wingdings",Clr);
   }