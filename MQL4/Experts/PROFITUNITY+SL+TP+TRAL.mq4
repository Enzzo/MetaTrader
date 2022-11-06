//--------------------------------------------------------------------
// profitunity.mq4
// 
//--------------------------------------------------------------- 1 --
#property copyright "Copyright © Roman Shiredchenko, 29 июня, 2011"
#property link      "e-mail: rshiredchenko@mail.ru"
//--------------------------------------------------------------- 2 --
#include <stdlib.mqh>
#include <stderror.mqh>
#include <WinUser32.mqh>

//--------------------------------------------------------------- 3 --
#include <Variables.mqh>   // Описание переменных 
#include <Terminal.mqh>    // Учёт ордеров
#include <Events.mqh>      // Функция слежения за событиями, обновлен.
#include <Inform.mqh>      // Информационная функция
#include <Trade.mqh>       // Торговая функция
#include <Open_Ord.mqh>    // Открытие (установка) одного ордера заданного типа
#include <Open_Ord_balance_line.mqh> //Доливка по линии баланса -  установка одного отложенного ордера  
#include <Close_All.mqh>   // Закрытие  всех ордеров заданного типа (в данном варианте используется только при достижении предельной просадки)
#include <Tral_Stop.mqh>   // Модификация отложенных ордеров (см. в книжке определение понятия "специальный голубой свет") 
#include <Lot.mqh>         // Вычисление количества лотов
#include <Criterion.mqh>   // Торговые критерии
#include <Errors.mqh>      // Функция обработки ошибок.
#include <TrailingByFractals.mqh>          // Виды трала
#include <TrailingByPriceChannel.mqh>
#include <TrailingByShadows.mqh> 
#include <TrailingBy2ATR.mqh> 
#include <TrailingByMA.mqh>
#include <TrailingFiftyFifty.mqh>

double tick = 0;
//--------------------------------------------------------------- 4 --
int init()                             // Спец. функция init
  {
   tick++;
   Comment("Init()");
   IsExpertStopped = false;
   if (!IsTradeAllowed())
   {
      Comment("Необходимо разрешить советнику торговать");
      IsExpertStopped = true;
      return (0);
   }
      
   if (!IsTesting())
   {
      if (IsExpertEnabled())
      {
         Comment("Советник запустится следующим тиком ");
      }
      else 
      {
         Comment("Отжата кнопка \"Разрешить запуск советников\"");
      }
   }
   Level_old=MarketInfo(Symbol(),MODE_STOPLEVEL );//Миним. дистаниция 
   Level_Freeze = MarketInfo(Symbol(),MODE_FREEZELEVEL ); 
   Spread = MarketInfo(Symbol(),MODE_SPREAD);
   Tick = MarketInfo(Symbol(), MODE_TICKSIZE);    //Mинимальный тик   
   Terminal();                         // Функция учёта ордеров 
        
   //----------------------------------------------Мониторинг---------------------  
   if(Monitor==true)
    {
    int a,y;
    for(a=0,y=5;a<=3;a++)
      {
      string N=DoubleToStr(a,0);
  
      ObjectCreate(N,OBJ_LABEL,0,0,0,0,0);
      ObjectSet(N,OBJPROP_CORNER,3);
      ObjectSet(N,OBJPROP_XDISTANCE,5);
      ObjectSet(N,OBJPROP_YDISTANCE,y);
      y+=20;
      }  
    }
   
   return;                             // Выход из init() 
  }
//----------------------------------------------------------------------------
int start()                            // Спец. функция start
  {
  Comment("Start");
   //PlaySound("tick.wav");              // На каждом тике
 //-----------------------for price-open---------------------  
   if(Time[0] == prevtime)   return(0);  //ждем нового бара
   prevtime = Time[0];                   //если появился новый бар , включаемся
 //----------------------------------------------------------------------------
 if (IsExpertStopped)
   {
      Comment("Не удалось инициализировать советник!");
      return (0);
   }
   
   if (IsExpertFailed)
   {
      Comment("Критическая ошибка! Советник остановлен.");
      return (0);
   }
 //----------------------------------------------------------------------------
   int orderCount = 0; 
  int signal_period=GetPeriod(s_signal_period); // перебор таймфреймов   
   
  AO1 =  iAO(Symbol(), signal_period, 1);
  AO2 =  iAO(Symbol(), signal_period, 2);
   
  Teeth = iAlligator(Symbol(), signal_period, JawPeriod, JawShift, TeethPeriod, TeethShift, 
                           LipsPeriod, LipsShift, AlligatorMethod, AlligatorPrice, 
                           MODE_GATORTEETH, 1);// линия зубов - если текущая цена пробивает фрактал и находится выше ее,
                                               // то бай 
   fractal_h = iFractals(Symbol(),signal_period, MODE_UPPER, 3);
   if(fractal_h!=0) { upfractal=iFractals(Symbol(), signal_period, MODE_UPPER, 3); time_cur_up = TimeCurrent();} 
   fractal_l = iFractals(Symbol(), signal_period, MODE_LOWER, 3);
   if(fractal_l!=0)  { dwfractal=iFractals(Symbol(),signal_period, MODE_LOWER, 3); time_cur_dw = TimeCurrent();}   
   
   Terminal();                         // Функция учёта ордеров 
   Events();                           // Информация о событиях
   Trade(Criterion());                 // Торговая функция
   
   Inform(0);                          // Для перекрашивания объектов
   //---------------------------ТРАЛ ОРДЕРОВ---------------------------------------------------------------------------------------
   int orderType;
    for (orderIndex = (OrdersTotal() - 1); orderIndex >= 0; orderIndex--)
    {
      if (!OrderSelect(orderIndex, SELECT_BY_POS))
      {
         continue;
      }

      if ((OrderSymbol() != Symbol()) || (OrderMagicNumber() != Magic))
      {
         continue;
      }

      orderType = OrderType();
      if ((orderType != OP_BUY) && (orderType != OP_SELL))
      {
         continue;
      }
                ticket = OrderTicket( );                         // Номер ордера
       double   orderLots = OrderLots();                         // Lots   
       double   orderProfit = OrderProfit() + OrderSwap();       // Profit
       double   Price = OrderOpenPrice();                        // Цена открытия рыночного ордера
       double   SL =  OrderStopLoss();                           // Значение StopLoss ордера
       double   TP = OrderTakeProfit();                          // Значение TakeProfit ордера
          
             if (ticket>0)                                               // Если позиция открылась
                    {
                             while(OrderSelect(ticket,SELECT_BY_TICKET)==false)       // Если ордер выбран
                                 {
                                   Sleep(100);
                                 }
                                  double OpenPrice=OrderOpenPrice();
                    }
                 
         
      orderCount++;                     // считаем ордера (не больше 10)
     
      // Проверка на предельную просадку
      
      double loss = - ((orderProfit * 100.0) / AccountBalance());
      if (loss > MaxLoss)
      {
         Print ("MaxLoss");
         Close_All(0);                 // Закрыть и удалить все 
         Close_All(1);                 
         Close_All(4);                 
         Close_All(5);                 
         IsExpertFailed = true;
         return;
      }                
      
       while (!IsTradeAllowed() || !IsConnected()) Sleep(5000); RefreshRates();
       
      //----------------------------Тралим последовательно все наши ордера по виду трала------------------
      if (UseTrailing && orderCount > 0 && type ==0)   // простой трал по аналогии учебнику - в зависимости от параметра trlinloss (тралить ли в зоне лоссов)
          {     
           if (orderType == OP_BUY)  SampleTrailing_texbook (0);          // если бай
           if (orderType == OP_SELL) SampleTrailing_texbook (1);          // если селл
          }      
    
      if (UseTrailing && orderCount > 0 && type ==1) TrailingByFractals (ticket,signal_period, trlinloss);        //трал по фракталам + отступ
      if (UseTrailing && orderCount > 0 && type ==2) TrailingByShadows  (ticket,signal_period, trlinloss);        //трал по теням N свечей + отступ
      if (UseTrailing && orderCount > 0 && type ==3) TrailingBy2ATR     (ticket,signal_period, ATRPeriod_1, ATRPeriod_2, Mul, trlinloss); //трал по 2-м АТР
      if (UseTrailing && orderCount > 0 && type ==4) TrailingByPriceChannel (ticket, bars_n, indent);             // по ценовому каналу + отступ
      if (UseTrailing && orderCount > 0 && type ==5) TrailingByMA (ticket, signal_period, Period_MA_tral,indent); // по МА + отступ
      if (UseTrailing && orderCount > 0 && type ==6) TrailingFiftyFifty (ticket, signal_period, Mul_fifty, trlinloss);  //половинящий
      
       if (UseTrailing && orderCount > 0 && type == 7)                     // трал по аналогии учебнику - по SAR
          {     
           if (orderType == OP_BUY)  SARTrailing_texbook (0);          // если бай
           if (orderType == OP_SELL) SARTrailing_texbook (1);          // если селл
          }          
     Print( "Эксперт база: Всего наших ордеров = " ,orderCount);
     }   
//--------------------------------------------------------------------------------------------------------------------------------------     
   
   
   //==== БЛОК МОНИТОРИНГА===========================================
  if(Monitor==true)
    {
    string str="Balance: "+DoubleToStr(AccountBalance(),2)+" $";
    ObjectSetText("0",str,10,"Arial Black",DarkOrange);
    
    str="Profit: "+DoubleToStr(AccountProfit(),2)+" $";
    ObjectSetText("1",str,10,"Arial Black",Salmon);
    
    str="Free Margine: "+DoubleToStr(AccountFreeMargin(),2)+" $";
    ObjectSetText("2",str,10,"Arial Black",Gold);
    
    str="OrdersTotal: "+DoubleToStr(OrdersTotal(),0);
    ObjectSetText("3",str,10,"Arial Black",MediumAquamarine);
    }
//----------------------------------------------------------------  
   return;                             // Выход из start()
  }
//--------------------------------------------------------------- 6 --
int deinit()                           // Спец. функция deinit()
  {
   Inform(-1);                         // Для удаления объектов
   //----
  if(Monitor==true)
    {
    for(int a=0;a<=3;a++)
      {
      string N=DoubleToStr(a,0);
      ObjectDelete(N);
      } 
    }
//----
   return;                             // Выход из deinit()
  }
//--------------------------------------------------------------- 7 --

