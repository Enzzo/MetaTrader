//+------------------------------------------------------------------+
//|                                                   DiverStoch.mq4 |
//|                                                            ViDan |
//|                                                vi_dancom@mail.ru |
//+------------------------------------------------------------------+
#property copyright "ViDan"
#property link      "vi_dancom@mail.ru"

#property indicator_chart_window
#property indicator_buffers 3

#define arrowsDisplacement 0.0001
extern color  ColorBull = Blue;
extern color  ColorBear = Red;
extern bool   displayAlert = false;//true;
extern bool   English = false;
//Для MACD
extern int i_fastEMA = 12;
extern int i_slowEMA = 26;
extern int i_signalMA = 9;
//--- MACD
//---- buffers
double MACDLineBuffer[];
double bullishDivergence[];
double bearishDivergence[];
//---- variables
//////
static datetime lastAlertTime;
static string   indicatorName;
static bool b_first = true;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   //---- indicators
   SetIndexStyle(0, DRAW_NONE);
   SetIndexBuffer(0, MACDLineBuffer);
   SetIndexStyle(1, DRAW_NONE);
   SetIndexBuffer(1, bullishDivergence);
   SetIndexStyle(2, DRAW_NONE);
   SetIndexBuffer(2, bearishDivergence);
   return(0);
}
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   for(int i = ObjectsTotal() - 1; i >= 0; i--)
     {
       string label = ObjectName(i);
       if(StringSubstr(label, 0, 19) != "MACD_DivergenceLine")
           continue;
       ObjectDelete(label);   
     }
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   if (b_first)
//Если первый запуск - найдем MACD и определим его параметры
   {
   string s_parMACD = s_isMACD();
if (s_parMACD !="") 
{
   //if (s_parMACD =="") 
  // {
//   if (English) Alert ("No MACDc!   ", Symbol(), " , ", s_GetPeriod (Period()));
//   else Alert ("На графике нет MACD!   ", Symbol(), " , ", s_GetPeriod (Period()));
      //return(0);
 //  }
 i_fastEMA = StrToDouble(s_GetPer(s_parMACD, ",",1));
 i_slowEMA = StrToDouble(s_GetPer(s_parMACD, ",",2));
 i_signalMA = StrToDouble(s_GetPer(s_parMACD, ",",3));
}
indicatorName =("MACD(" + i_fastEMA+"," + i_slowEMA + "," + i_signalMA + ")");
b_first = false;
   }
      
   int limit;
   int counted_bars = IndicatorCounted();
   //---- check for possible errors
   if(counted_bars < 0) 
       return(-1);
   //---- last counted bar will be recounted
   if(counted_bars > 0) 
       counted_bars--;
   limit = Bars - counted_bars;
   CalculateIndicator(counted_bars);
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateIndicator(int countedBars)
  {
   for(int i = Bars - countedBars; i >= 0; i--)
     {
       CalculateMACD(i);
       CatchBullishDivergence(i + 2);
       CatchBearishDivergence(i + 2);
     }              
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CalculateMACD(int i)
  {
   MACDLineBuffer[i] = iMACD(NULL, 0, i_fastEMA,i_slowEMA,i_signalMA,PRICE_CLOSE,MODE_MAIN,i);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CatchBullishDivergence(int shift)
  {
   if(IsIndicatorTrough(shift) == false)
       return;  
   int currentTrough = shift;
   int lastTrough = GetIndicatorLastTrough(shift);
//----   
   if(MACDLineBuffer[currentTrough] > MACDLineBuffer[lastTrough] && 
      Low[currentTrough] < Low[lastTrough])
     {
       bullishDivergence[currentTrough] = MACDLineBuffer[currentTrough] - 
                                          arrowsDisplacement;
       //----
           DrawPriceTrendLine(Time[currentTrough], Time[lastTrough], 
                              Low[currentTrough], 
                             Low[lastTrough], ColorBull, STYLE_SOLID);
       //----
          DrawIndicatorTrendLine(Time[currentTrough], 
                                 Time[lastTrough], 
                                 MACDLineBuffer[currentTrough],
                                 MACDLineBuffer[lastTrough], 
                                 ColorBull, STYLE_SOLID);
       //----
       if(displayAlert == true)
          if (English) DisplayAlert("Classical bullish divergence on: "+indicatorName+", ", currentTrough);  
          else  DisplayAlert("Классическая бычья дивергенция на: "+indicatorName+", ", currentTrough);  
     }
//----   
   if(MACDLineBuffer[currentTrough] < MACDLineBuffer[lastTrough] && 
      Low[currentTrough] > Low[lastTrough])
     {
       bullishDivergence[currentTrough] = MACDLineBuffer[currentTrough] - 
                                          arrowsDisplacement;
       //----
           DrawPriceTrendLine(Time[currentTrough], Time[lastTrough], 
                              Low[currentTrough], 
                              Low[lastTrough], ColorBull, STYLE_DOT);
       //----
           DrawIndicatorTrendLine(Time[currentTrough], 
                                  Time[lastTrough], 
                                  MACDLineBuffer[currentTrough],
                                  MACDLineBuffer[lastTrough], 
                                  ColorBull, STYLE_DOT);
       //----
       if(displayAlert == true)
           if (English)DisplayAlert("Reverse bullish divergence on: "+indicatorName+", ", currentTrough);   
           else DisplayAlert("Обратная бычья дивергенция на: "+indicatorName+", ", currentTrough);   
     }      
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CatchBearishDivergence(int shift)
  {
   if(IsIndicatorPeak(shift) == false)
       return;
   int currentPeak = shift;
   int lastPeak = GetIndicatorLastPeak(shift);
//----   
   if(MACDLineBuffer[currentPeak] < MACDLineBuffer[lastPeak] && 
      High[currentPeak] > High[lastPeak])
     {
       bearishDivergence[currentPeak] = MACDLineBuffer[currentPeak] + 
                                        arrowsDisplacement;
      
           DrawPriceTrendLine(Time[currentPeak], Time[lastPeak], 
                              High[currentPeak], 
                              High[lastPeak], ColorBear, STYLE_SOLID);
                            
           DrawIndicatorTrendLine(Time[currentPeak], Time[lastPeak], 
                                  MACDLineBuffer[currentPeak],
                                  MACDLineBuffer[lastPeak], ColorBear, STYLE_SOLID);

       if(displayAlert == true)
           if (English) DisplayAlert("Classical bearish divergence on: "+indicatorName+", ", currentPeak);  
           else DisplayAlert("Классическая медвежья дивергенция на: "+indicatorName+", ", currentPeak);  
     }
   if(MACDLineBuffer[currentPeak] > MACDLineBuffer[lastPeak] && 
      High[currentPeak] < High[lastPeak])
     {
       bearishDivergence[currentPeak] = MACDLineBuffer[currentPeak] + 
                                        arrowsDisplacement;
       //----
           DrawPriceTrendLine(Time[currentPeak], Time[lastPeak], 
                              High[currentPeak], 
                              High[lastPeak], ColorBear, STYLE_DOT);
       //----
           DrawIndicatorTrendLine(Time[currentPeak], Time[lastPeak], 
                                  MACDLineBuffer[currentPeak],
                                  MACDLineBuffer[lastPeak], ColorBear, STYLE_DOT);
       //----
       if(displayAlert == true)
           if (English) DisplayAlert("Reverse bearish divergence on: "+indicatorName+", ", currentPeak);   
           else DisplayAlert("Обратная медвежья дивергенция на: "+indicatorName+", ", currentPeak);   
        }   
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsIndicatorPeak(int shift)
  {
   if(MACDLineBuffer[shift] >= MACDLineBuffer[shift+1] && MACDLineBuffer[shift] > MACDLineBuffer[shift+2] && 
      MACDLineBuffer[shift] > MACDLineBuffer[shift-1])
       return(true);
   else 
       return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsIndicatorTrough(int shift)
  {
   if(MACDLineBuffer[shift] <= MACDLineBuffer[shift+1] && MACDLineBuffer[shift] < MACDLineBuffer[shift+2] && 
      MACDLineBuffer[shift] < MACDLineBuffer[shift-1])
       return(true);
   else 
       return(false);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetIndicatorLastPeak(int shift)
  {
   for(int i = shift + 5; i < Bars; i++)
     {
         {
           for(int j = i; j < Bars; j++)
             {
               if(MACDLineBuffer[j] >= MACDLineBuffer[j+1] && MACDLineBuffer[j] > MACDLineBuffer[j+2] &&
                  MACDLineBuffer[j] >= MACDLineBuffer[j-1] && MACDLineBuffer[j] > MACDLineBuffer[j-2])
                   return(j);
             }
         }
     }
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetIndicatorLastTrough(int shift)
  {
    for(int i = shift + 5; i < Bars; i++)
      {
          {
            for (int j = i; j < Bars; j++)
              {
                if(MACDLineBuffer[j] <= MACDLineBuffer[j+1] && MACDLineBuffer[j] < MACDLineBuffer[j+2] &&
                   MACDLineBuffer[j] <= MACDLineBuffer[j-1] && MACDLineBuffer[j] < MACDLineBuffer[j-2])
                    return(j);
              }
          }
      }
    return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DisplayAlert(string message, int shift)
  {
   if(shift <= 2 && Time[shift] != lastAlertTime)
     {
       lastAlertTime = Time[shift];
       Alert(message, Symbol(), " , ", s_GetPeriod (Period()));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawPriceTrendLine(datetime x1, datetime x2, double y1, 
                        double y2, color lineColor, double style)
  {
   string label = "MACD_DivergenceLine.0# " + DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, 0, x1, y1, x2, y2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawIndicatorTrendLine(datetime x1, datetime x2, double y1, 
                            double y2, color lineColor, double style)
  {
   int indicatorWindow = WindowFind(indicatorName);
   if(indicatorWindow < 0)
       return;
   string label = "MACD_DivergenceLine - " + DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, indicatorWindow, x1, y1, x2, y2, 
                0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
  }
//+------------------------------------------------------------------+
////Функция возвращает параметры стандартного MACD, если он присутствует на графике
  string s_isMACD()
 {
    for (int j = 1; j <=24; j++)
    {
      for (int i = 1; i <=44; i++)
      {
         for (int k = 1; k <=24; k++)
         {
          if (WindowFind("MACD(" + DoubleToStr(j,0)+"," + DoubleToStr(i,0) + "," 
          + DoubleToStr(k,0) + ")") != -1) return(DoubleToStr(j,0)+"," + DoubleToStr(i,0) 
          + "," + DoubleToStr(k,0));
         }
      }
    }
 }
//+------------------------------------------------------------------+
////Выделяет переменную из перечисления с разделителем razD
string s_GetPer(string s_stRoka, string s_razD,int i_pozPer)
{
string s_vrPer = s_stRoka + s_razD;
string s_mnk1S = "", s_mnk1;
int i_mnk = 0;
for (int j = 0; j <= StringLen(s_vrPer)-1;j++)
  {
s_mnk1 = StringSubstr(s_vrPer, j, 1);
    if (s_mnk1 == s_razD) 
    {
     i_mnk++;
     if (i_mnk < i_pozPer) s_mnk1S = "";
    }
    else
    {
     s_mnk1S = s_mnk1S + s_mnk1;
    }
     if (i_mnk == i_pozPer) return (s_mnk1S);
  }
}

///Возвращает период графика в виде строки
string s_GetPeriod (int i_per)
{
switch ( i_per )
    {
        case 1:            return("M1 ");
        case 5:            return("M5 ");
        case 15:           return("M15");
        case 30:           return("M30");
        case 60:           return("H1 ");
        case 240:          return("H4 ");
        case 1440:         return("D1 ");
        case 10080:        return("W1 ");
        case 43200:        return("MN1");
    }
}