//--------------------------------------------------------------------
// profitunity.mq4
// 
//--------------------------------------------------------------- 1 --
#property copyright "Copyright � Roman Shiredchenko, 29 ����, 2011"
#property link      "e-mail: rshiredchenko@mail.ru"
//--------------------------------------------------------------- 2 --
#include <stdlib.mqh>
#include <stderror.mqh>
#include <WinUser32.mqh>

//--------------------------------------------------------------- 3 --
#include <Variables.mqh>   // �������� ���������� 
#include <Terminal.mqh>    // ���� �������
#include <Events.mqh>      // ������� �������� �� ���������, ��������.
#include <Inform.mqh>      // �������������� �������
#include <Trade.mqh>       // �������� �������
#include <Open_Ord.mqh>    // �������� (���������) ������ ������ ��������� ����
#include <Open_Ord_balance_line.mqh> //������� �� ����� ������� -  ��������� ������ ����������� ������  
#include <Close_All.mqh>   // ��������  ���� ������� ��������� ���� (� ������ �������� ������������ ������ ��� ���������� ���������� ��������)
#include <Tral_Stop.mqh>   // ����������� ���������� ������� (��. � ������ ����������� ������� "����������� ������� ����") 
#include <Lot.mqh>         // ���������� ���������� �����
#include <Criterion.mqh>   // �������� ��������
#include <Errors.mqh>      // ������� ��������� ������.
#include <TrailingByFractals.mqh>          // ���� �����
#include <TrailingByPriceChannel.mqh>
#include <TrailingByShadows.mqh> 
#include <TrailingBy2ATR.mqh> 
#include <TrailingByMA.mqh>
#include <TrailingFiftyFifty.mqh>

double tick = 0;
//--------------------------------------------------------------- 4 --
int init()                             // ����. ������� init
  {
   tick++;
   Comment("Init()");
   IsExpertStopped = false;
   if (!IsTradeAllowed())
   {
      Comment("���������� ��������� ��������� ���������");
      IsExpertStopped = true;
      return (0);
   }
      
   if (!IsTesting())
   {
      if (IsExpertEnabled())
      {
         Comment("�������� ���������� ��������� ����� ");
      }
      else 
      {
         Comment("������ ������ \"��������� ������ ����������\"");
      }
   }
   Level_old=MarketInfo(Symbol(),MODE_STOPLEVEL );//�����. ���������� 
   Level_Freeze = MarketInfo(Symbol(),MODE_FREEZELEVEL ); 
   Spread = MarketInfo(Symbol(),MODE_SPREAD);
   Tick = MarketInfo(Symbol(), MODE_TICKSIZE);    //M���������� ���   
   Terminal();                         // ������� ����� ������� 
        
   //----------------------------------------------����������---------------------  
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
   
   return;                             // ����� �� init() 
  }
//----------------------------------------------------------------------------
int start()                            // ����. ������� start
  {
  Comment("Start");
   //PlaySound("tick.wav");              // �� ������ ����
 //-----------------------for price-open---------------------  
   if(Time[0] == prevtime)   return(0);  //���� ������ ����
   prevtime = Time[0];                   //���� �������� ����� ��� , ����������
 //----------------------------------------------------------------------------
 if (IsExpertStopped)
   {
      Comment("�� ������� ���������������� ��������!");
      return (0);
   }
   
   if (IsExpertFailed)
   {
      Comment("����������� ������! �������� ����������.");
      return (0);
   }
 //----------------------------------------------------------------------------
   int orderCount = 0; 
  int signal_period=GetPeriod(s_signal_period); // ������� �����������   
   
  AO1 =  iAO(Symbol(), signal_period, 1);
  AO2 =  iAO(Symbol(), signal_period, 2);
   
  Teeth = iAlligator(Symbol(), signal_period, JawPeriod, JawShift, TeethPeriod, TeethShift, 
                           LipsPeriod, LipsShift, AlligatorMethod, AlligatorPrice, 
                           MODE_GATORTEETH, 1);// ����� ����� - ���� ������� ���� ��������� ������� � ��������� ���� ��,
                                               // �� ��� 
   fractal_h = iFractals(Symbol(),signal_period, MODE_UPPER, 3);
   if(fractal_h!=0) { upfractal=iFractals(Symbol(), signal_period, MODE_UPPER, 3); time_cur_up = TimeCurrent();} 
   fractal_l = iFractals(Symbol(), signal_period, MODE_LOWER, 3);
   if(fractal_l!=0)  { dwfractal=iFractals(Symbol(),signal_period, MODE_LOWER, 3); time_cur_dw = TimeCurrent();}   
   
   Terminal();                         // ������� ����� ������� 
   Events();                           // ���������� � ��������
   Trade(Criterion());                 // �������� �������
   
   Inform(0);                          // ��� �������������� ��������
   //---------------------------���� �������---------------------------------------------------------------------------------------
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
                ticket = OrderTicket( );                         // ����� ������
       double   orderLots = OrderLots();                         // Lots   
       double   orderProfit = OrderProfit() + OrderSwap();       // Profit
       double   Price = OrderOpenPrice();                        // ���� �������� ��������� ������
       double   SL =  OrderStopLoss();                           // �������� StopLoss ������
       double   TP = OrderTakeProfit();                          // �������� TakeProfit ������
          
             if (ticket>0)                                               // ���� ������� ���������
                    {
                             while(OrderSelect(ticket,SELECT_BY_TICKET)==false)       // ���� ����� ������
                                 {
                                   Sleep(100);
                                 }
                                  double OpenPrice=OrderOpenPrice();
                    }
                 
         
      orderCount++;                     // ������� ������ (�� ������ 10)
     
      // �������� �� ���������� ��������
      
      double loss = - ((orderProfit * 100.0) / AccountBalance());
      if (loss > MaxLoss)
      {
         Print ("MaxLoss");
         Close_All(0);                 // ������� � ������� ��� 
         Close_All(1);                 
         Close_All(4);                 
         Close_All(5);                 
         IsExpertFailed = true;
         return;
      }                
      
       while (!IsTradeAllowed() || !IsConnected()) Sleep(5000); RefreshRates();
       
      //----------------------------������ ��������������� ��� ���� ������ �� ���� �����------------------
      if (UseTrailing && orderCount > 0 && type ==0)   // ������� ���� �� �������� �������� - � ����������� �� ��������� trlinloss (������� �� � ���� ������)
          {     
           if (orderType == OP_BUY)  SampleTrailing_texbook (0);          // ���� ���
           if (orderType == OP_SELL) SampleTrailing_texbook (1);          // ���� ����
          }      
    
      if (UseTrailing && orderCount > 0 && type ==1) TrailingByFractals (ticket,signal_period, trlinloss);        //���� �� ��������� + ������
      if (UseTrailing && orderCount > 0 && type ==2) TrailingByShadows  (ticket,signal_period, trlinloss);        //���� �� ����� N ������ + ������
      if (UseTrailing && orderCount > 0 && type ==3) TrailingBy2ATR     (ticket,signal_period, ATRPeriod_1, ATRPeriod_2, Mul, trlinloss); //���� �� 2-� ���
      if (UseTrailing && orderCount > 0 && type ==4) TrailingByPriceChannel (ticket, bars_n, indent);             // �� �������� ������ + ������
      if (UseTrailing && orderCount > 0 && type ==5) TrailingByMA (ticket, signal_period, Period_MA_tral,indent); // �� �� + ������
      if (UseTrailing && orderCount > 0 && type ==6) TrailingFiftyFifty (ticket, signal_period, Mul_fifty, trlinloss);  //�����������
      
       if (UseTrailing && orderCount > 0 && type == 7)                     // ���� �� �������� �������� - �� SAR
          {     
           if (orderType == OP_BUY)  SARTrailing_texbook (0);          // ���� ���
           if (orderType == OP_SELL) SARTrailing_texbook (1);          // ���� ����
          }          
     Print( "������� ����: ����� ����� ������� = " ,orderCount);
     }   
//--------------------------------------------------------------------------------------------------------------------------------------     
   
   
   //==== ���� �����������===========================================
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
   return;                             // ����� �� start()
  }
//--------------------------------------------------------------- 6 --
int deinit()                           // ����. ������� deinit()
  {
   Inform(-1);                         // ��� �������� ��������
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
   return;                             // ����� �� deinit()
  }
//--------------------------------------------------------------- 7 --

