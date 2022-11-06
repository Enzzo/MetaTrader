//+------------------------------------------------------------------+
//|                                                          TDI.mq4 |
//|                                       Copyright © 2009, WalkMan. |
//|                                                                  |
//+------------------------------------------------------------------+
//|  Price & Line Type settings:                                     |                
//|   RSI Price settings                                             |               
//|   0 = Close price     [DEFAULT]                                  |               
//|   1 = Open price.                                                |               
//|   2 = High price.                                                |               
//|   3 = Low price.                                                 |               
//|   4 = Median price, (high+low)/2.                                |               
//|   5 = Typical price, (high+low+close)/3.                         |               
//|   6 = Weighted close price, (high+low+close+close)/4.            |
//|                                                                  |
//|   RSI Price Line & Signal Line Type settings                     |
//|   0 = Simple moving average       [DEFAULT]                      |
//|   1 = Exponential moving average                                 |
//|   2 = Smoothed moving average                                    |
//|   3 = Linear weighted moving average                             |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2009, WalkMan."
#property link      ""
bool Work=true;                    // Эксперт будет работать.
extern double Lots = 0.01;
extern int RSI_Period = 13;         //8-25
extern int RSI_Price = 0;           //0-6
extern int Volatility_Band = 34;    //20-40
extern int RSI_Price_Line = 2;      
extern int RSI_Price_Type = 0;      //0-3
extern int Trade_Signal_Line = 7;   
extern int Trade_Signal_Type = 0;   //0-3
extern int slippage = 0;
extern int magic = 123456;
static int prevtime = 0;
static int Sell = 0;
static int Buy = 0;

int init()
  {
     prevtime = Time[0];
   return(0);
}


int deinit()
  {


   return(0);
  }


int start()
  {
  
if (! IsTradeAllowed()) {
      return(0);
   }
   
      if(Work==false)                              // Критическая ошибка
     {
      Alert("Критическая ошибка. Эксперт не работает.");
      return;                                   // Выход из start()
     }  
   
   if (Time[0] == prevtime) {
      return(0);
   }
   prevtime = Time[0];
   
   
 /*  
   Print("Buy =", Buy);
   Print("Sell =", Sell);
   */
   
double RSI = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 0);
double RSI1 = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 4, 1);
double HighLine = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 1, 0);
double HighLine1 = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 1, 1);
double LowLine = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 3, 0);
double LowLine1 = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 3, 1);
double BLine = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 0);
double BLine1 = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 2, 1);
double Signal = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 0);
double Signal1 = iCustom(NULL, 0, "Traders_Dynamic_Index", RSI_Period, RSI_Price, Volatility_Band, RSI_Price_Line, RSI_Price_Type, Trade_Signal_Line, Trade_Signal_Type, 5, 1);
int    st = iStochastic(Symbol(), PERIOD_CURRENT, 5, 3, 0, MODE_SMA, 0,MODE_MAIN, 0);
//

if(RSI1>HighLine1 && RSI<HighLine && OrderType()!=OP_SELL && OrdersTotal()<=1)
 {
  Sell=Sell+3;
 } 

if(RSI1<LowLine1 && RSI>LowLine && OrderType()!=OP_BUY && OrdersTotal()<=1)
 {
  Buy=Buy+3;
 }

if(RSI1<Signal1 && RSI>Signal && OrderType()!=OP_BUY && OrdersTotal()<=1)
 {
  Buy=Buy+2;
 }

if(RSI1>Signal1 && RSI<Signal && OrderType()!=OP_SELL && OrdersTotal()<=1)
 {
  Sell=Sell+2;
 }

if(RSI1<BLine1 && RSI>BLine && OrderType()!=OP_BUY && OrdersTotal()<=1)
 {
  Buy=Buy+3;
 }

if(RSI1>BLine1 && RSI<BLine && OrderType()!=OP_SELL && OrdersTotal()<=1)
 {
  Sell=Sell+3;
 }
     
   int ticket = -1;
   int total = OrdersTotal();
   for (int i = total - 1; i >= 0; i--) {
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if ((OrderSymbol() == Symbol()) && (OrderMagicNumber() == magic)) {
         int prevticket = OrderTicket();
             if (Buy >= 5)
    {
     OrderClose(prevticket,OrderLots(),Ask,3,Red);
    }

   if (Sell>= 5)
    {
     OrderClose(prevticket,OrderLots(),Bid,3,Blue);
    }  
        return(0);
      }
   }

          if (Sell >= 5 && OrdersTotal()==0 && st <= 20)
           {
            ticket = OrderSend(Symbol(),OP_SELL,Lots,Bid,slippage,0,0, WindowExpertName(), magic, 0, Red);
            Sell=0;
           }
          if (Buy >= 5  && OrdersTotal()==0 && st >= 80)
           {
            ticket = OrderSend(Symbol(),OP_BUY,Lots,Ask,slippage,0,0,WindowExpertName(), magic, 0, Blue);
            Buy=0;
           }

   return(0);
  }


