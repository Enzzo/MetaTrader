//|------------------------------------------------------------------|
//|                                               Indicator Arrow.mq4|
//|                                    Copyright © 2013, Mr.SilverKZ |
//|                                                 SilverKZ@mail.kz |
//|                                                                  |
//|                                                                  |
//|                                                                  |
//|  свечи в коде идут  5-4-3-2-1-0                                  |
//|                                                                  |
//+------------------------------------------------------------------+



#property copyright "SilverKZ"
#property link "SilverKZ@mail.kz"

#property description "Находит 3 свечи подряд с одинаковыми H или L"
#property description "*поручик*                         27.11.15"

#property indicator_chart_window
#property indicator_buffers 2
#property indicator_color1 clrRed
#property indicator_color2 clrBlue

double buf_1[];
double buf_2[];
//+------------------------------------------------------------------+
//| Функция инициализации, запускается один раз                      |
//+------------------------------------------------------------------+
int init() 
  {
   SetIndexBuffer(0,buf_1);
   SetIndexBuffer(1,buf_2);

   SetIndexStyle (0,DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexStyle (1,DRAW_ARROW, STYLE_SOLID, 1);
   SetIndexArrow (0,233);
   SetIndexArrow (1,234);

   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   
   return(0);
  }
//+------------------------------------------------------------------+
//| Основная Функция, запускается на каждом тике                     |
//+------------------------------------------------------------------+
int start(){
   if (Bars <= 100) return(0);
   int ExtCountedBars = IndicatorCounted();
   if (ExtCountedBars < 0) return(-1);
   if (ExtCountedBars > 0) ExtCountedBars--;
   for (int i=Bars-ExtCountedBars-1; i>=0; i--){ 
      if (High [i+2] == High[i+3])
         bool DOWN = High[i+1]== High[i+2]; 
                                               
                    
      if (Low [i+2] == Low [i+3])             
         bool UP = Low[i+1]==Low[i+2] ;
      
       
      if (UP)   buf_1[i+1] = Low[i+1]-3*Point;
      if (DOWN) buf_2[i+1] = High[i+1]+3*Point;
   }
   return(0);
}
  //  ---- end