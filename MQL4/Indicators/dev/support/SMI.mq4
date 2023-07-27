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

//---- buffers
double SMI_Buffer[];
double Signal_Buffer[];
double SM_Buffer[];
double EMA_SM[];
double EMA2_SM[];
double EMA_HQ[];
double EMA2_HQ[];
double HQ_Buffer[];

bool os = false;
bool ob = false;
string alert = Symbol() + " " + PERIOD_CURRENT;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
    if(up <= 0.0 || dn >= 0.0 ){
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
  double sb2 = Signal_Buffer[2];

  if(!os){
    if(sb1 <= dn && sb2 >= dn && sb1 != sb2){
        Alert(alert + " oversold");
        os = true;
        ob = false;
        return (rates_total);        
    }
  }

  if(!ob){
    if(sb1 >= up && sb2 <= up && sb1 != sb2){
        Alert(alert + " overbought");
        os = false;
        ob = true;
        return (rates_total);
    }
  }
  return(rates_total);
}
//+------------------------------------------------------------------+