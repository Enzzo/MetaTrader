//+------------------------------------------------------------------+
//|                                                          SMI.mq4 |
//+------------------------------------------------------------------+
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_color1 White
#property indicator_color2 Red
#property indicator_level1 0

//---- input parameters
input double    up = 30.0;
input double    dn = -30.0;
input int       Period_Q=2;
input int       Period_R=8;
input int       Period_S=5;
input int       Signal=5;
input int       alerts = true;

//---- buffers
double SMI_Buffer[];
double Signal_Buffer[];
double SM_Buffer[];
double EMA_SM[];
double EMA2_SM[];
double EMA_HQ[];
double EMA2_HQ[];
double HQ_Buffer[];

string tf_to_string(){  
  switch(Period()){
    case (PERIOD_M1): return "M1";
    case (PERIOD_M5): return "M5";
    case (PERIOD_M15): return "M15";
    case (PERIOD_M30): return "M30";
    case (PERIOD_H1): return "H1";
    case (PERIOD_H4): return "H4";
    case (PERIOD_D1): return "D1";
    case (PERIOD_W1): return "W1";
    case (PERIOD_MN1): return "MN1";
  }
  return "";
}
string alert = Symbol() + " " + tf_to_string();

enum ENUM_STATES{
  RANGE = -1,
  OUT
} state;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
    if(up <= 0.0 || dn >= 0.0 ){
      Alert("Неверные значения уровней");
      return (INIT_FAILED);
    }

  IndicatorSetInteger(INDICATOR_LEVELS, 2);
  IndicatorSetDouble(INDICATOR_LEVELVALUE, 0, up);
  IndicatorSetDouble(INDICATOR_LEVELVALUE, 1, dn);
  IndicatorSetInteger(INDICATOR_LEVELCOLOR, 0, clrRed);
  IndicatorSetInteger(INDICATOR_LEVELSTYLE, 0, STYLE_DOT);

//---- indicators
   IndicatorBuffers(8);
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,SMI_Buffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,Signal_Buffer);
   SetIndexLabel(0,"SMI");
   SetIndexLabel(1,"Signal SMI");
   SetIndexBuffer(2,SM_Buffer);
   SetIndexBuffer(3,EMA_SM);
   SetIndexBuffer(4,EMA2_SM);
   SetIndexBuffer(5,EMA_HQ);
   SetIndexBuffer(6,EMA2_HQ);
   SetIndexBuffer(7,HQ_Buffer);

   IndicatorShortName("SMI("+Period_Q+","+Period_R+","+Period_S+","+Signal+")");
//----
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{}
  
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[]){
   int limit;
   int counted_bars=IndicatorCounted();
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
   
   for(int i=0; i<limit; i++)
     {
      HQ_Buffer[i]=High[iHighest(Symbol(),PERIOD_CURRENT,MODE_HIGH,Period_Q,i)]-Low[Lowest(Symbol(),PERIOD_CURRENT,MODE_LOW,Period_Q,i)];
      SM_Buffer[i]=Close[i]-(High[Highest(Symbol(),PERIOD_CURRENT,MODE_HIGH,Period_Q,i)]+Low[Lowest(Symbol(),PERIOD_CURRENT,MODE_LOW,Period_Q,i)])/2;//Median_Q[i];
     }
     
   for(i=0; i<limit; i++)
     {
      EMA_SM[i]=iMAOnArray(SM_Buffer,0,Period_R,0,MODE_EMA,i);
      EMA_HQ[i]=iMAOnArray(HQ_Buffer,0,Period_R,0,MODE_EMA,i);
     }
     
   for(i=0; i<limit; i++)
     {
      EMA2_SM[i]=iMAOnArray(EMA_SM,0,Period_S,0,MODE_EMA,i);
      EMA2_HQ[i]=iMAOnArray(EMA_HQ,0,Period_S,0,MODE_EMA,i);
     }
     
   for(i=0; i<limit; i++)
     {
      SMI_Buffer[i]=100*EMA2_SM[i]/0.5/EMA2_HQ[i];
     }
     
   for(i=0; i<limit; i++)
     {
      Signal_Buffer[i]=iMAOnArray(SMI_Buffer,0,Signal,0,MODE_EMA,i);
     }
  
  double sb1 = Signal_Buffer[1];

  switch(state){
    case RANGE:{
      if(sb1 < dn){
        if(alerts) Alert(alert + " перепродан");
        state = OUT;        
      }
      if(sb1 > up){
        if(alerts) Alert(alert + " перекуплен");
        state = OUT;
      }
      break;
    }
    case OUT:{
      if(sb1 > dn && sb1 < up){
        state = RANGE;
      }
    }
  }
  return(rates_total);
}
//+------------------------------------------------------------------+