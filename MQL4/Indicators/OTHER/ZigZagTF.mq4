//+------------------------------------------------------------------+
//|                                                     ZigZagTF.mq4 |
//|                                         Copyright © 2009, Kharko |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, Kharko"
#property link      ""

#property indicator_chart_window
#property indicator_buffers 4
#property indicator_color1 Blue
#property indicator_color2 Blue
#property indicator_color3 Aqua
#property indicator_color4 Aqua
#property indicator_width1 1
#property indicator_width2 1

//---- indicator parameters
extern int 
         ExtDepth =2,      // временной промежуток
         CheckBar =0,      // количество бар для подтверждения экстремума
         TimeFrame=0,      // младший ТФ, с которого берутся данные для построения линии ЗЗ
         Price=0;          // используемая цена. 0 - Low/High, 1 - Open, 2 - Low, 3 - High, 4 - Close
extern color
         ZZcolor  = Blue;// Цвет линии 
extern int 
         ZZwidth  =2;      // Толщина линии
extern bool 
         Info     =true,  // Уровни появления/обновления луча 
         Levels   =false,  // Уровни появления/обновления луча 
         Record   =false;  // Включить/выключить запись разворотных точек в файл
extern color
         Lcolor   = Blue,  // Цвет нижнего уровня
         Hcolor   = Blue;  // Цвет верхнего уровня
extern bool 
         TimeLevel =true,  // Включить/выключить временные диапазоны
         PriceLevel=true,  // Включить/выключить ценовые диапазоны
         Fibo1     =false, // Включение/выключение Уровней Коррекции Фибоначчи от текущего луча 
         Fibo2     =false, // Включение/выключение Уровней Коррекции Фибоначчи от предпоследнего луча 
         Fibo3     =false, // Включение/выключение Уровней Коррекции Фибоначчи.
                           // Для построения уровней взят диапазон от луча, сонаправленного с текущим лучом
         Fibo4     =false; // Включение/выключение Уровней Коррекции Фибоначчи.
                           // Для построения уровней взят диапазон от луча, сонаправленного с обратным лучом
extern color
         FiboColor1= Blue,  // Цвет Фибо-уровней на последнем луче 
         FiboColor2= Maroon,// Цвет Фибо-уровней на предпоследнем луче 
         TimeLevel1= Blue,  // Цвет VL. Временной диапазон, сонаправленного с текущим, луча
         TimeLevel2= Maroon,// Цвет VL. Временной диапазон последнего обратного луча
         PriceLevel1= Blue, // Цвет НL. Ценовой диапазон, сонаправленного с текущим, луча
         PriceLevel2= Maroon;// Цвет НL. Ценовой диапазон последнего обратного луча

//---- indicator buffers
bool
         Count=true;
bool
         UpDown;
double   
         lasthigh,
         lastlow,
         LowLevel[],
         HighLevel[],
         LowBuffer[],
         HighBuffer[];
double 
         lBar_0,
         hBar_0;
datetime 
         timehigh,
         timelow,
         time_high[1],
         time_low[1];
int
         count_high=1,
         count_low=1;
datetime 
         tiBar_0;
string
         text;
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
   if(TimeFrame>Period() || TimeFrame==0)
      TimeFrame=Period();
   if(TimeFrame!=1 && TimeFrame!=5 && TimeFrame!=15 && TimeFrame!=30 && TimeFrame!=60 && TimeFrame!=240 && TimeFrame!=1440 && TimeFrame!=10080 && TimeFrame!=43200)
      TimeFrame=Period();

   text="Copyright © 2009, Kharko";
   Comment(text);

//---- drawing settings
   SetIndexBuffer(0,LowBuffer);
   SetIndexBuffer(1,HighBuffer);
   SetIndexStyle(0,DRAW_ZIGZAG,STYLE_SOLID,ZZwidth,ZZcolor);
   SetIndexStyle(1,DRAW_ZIGZAG,STYLE_SOLID,ZZwidth,ZZcolor);
   SetIndexBuffer(2,LowLevel);
   SetIndexBuffer(3,HighLevel);
   if(Levels)
   {
      SetIndexStyle(2,DRAW_SECTION,STYLE_DOT,EMPTY,Lcolor);
      SetIndexStyle(3,DRAW_SECTION,STYLE_DOT,EMPTY,Hcolor);
   }
   else
   {
      SetIndexStyle(2,DRAW_NONE);
      SetIndexStyle(3,DRAW_NONE);
   }
//---- indicator buffers mapping
   SetIndexEmptyValue(0,0.0);
   SetIndexEmptyValue(1,0.0);
   SetIndexEmptyValue(2,0.0);
   SetIndexEmptyValue(3,0.0);
   SetIndexLabel(0,"ZigZag_Low" );
   SetIndexLabel(1,"ZigZag_High" );
   SetIndexLabel(2,"Level_Low" );
   SetIndexLabel(3,"Level_High" );
//---- indicator short name
   IndicatorShortName("ZigZag("+ExtDepth+")");

   if(TimeLevel)
   {
      ObjectCreate("TimeLevel1 "+ExtDepth,OBJ_VLINE,0,0,0);
      ObjectSet("TimeLevel1 "+ExtDepth,OBJPROP_COLOR,TimeLevel1);
      ObjectCreate("TimeLevel2 "+ExtDepth,OBJ_VLINE,0,0,0);
      ObjectSet("TimeLevel2 "+ExtDepth,OBJPROP_COLOR,TimeLevel2);
   }
   if(PriceLevel)
   {
      ObjectCreate("PriceLevel1 "+ExtDepth,OBJ_HLINE,0,0,0);
      ObjectSet("PriceLevel1 "+ExtDepth,OBJPROP_COLOR,PriceLevel1);
      ObjectCreate("PriceLevel2 "+ExtDepth,OBJ_HLINE,0,0,0);
      ObjectSet("PriceLevel2 "+ExtDepth,OBJPROP_COLOR,PriceLevel2);
   }
   if(Fibo1 || Fibo4)
   {
      ObjectCreate("Fibo1 "+ExtDepth,OBJ_FIBO,0,0,0,0,0);
      ObjectSet("Fibo1 "+ExtDepth,OBJPROP_LEVELSTYLE,STYLE_DOT);
      ObjectSet("Fibo1 "+ExtDepth,OBJPROP_LEVELCOLOR,FiboColor1);
      ObjectSet("Fibo1 "+ExtDepth,OBJPROP_FIBOLEVELS,20);
   }
   if(Fibo2 || Fibo3)
   {
      ObjectCreate("Fibo2 "+ExtDepth,OBJ_FIBO,0,0,0,0,0);
      ObjectSet("Fibo2 "+ExtDepth,OBJPROP_LEVELSTYLE,STYLE_DOT);
      ObjectSet("Fibo2 "+ExtDepth,OBJPROP_LEVELCOLOR,FiboColor2);
      ObjectSet("Fibo2 "+ExtDepth,OBJPROP_FIBOLEVELS,20);
   }
//---- initialization done
   return(0);
  }
//+------------------------------------------------------------------+
int deinit() 
{
   Comment("");
   ObjectDelete("TimeLevel1 "+ExtDepth);
   ObjectDelete("TimeLevel2 "+ExtDepth);
   ObjectDelete("PriceLevel1 "+ExtDepth);
   ObjectDelete("PriceLevel2 "+ExtDepth);
   ObjectDelete("Fibo1 "+ExtDepth);
   ObjectDelete("Fibo2 "+ExtDepth);
   return(0);
}
//+------------------------------------------------------------------+
int start()
  {
   int    
      counted_bars=IndicatorCounted(),
      TS_L,
      TS_H,
      shift,
      pos,
      lastpos,
      limit,
      curhighpos,
      curlowpos;
   double   
      curhigh,
      curlow;

//   if(!IsConnected())return(1);

//   if(MarketInfo(Symbol(),MODE_TRADEALLOWED) != 1)return(1);

// Проверка на обновление экстремумов на текущем баре
   if (lBar_0<=Low[0] && hBar_0>=High[0] && tiBar_0==Time[0]) 
      return(0);
   else
   {
      lBar_0=Low[0]; 
      hBar_0=High[0]; 
      tiBar_0=Time[0];
   }

// Используемая цена для построения ЗЗ
   switch(Price)
     {
      case 1 : TS_L=0;  TS_H=0;  break;
      case 2 : TS_L=1;  TS_H=1;  break;
      case 3 : TS_L=2;  TS_H=2;  break;
      case 4 : TS_L=3;  TS_H=3;  break;
      default :
         Price=0;
         TS_L=1;  TS_H=2;
     }
   
// Построение уровней появления/обновления луча
   limit=Bars-counted_bars+1;
   if(Levels)
   {
      for(shift=limit; shift>=0; shift--)
      {
         if(ExtDepth==0)
            break;
         if(Price==0)
         {
            LowLevel[shift]=iLow(NULL,0,iLowest(NULL,0,TS_L,ExtDepth,shift+1))-Point;
            HighLevel[shift]=iHigh(NULL,0,iHighest(NULL,0,TS_H,ExtDepth,shift+1))+Point;
         }
         else
         {
            LowLevel[shift]=Price_(0,iLowest(NULL,0,TS_L,ExtDepth,shift+1))-Point;
            HighLevel[shift]=Price_(0,iHighest(NULL,0,TS_H,ExtDepth,shift+1))+Point;
         }
      }
   }

   
// Построение линии ЗЗ. Расчет начинаем с последнего известного бара
   limit=iBars(NULL,TimeFrame)-ExtDepth*Period()/TimeFrame-1;
   if(UpDown && timelow!=0)
      limit=iBarShift(NULL,TimeFrame,timelow);
   if(!UpDown && timehigh!=0)
      limit=iBarShift(NULL,TimeFrame,timehigh);

   for(shift=limit; shift>=0; shift--)
   {
      RefreshRates();
// Определяем положение и величину текущих экстремумов
      curlowpos=iLowest(NULL,TimeFrame,TS_L,(ExtDepth+CheckBar)*Period()/TimeFrame+1,shift);
      curhighpos=iHighest(NULL,TimeFrame,TS_H,(ExtDepth+CheckBar)*Period()/TimeFrame+1,shift);
      if(Price==0)
      {
         curlow=iLow(NULL,TimeFrame,curlowpos);
         curhigh=iHigh(NULL,TimeFrame,curhighpos);
      }
      else
      {
         curlow=Price_(TimeFrame,curlowpos);
         curhigh=Price_(TimeFrame,curhighpos);
      }
      
      if(CheckBar!=0 && iVolume(NULL,TimeFrame,shift-1)==0)          // если не все бары сформированы для подтверждения, то прерываем цикл
         break;
      
// Если положение и величина первых экстремумов неизвесны
      if(timelow==0 && timehigh==0)
      {
         if(curlowpos==shift+CheckBar*Period()/TimeFrame && curhighpos==shift+CheckBar*Period()/TimeFrame)
            continue;                                                // Экстремумы должны находится на разных барах
         pos=iBarShift(NULL,0,iTime(NULL,TimeFrame,curlowpos),false);// Cмещение бара на текущем графике для Low
         LowBuffer[pos]=curlow;                                      // новое значение Low
         timelow=iTime(NULL,TimeFrame,curlowpos);                    // время появления Low на младшем ТФ
         lastlow=curlow;                                             

         pos=iBarShift(NULL,0,iTime(NULL,TimeFrame,curhighpos),false);// Cмещение бара на текущем графике для High
         HighBuffer[pos]=curhigh;                                     // новое значение High
         timehigh=iTime(NULL,TimeFrame,curhighpos);                   // время появления High на младшем ТФ
         lasthigh=curhigh;

// Направление луча
         if(timelow<timehigh)
            UpDown=true;
         else
            UpDown=false;

         continue;
      }

// Последний луч направлен вверх
      if(UpDown) 
      {
// На текущем баре есть обновление верхнего луча
         if(curhighpos==shift+CheckBar*Period()/TimeFrame && lasthigh<curhigh)
         {
            pos=iBarShift(NULL,0,iTime(NULL,TimeFrame,curhighpos),false);// Cмещение бара на текущем графике для High
            HighBuffer[pos]=curhigh;                                     // новое значение High
            lastpos=iBarShift(NULL,0,timehigh,false);                    // последнее положение High
            if(lastpos!=pos)                                             // сравниваем последнее и текущее положение High
               HighBuffer[lastpos]=0.0;                                  // если не равны, то обнуляем старое значение
            timehigh=iTime(NULL,TimeFrame,curhighpos);                   // время появления High на младшем ТФ
            time_high[count_high-1]=timehigh;
            lasthigh=HighBuffer[pos];                                    // запоминаем новое положение High
            UpDown=true;                                                 // направление луча вверх
         }
// На текущем баре есть появление нижнего луча
         if(curlowpos==shift+CheckBar*Period()/TimeFrame)
         {
            pos=iBarShift(NULL,0,iTime(NULL,TimeFrame,curlowpos),false); // Cмещение бара на текущем графике для Low
            LowBuffer[pos]=curlow;                                       // новое значение Low
            timelow=iTime(NULL,TimeFrame,curlowpos);                     // время появления Low на младшем ТФ
            lastlow=LowBuffer[pos];                                      // запоминаем новое положение Low
            UpDown=false;                                                // направление луча вниз
         }
      }
// Последний луч направлен вниз
      else
      {
// На текущем баре есть обновление нижнего луча
         if(curlowpos==shift+CheckBar*Period()/TimeFrame && lastlow>curlow)
         {
            pos=iBarShift(NULL,0,iTime(NULL,TimeFrame,curlowpos),false); // Cмещение бара на текущем графике для Low
            LowBuffer[pos]=curlow;                                       // новое значение Low
            lastpos=iBarShift(NULL,0,timelow,false);                     // последнее положение Low
            if(lastpos!=pos)                                             // сравниваем последнее и текущее положение Low
               LowBuffer[lastpos]=0.0;                                   // если не равны, то обнуляем старое значение
            timelow=iTime(NULL,TimeFrame,curlowpos);                     // время появления Low на младшем ТФ
            lastlow=LowBuffer[pos];                                      // запоминаем новое положение Low
            UpDown=false;                                                // направление луча вниз
         }
// На текущем баре есть появление верхнего луча
         if(curhighpos==shift+CheckBar*Period()/TimeFrame)
         {
            pos=iBarShift(NULL,0,iTime(NULL,TimeFrame,curhighpos),false);// Cмещение бара на текущем графике для High
            HighBuffer[pos]=curhigh;                                     // новое значение High
            timehigh=iTime(NULL,TimeFrame,curhighpos);                   // время появления High на младшем ТФ
            lasthigh=HighBuffer[pos];                                    // запоминаем новое положение High
            UpDown=true;                                                 // направление луча вверх
         }
      }
   }
   
// Включение/выключение Фибо-уровней
   if(Info || TimeLevel || PriceLevel || Fibo1 || Fibo2 || Fibo3)
      Fibo_();

// Включить/выключить запись разворотных точек в файл
   if(Record && Count)
   {
      Records();
   }
      
return(0);
}
//+------------------------------------------------------------------+
double Price_(int TF,int pos) 
{
   switch(Price)
     {
      case 1 : return(iOpen(NULL,TF,pos));  break;
      case 2 : return(iLow(NULL,TF,pos));  break;
      case 3 : return(iHigh(NULL,TF,pos));  break;
      case 4 : return(iClose(NULL,TF,pos));  break;
     }
   return 0.0;
}
//+------------------------------------------------------------------+
int Records() 
{
// запись разворотных точек в файл
   int
         handle;
   string
         FileName,
         Pr,
         TF;

// Формируем имя файла
   switch(Price)
     {
      case 0  : Pr="HL"; break;
      case 1  : Pr="Op"; break;
      case 2  : Pr="L";  break;
      case 3  : Pr="H";  break;
      case 4  : Pr="Cl"; break;
     }
   switch(Period())
     {
      case 1    : TF=" M1 ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
      case 5    : TF=" M5 ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
      case 15   : TF=" M15 ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
      case 30   : TF=" M30 ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
      case 60   : TF=" H1 ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
      case 240  : TF=" H4 ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
      case 1440 : TF=" D1 ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
      case 10080: TF=" W1 ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
      case 43200: TF=" Mn ("+ExtDepth+" "+CheckBar+" "+TimeFrame+" "+Pr+")"; break;
     }

   FileName="ZZ "+Symbol()+TF+".csv";
   handle=FileOpen(FileName,FILE_CSV|FILE_WRITE,';');
   
   if(handle<1)
   {
      Print("File "+FileName+" can\'t open ",GetLastError());// Упс... неудача... повторим попытку на следующем тике
      return(0);
   }   
   
// поиск разворотных точек
   int Trend=0;
   for(int shift=Bars; shift>=0; shift--)
   {
      if(HighBuffer[shift]>0 && (Trend==0 || Trend==1))
      {
         FileWrite(handle,shift,"Up",TimeToStr(Time[shift],TIME_DATE|TIME_MINUTES),HighBuffer[shift]);
         Trend=2;
         if(LowBuffer[shift]>0)
         {
            FileWrite(handle,shift,"Down",TimeToStr(Time[shift],TIME_DATE|TIME_MINUTES),LowBuffer[shift]);
            Trend=1;
         }
         continue;
      }
      if(LowBuffer[shift]>0 && (Trend==0 || Trend==2))
      {
         FileWrite(handle,shift,"Down",TimeToStr(Time[shift],TIME_DATE|TIME_MINUTES),LowBuffer[shift]);
         Trend=1;
         if(HighBuffer[shift]>0)
         {
            FileWrite(handle,shift,"Up",TimeToStr(Time[shift],TIME_DATE|TIME_MINUTES),HighBuffer[shift]);
            Trend=2;
         }
      }
   }
   FileClose(handle);
//---
   Count=false; // Запись прошла успешно
   return(0);
}
//+------------------------------------------------------------------+
int Fibo_() 
{
// Находим 4 последних экстремума
int index;
double
      p1,
      p2,
      p3,
      p4;
datetime
      t1,
      t2,
      t3,
      t4;
//---
   for(int i=0;i<Bars;i++)
   {
// 2 последние вершины
      if(HighBuffer[i]!=0)
      {
         if(t4!=0)
         {
            t2=iTime(NULL,TimeFrame,i);
            p2=iHigh(NULL,TimeFrame,i);
         }
         else
         {
            t4=iTime(NULL,TimeFrame,i);
            p4=iHigh(NULL,TimeFrame,i);
         }
      }
// 2 последних основания
      if(LowBuffer[i]!=0)
      {
         if(t3!=0)
         {
            t1=iTime(NULL,TimeFrame,i);
            p1=iLow(NULL,TimeFrame,i);
         }
         else
         {
            t3=iTime(NULL,TimeFrame,i);
            p3=iLow(NULL,TimeFrame,i);
         }
      }
      if(t1!=0 && t2!=0 && t3!=0 && t4!=0)
         break;
   }
//---
   if(Info)
   {
      int index1;
      double pr1,pr2;
      text="Copyright © 2009, Kharko\n";
      if(UpDown) 
      {
         index=iBarShift(NULL,TimeFrame,t1)-iBarShift(NULL,TimeFrame,t2);
         index1=iBarShift(NULL,TimeFrame,t2)-iBarShift(NULL,TimeFrame,t3);
         pr1=(p2-p1)/Point;
         pr2=(p2-p3)/Point;
         if(pr2>=pr1 && index1>=index)
            text=StringConcatenate(text,"\nCurrent : 1 model");
         if(pr2<pr1 && index1>=index)
            text=StringConcatenate(text,"\nCurrent : 2 model");
         if(pr2>=pr1 && index1<index)
            text=StringConcatenate(text,"\nCurrent : 3 model");
         if(pr2<pr1 && index1<index)
            text=StringConcatenate(text,"\nCurrent : 4 model");

         index=iBarShift(NULL,TimeFrame,t2)-iBarShift(NULL,TimeFrame,t3);
         index1=iBarShift(NULL,TimeFrame,t3)-iBarShift(NULL,TimeFrame,t4);
         pr1=(p2-p3)/Point;
         pr2=(p4-p3)/Point;
         if(pr2>=pr1 && index1>=index)
            text=StringConcatenate(text,"\nNext :     1 model");
         if(pr2<pr1 && index1>=index)
            text=StringConcatenate(text,"\nNext :     2 model");
         if(pr2>=pr1 && index1<index)
            text=StringConcatenate(text,"\nNext :     3 model");
         if(pr2<pr1 && index1<index)
            text=StringConcatenate(text,"\nNext :     4 model");
      }
      else
      {
         index=iBarShift(NULL,TimeFrame,t2)-iBarShift(NULL,TimeFrame,t1);
         index1=iBarShift(NULL,TimeFrame,t1)-iBarShift(NULL,TimeFrame,t4);
         pr1=(p2-p1)/Point;
         pr2=(p4-p1)/Point;
         if(pr2>=pr1 && index1>=index)
            text=StringConcatenate(text,"\nCurrent : 1 model");
         if(pr2<pr1 && index1>=index)
            text=StringConcatenate(text,"\nCurrent : 2 model");
         if(pr2>=pr1 && index1<index)
            text=StringConcatenate(text,"\nCurrent : 3 model");
         if(pr2<pr1 && index1<index)
            text=StringConcatenate(text,"\nCurrent : 4 model");

         index=iBarShift(NULL,TimeFrame,t1)-iBarShift(NULL,TimeFrame,t4);
         index1=iBarShift(NULL,TimeFrame,t4)-iBarShift(NULL,TimeFrame,t3);
         pr1=(p4-p1)/Point;
         pr2=(p4-p3)/Point;
         if(pr2>=pr1 && index1>=index)
            text=StringConcatenate(text,"\nNext :     1 model");
         if(pr2<pr1 && index1>=index)
            text=StringConcatenate(text,"\nNext :     2 model");
         if(pr2>=pr1 && index1<index)
            text=StringConcatenate(text,"\nNext :     3 model");
         if(pr2<pr1 && index1<index)
            text=StringConcatenate(text,"\nNext :     4 model");
      }
      Comment(text);
   }
//---
   if(TimeLevel)
   {
      if(UpDown) 
      {
         index=iBarShift(NULL,TimeFrame,t3)-iBarShift(NULL,TimeFrame,t1)+iBarShift(NULL,TimeFrame,t2);
         if(index>=0)
            ObjectSet("TimeLevel1 "+ExtDepth,OBJPROP_TIME1,iTime(NULL,TimeFrame,index));
         else
            ObjectSet("TimeLevel1 "+ExtDepth,OBJPROP_TIME1,iTime(NULL,TimeFrame,0)-60*TimeFrame*index);
         
         index=2*iBarShift(NULL,TimeFrame,t3)-iBarShift(NULL,TimeFrame,t2);
         if(index>=0)
            ObjectSet("TimeLevel2 "+ExtDepth,OBJPROP_TIME1,iTime(NULL,TimeFrame,index));
         else
            ObjectSet("TimeLevel2 "+ExtDepth,OBJPROP_TIME1,iTime(NULL,TimeFrame,0)-60*TimeFrame*index);
      }
      else
      {
         index=iBarShift(NULL,TimeFrame,t4)-iBarShift(NULL,TimeFrame,t2)+iBarShift(NULL,TimeFrame,t1);
         if(index>=0)
            ObjectSet("TimeLevel1 "+ExtDepth,OBJPROP_TIME1,iTime(NULL,TimeFrame,index));
         else
            ObjectSet("TimeLevel1 "+ExtDepth,OBJPROP_TIME1,iTime(NULL,TimeFrame,0)-60*TimeFrame*index);
         
         index=2*iBarShift(NULL,TimeFrame,t4)-iBarShift(NULL,TimeFrame,t1);
         if(index>=0)
            ObjectSet("TimeLevel2 "+ExtDepth,OBJPROP_TIME1,iTime(NULL,TimeFrame,index));
         else
            ObjectSet("TimeLevel2 "+ExtDepth,OBJPROP_TIME1,iTime(NULL,TimeFrame,0)-60*TimeFrame*index);
      }
   }
//---
   if(PriceLevel)
   {
      if(UpDown) 
      {
         ObjectSet("PriceLevel1 "+ExtDepth,OBJPROP_PRICE1,p3+p2-p1);
         ObjectSet("PriceLevel2 "+ExtDepth,OBJPROP_PRICE1,p2);
      }
      else
      {
         ObjectSet("PriceLevel1 "+ExtDepth,OBJPROP_PRICE1,p4-p2+p1);
         ObjectSet("PriceLevel2 "+ExtDepth,OBJPROP_PRICE1,p1);
      }
   }
// Подключение Фибо-уровней на последнем луче
   if(Fibo1)
   {
      if(UpDown) 
      {
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_TIME1,t4-Period()*60*2);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_PRICE1,p3);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_TIME2,t4);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_PRICE2,p4);
         fibo_patterns("Fibo1 "+ExtDepth,p4, p3,"                    ");
      }
      else
      {
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_TIME1,t3);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_PRICE1,p4);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_TIME2,t3-Period()*60*2);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_PRICE2,p3);
         fibo_patterns("Fibo1 "+ExtDepth,p3, p4,"                    ");
      }
   }

// Подключение Фибо-уровней на предпоследнем луче
   if(Fibo2)
   {
      if(UpDown) 
      {
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_TIME1,t3-Period()*60*2);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_PRICE1,p2);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_TIME2,t3);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_PRICE2,p3);
         fibo_patterns("Fibo2 "+ExtDepth,p2, p3,"");
      }
      else
      {
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_TIME1,t4);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_PRICE1,p1);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_TIME2,t4-Period()*60*2);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_PRICE2,p4);
         fibo_patterns("Fibo2 "+ExtDepth,p4, p1,"");
      }
   }
// Подключение Фибо-уровней. Для построения уровней взят диапазон от луча, сонаправленного с текущим лучом
   if(Fibo3)
   {
      if(UpDown) 
      {
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_TIME1,t3-Period()*60*2);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_PRICE1,p3+p2-p1);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_TIME2,t3);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_PRICE2,p3);
         fibo_patterns("Fibo2 "+ExtDepth,p3, p3+p2-p1,"");
      }
      else
      {
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_TIME1,t4);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_PRICE1,p4-p2+p1);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_TIME2,t4-Period()*60*2);
         ObjectSet("Fibo2 "+ExtDepth,OBJPROP_PRICE2,p4);
         fibo_patterns("Fibo2 "+ExtDepth,p4, p4-p2+p1,"");
      }
   }
// Подключение Фибо-уровней.Для построения уровней взят диапазон от луча, сонаправленного с обратным лучом
   if(Fibo4)
   {
      if(UpDown) 
      {
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_TIME1,t4-Period()*60*2);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_PRICE1,p4-p2+p3);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_TIME2,t4);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_PRICE2,p4);
         fibo_patterns("Fibo1 "+ExtDepth,p4, p4-p2+p3,"                    ");
      }
      else
      {
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_TIME1,t3);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_PRICE1,p3+p4-p1);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_TIME2,t3-Period()*60*2);
         ObjectSet("Fibo1 "+ExtDepth,OBJPROP_PRICE2,p3);
         fibo_patterns("Fibo1 "+ExtDepth,p3, p3+p4-p1,"                    ");
      }
   }

//---
   return(0);
}
//--------------------------------------------------------
void fibo_patterns(string nameObj,double fiboPrice,double fiboPrice1,string str)
  {

// Функция построения Фибо уровней

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL,0);
   ObjectSetFiboDescription(nameObj, 0, "0.0 "+DoubleToStr(fiboPrice, Digits)+str); 
  
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+1,0.14);
   ObjectSetFiboDescription(nameObj, 1, "14.0 "+DoubleToStr(fiboPrice1*0.14+fiboPrice*(1-0.14), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+2,0.236);
   ObjectSetFiboDescription(nameObj, 2, "23.6 "+DoubleToStr(fiboPrice1*0.236+fiboPrice*(1-0.236), Digits)+str); 
 
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+3,0.382);
   ObjectSetFiboDescription(nameObj, 3, "38.2 "+DoubleToStr(fiboPrice1*0.382+fiboPrice*(1-0.382), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+4,0.5);
   ObjectSetFiboDescription(nameObj, 4, "50.0 "+DoubleToStr(fiboPrice1*0.5+fiboPrice*(1-0.5), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+5,0.618);
   ObjectSetFiboDescription(nameObj, 5, "61.8 "+DoubleToStr(fiboPrice1*0.618+fiboPrice*(1-0.618), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+6,0.76);
   ObjectSetFiboDescription(nameObj, 6, "76.0 "+DoubleToStr(fiboPrice1*0.76+fiboPrice*(1-0.76), Digits)+str);
   
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+7,1.00);
   ObjectSetFiboDescription(nameObj, 7, "100.0 "+DoubleToStr(fiboPrice1, Digits)+str);     
  
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+8,1.236);
   ObjectSetFiboDescription(nameObj, 8, "123.6 "+DoubleToStr(fiboPrice1*1.236+fiboPrice*(1-1.236), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+9,1.382);
   ObjectSetFiboDescription(nameObj, 9, "138.2 "+DoubleToStr(fiboPrice1*1.382+fiboPrice*(1-1.382), Digits)+str); 
  
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+10,1.5);
   ObjectSetFiboDescription(nameObj, 10, "150.0 "+DoubleToStr(fiboPrice1*1.5+fiboPrice*(1-1.5), Digits)+str); 
  
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+11,1.618);
   ObjectSetFiboDescription(nameObj, 11, "161.8 "+DoubleToStr(fiboPrice1*1.618+fiboPrice*(1-1.618), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+12,1.76);
   ObjectSetFiboDescription(nameObj, 12, "176.0 "+DoubleToStr(fiboPrice1*1.76+fiboPrice*(1-1.76), Digits)+str); 
/*
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+13,2.25);
   ObjectSetFiboDescription(nameObj, 13, "225.0 "+DoubleToStr(fiboPrice1*2.25+fiboPrice*(1-2.25), Digits)+str); 
  
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+14,2.333);
   ObjectSetFiboDescription(nameObj, 14, "233.3 "+DoubleToStr(fiboPrice1*2.333+fiboPrice*(1-2.333), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+15,2.5);
   ObjectSetFiboDescription(nameObj, 15, "250.0 "+DoubleToStr(fiboPrice1*2.5+fiboPrice*(1-2.5), Digits)+str); 
  
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+16,2.666);
   ObjectSetFiboDescription(nameObj, 16, "266.6 "+DoubleToStr(fiboPrice1*2.666+fiboPrice*(1-2.666), Digits)+str); 
  
   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+17,2.75);
   ObjectSetFiboDescription(nameObj, 17, "275.0 "+DoubleToStr(fiboPrice1*2.75+fiboPrice*(1-2.75), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+18,3.0);
   ObjectSetFiboDescription(nameObj, 18, "300.0 "+DoubleToStr(fiboPrice1*3.0+fiboPrice*(1-3.0), Digits)+str); 

   ObjectSet(nameObj,OBJPROP_FIRSTLEVEL+19,4.0);
   ObjectSetFiboDescription(nameObj, 19, "400.0 "+DoubleToStr(fiboPrice1*4.0+fiboPrice*(1-4.0), Digits)+str);*/
//----
   //return(0);
  }
//--------------------------------------------------------
/*
0.0
14
23.6
38.2
50.0
61.8
76
100
*/