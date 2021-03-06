//+------------------------------------------------------------------+
//|                                                GerchikLevels.mq4 |
//|                                                             Enzo |
//|                                         http://vk.com/id29520847 |
//+------------------------------------------------------------------+
#property copyright "Enzo"
#property link      "http://vk.com/id29520847"
#property version   "1.00"
#property strict
#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Green;
#property indicator_color2 Red;
#property indicator_color3 Red;
#property indicator_color4 Green;

input int BARS = 1000;
input int RANGE = 5;    //Диапазон, на котором ищем уровень
input int COUNT = 3;    //Минимальное количество свечей, экстремумы которых должны находиться на одном уровне. Значение не должно быть больше RANGE.
input int DELTA = 20;   //Допустимое отклонение цены от базового уровня

int bars = BARS;
int range = RANGE;
int count = COUNT;
double delta = NormalizeDouble(DELTA * Point(), Digits());

double highBuffer[];
double lowBuffer[];
double highArrowBuffer[];
double lowArrowBuffer[];

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit(){
//--- indicator buffers mapping
   if(count > range){
      Alert("Параметр COUNT не должен быть больше RANGE. \nУстановлено новое значение: COUNT = "+ITS(RANGE));
      count = range;
   }
   if(count < 2){
      Alert("Параметр COUNT не должен быть меньше 2. \nУстановлено новое значение: COUNT = "+ITS(2));
      count = 2;
   }
   if(bars >= Bars - range){
      Alert("Количество баров, заданное в настройках, превышает количество баров на графике. \nУстановлено новое значение: BARS = "+ITS(Bars));
      bars = Bars - range;
   }
   if(bars < range){
      Alert("Количество баров, заданное в настройках, меньше, чем диапазон. \nУстановлено новое значение: BARS = "+ITS(range));
      bars = range;
   }
   
   IndicatorBuffers(4);   
   
   SetIndexBuffer(0, highBuffer);
   SetIndexBuffer(1, lowBuffer);
   SetIndexBuffer(2, highArrowBuffer);
   SetIndexBuffer(3, lowArrowBuffer);
   
   SetIndexStyle(0, DRAW_LINE);
   SetIndexStyle(1, DRAW_LINE);
   SetIndexStyle(2, DRAW_ARROW);
   SetIndexArrow(2, 234);
   SetIndexStyle(3, DRAW_ARROW);
   SetIndexArrow(3, 233);
   
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   
//---
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
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
//---
   static bool findNextHighLevel = true;
   static bool findNextLowLevel = true;
   
   int calculated = rates_total - prev_calculated;
   //На каждом новом баре проверяему уровни Герчика
   if(calculated > 0){
   
      //baseFrom и baseTo - базовые точки для поиска уровня. Это БПУ.
      //начинаем с самого начала графика и заканчиваем минимальным количеством свечей (count)
      int baseFrom = bars + range;
      int baseTo = count;
      int lastHigh = 0;
      int lastLow = 0;
      bool findHigh = true;
      bool findLow = true;
      int highPoints[];
      int lowPoints[];
      ArrayResize(highPoints, range);
      ArrayResize(lowPoints, range);
      //Перебираем каждую цену до count. В этом цикле только потенциальные базовые уровни.
      for(int i = baseFrom; i > baseTo; --i){
         int counterHigh = 0;
         int counterLow = 0;
         
         ZeroMemory(highPoints);
         ZeroMemory(lowPoints);
         if(i < lastHigh || lastHigh == 0)findHigh = true;
         else findHigh = false;
         if(i < lastLow || lastLow == 0)findLow = true;
         else findLow = false;
         //Print(lastHigh+"  "+i);
         //j вынес специально, чтобы использовать его при отрисовке уровней как конечную точку
         int j = 0;
         for(j = i+1; j > 0 && j < bars && j > i-range; --j){
            
            //Сверяем верхний уровень
            if(findHigh &&
               high[i] <= high[j] + delta &&
               high[i] >= high[j] - delta){
               highPoints[counterHigh++] = lastHigh = j;
            }
            //Сверяем нижний уровень
            if(findLow &&
               low[i] <= low[j] + delta &&
               low[i] >= low[j] - delta){
               lowPoints[counterLow++] = lastLow = j;
            }
         }
         if(counterHigh >= count){
            FillBufferLine(high[i], i, lastHigh, highBuffer);
            ShowPoints(high[i]+20*Point(), highPoints, highArrowBuffer);
         }
         if(counterLow  >= count){
            FillBufferLine(low[i],  i, lastLow, lowBuffer);
            ShowPoints(low[i]-20*Point(), lowPoints, lowArrowBuffer);
         }
      }
   }
//--- return value of prev_calculated for next call
   return(rates_total);
}
//+------------------------------------------------------------------+

string ITS(const int i){
   return IntegerToString(i);
}

void FillBufferLine(const double level, const int from, const int to, double& buffer[]){
   for(int i = from; i >= to; buffer[i--] = level);
}

void ShowPoints(const double level, const int& points[], double& buffer[]){
   for(int i = 0; i < ArraySize(points);)
      buffer[points[i++]] = level;
}