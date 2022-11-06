//+------------------------------------------------------------------+
//|                                                         i-AO.mq4 |
//|                      Copyright © 2010, Dmitry Zhebrak aka Necron |
//|                                                  www.mqlcoder.ru |
//+------------------------------------------------------------------+
//|Данный продукт предназначен для некомерческого                    |
//|использования. Публикация разрешена только при указании имени     |
//|автора ( Necron ). Редактирование исходного разрешается только при|
//|условии сохранения данного текста, ссылок и имени автора. Продажа |
//|индикатора или отдельных его частей ЗАПРЕЩЕНА.                    |
//|Автор не несет ответственности за возможные убытки, полученные в  |
//|результате использования индикатора.                              |
//|По всем вопросам, связанными с работой индикатора или             |
//|или предложениями по его доработке обращаться на email:           |
//|mqlcoder@yandex.ru                                                |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, D.Zhebrak aka Necron"
#property link      "www.mqlcoder.ru"
#property link      "mailto: mqlcoder@yandex.ru"

#define   version   "1.0.0.0"

//---- подключаем ядро системы Profitunity_MT4
#include <b-Profitunity_MT4.mqh>
//---- Настройки цветов для отображения
#property  indicator_separate_window
#property  indicator_buffers 7
#property  indicator_color2  Lime
#property  indicator_color3  Red
#property  indicator_color4  BlueViolet
#property  indicator_color5  Violet
#property  indicator_color6  Orange
#property  indicator_color7  DodgerBlue

//---- Внешние настройки индикатора
//extern int     BarsToProcess=200;      //максимальное колличество баров для расчета (-1 все)
extern int     BarsToF2Peak=140;       //количество баров для поиска сигнала "два пика"
extern int     width=0.5;                //размер значка
extern bool    alert=true;             //при true оповещает сигналом

//---- буферы для отображения индикатора
double      ExtBuffer0[],
            ExtBuffer1[],
            ExtBuffer2[],
            ExtBuffer3[],
            ExtBuffer4[],
            ExtBuffer5[],
            ExtBuffer6[];
//---- глобальные переменные индикатора                        
datetime    bar;                     
bool        s1=false,
            s2=false,
            s3=false,
            s4=false;
//+------------------------------------------------------------------+
//|         Инициализация пользовательского индикатора               |
//+------------------------------------------------------------------+
int init()
  {
//---- начало инциализации индикатора  
   bar=0;
   s1=false;
   s2=false;
   s3=false;
   s4=false;
//---- связываем массив с буфером индикатора  
   SetIndexBuffer(0,ExtBuffer0);
   SetIndexBuffer(1,ExtBuffer1);
   SetIndexBuffer(2,ExtBuffer2);
   SetIndexBuffer(3,ExtBuffer3);
   SetIndexBuffer(4,ExtBuffer4);
   SetIndexBuffer(5,ExtBuffer5);
   SetIndexBuffer(6,ExtBuffer6);
//---- Установим стиль отображения линий
   SetIndexStyle(0,DRAW_HISTOGRAM,CLR_NONE);
   SetIndexStyle(1,DRAW_HISTOGRAM);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexStyle(3,DRAW_ARROW,0,width);
   SetIndexStyle(4,DRAW_ARROW,0,width);
   SetIndexStyle(5,DRAW_ARROW,0,width);
   SetIndexStyle(6,DRAW_ARROW,0,width);
//----Назначим стрелки для линий индикатора
   SetIndexArrow(3,119);
   SetIndexArrow(4,119);
   SetIndexArrow(5,119);
   SetIndexArrow(6,119);
//---- установим точность индикатора  
   IndicatorDigits(Digits+1);
//---- учтановим начало отрисовки индикатора
   SetIndexDrawBegin(0,34);
   SetIndexDrawBegin(1,34);
   SetIndexDrawBegin(2,34);
//---- установим короткое имя индикатора и каждой линии в отдельности
   IndicatorShortName("iAO");
   SetIndexLabel(0,NULL);
   SetIndexLabel(1,NULL);
   SetIndexLabel(2,NULL);
   SetIndexLabel(3,"i-AO: блюдце");
   SetIndexLabel(4,"i-AO: пересечение нуля");
   SetIndexLabel(5,"i-AO: 2-ой мудрец");
   SetIndexLabel(6,"i-AO: два пика");
//---- Инициализация завершена
   return(0);
  }
//+------------------------------------------------------------------+
//| Деинициализация индикатора                                       |
//+------------------------------------------------------------------+
int deinit()
  {
   return(0);
  }    
//+------------------------------------------------------------------+
//| Awesome Oscillator                                               |
//+------------------------------------------------------------------+
int start()
  {
//---- Переменные, необходимые для расчета индикатора      
   int    limit,limit1,limit2;
   int    counted_bars=IndicatorCounted();
   double prev,current;
   double high,high_prev,low,low_prev;
   int    bullcross,bearcross;
   
//---- проверка на возможные ошибки
   if(counted_bars<0) return(-1);
//---- проверка наличия истории  
   if(iBars(Symbol(),Period())<35) 
    {
     Print("Недостаточно баров для расчета индикатора!");
     return(-1); 
    }    
//---- найдем количество баров для расчета индикатора
   limit = Bars - counted_bars-1;
   if(Bars - counted_bars > 2) limit = Bars-35;
   if(limit>BarsToProcess && BarsToProcess>0) limit=BarsToProcess;
   limit1=limit;
   limit2=limit1;
//---- расчитаем значения индикатора
   for(int i=limit; i>=0; i--)
      ExtBuffer0[i]=iAO(Symbol(),Period(),i);
//---- раскрасим гистогамму
   for(i=limit1; i>=0; i--)
     {
      if(ExtBuffer0[i]<ExtBuffer0[i+1])
        {
         ExtBuffer2[i]=ExtBuffer0[i];
         ExtBuffer1[i]=0.0;
        }
      else
        {
         ExtBuffer1[i]=ExtBuffer0[i];
         ExtBuffer2[i]=0.0;
        }
     }
//---- отобразим сигналы индикатора     
    for(i=limit2;i>=0;i--)
     {
      if(bull_dish(i)||bear_dish(i)) 
       {
        ExtBuffer3[i]=ExtBuffer0[i];
        if(i==1)s1=true;
       }
       
      if(bull_cross(i)||bear_cross(i))
       {
        ExtBuffer4[i]=ExtBuffer0[i];
        if(i==1)s2=true;
       }
       
      if(bull_second_wisdom(i)||bear_second_wisdom(i))
       {
        ExtBuffer5[i]=ExtBuffer0[i];
        if(i==1)s3=true;
       }
      
      high=GetPeak(i,MODE_UPPER,BarsToF2Peak);
      high_prev=GetPeak(GetPeak(i,MODE_UPPER,BarsToF2Peak),MODE_UPPER,BarsToF2Peak);
      low=GetPeak(i,MODE_LOWER,BarsToF2Peak);
      low_prev=GetPeak(GetPeak(i,MODE_LOWER,BarsToF2Peak),MODE_LOWER,BarsToF2Peak);
      bullcross=Get0CrossShift(i,MODE_UPPER,BarsToF2Peak);
      bearcross=Get0CrossShift(i,MODE_LOWER,BarsToF2Peak);
      
      if(high==i+1||low==i+1)
       {
        if(high_prev<bullcross && high_prev<bearcross && two_high_peaks(i,BarsToF2Peak))
         {
          ExtBuffer6[i]=ExtBuffer0[i];
          if(i==1)s4=true;
         }
        if(low_prev<bearcross && low_prev<bullcross && two_low_peaks(i,BarsToF2Peak))
         {
          ExtBuffer6[i]=ExtBuffer0[i];
          if(i==1)s4=true;
         }
       } 
     } 
//---- сигнал (алерт)           
  if(alert)
    {  
    if(s1 && bar<Time[0])
     {
      Alert("i-AO: Сигнал <блюдце> на ",Symbol(),"_",Period(),"");
     }
    if(s2 && bar<Time[0])
     {
      Alert("i-AO: Сигнал <пересечение нуля> на ",Symbol(),"_",Period(),"");
     }
    if(s3 && bar<Time[0])
     {
      Alert("i-AO: Сигнал <второй мудрец> на ",Symbol(),"_",Period(),"");
     } 
    if(s4 && bar<Time[0])
     {
      Alert("i-AO: Сигнал <два пика или основания> на ",Symbol(),"_",Period(),"");
     } 
        bar=Time[0]; 
        s1=false;
        s2=false;
        s3=false;
        s4=false;  
    }  
   return(0);
  }
//+------------------------------------------------------------------+

